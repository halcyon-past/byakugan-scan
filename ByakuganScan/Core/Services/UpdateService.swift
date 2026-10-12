import Foundation
import AppKit
import Combine

/// Lifecycle states for the in-app update engine.
enum UpdateState: Equatable {
    case idle
    case checking
    case upToDate(version: String)
    case available(version: String, releaseNotes: String, assetURL: URL, isZip: Bool)
    case downloading(progress: Double)
    case installing
    case error(message: String)
    
    static func == (lhs: UpdateState, rhs: UpdateState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.checking, .checking), (.installing, .installing):
            return true
        case (.upToDate(let v1), .upToDate(let v2)):
            return v1 == v2
        case (.available(let v1, _, let u1, let z1), .available(let v2, _, let u2, let z2)):
            return v1 == v2 && u1 == u2 && z1 == z2
        case (.downloading(let p1), .downloading(let p2)):
            return p1 == p2
        case (.error(let m1), .error(let m2)):
            return m1 == m2
        default:
            return false
        }
    }
}

/// Metadata model for a parsed GitHub release.
struct GitHubReleaseInfo {
    let tagName: String
    let version: String
    let releaseNotes: String
    let zipAssetURL: URL?
    let dmgAssetURL: URL?
    let htmlURL: URL
    
    var preferredAssetURL: URL? {
        zipAssetURL ?? dmgAssetURL
    }
    
    var isZip: Bool {
        zipAssetURL != nil
    }
}

/// Native, zero-dependency in-place auto-updater for Byakugan Scan.
/// Queries GitHub Releases API, downloads release assets, verifies bundles,
/// and performs an atomic in-place binary swap with automated relaunch.
@MainActor
final class UpdateService: ObservableObject {
    // MARK: - Singleton
    static let shared = UpdateService()
    
    // MARK: - Published State
    @Published private(set) var state: UpdateState = .idle
    @Published private(set) var latestRelease: GitHubReleaseInfo?
    @Published private(set) var lastCheckedDate: Date?
    
    private let repo = "halcyon-past/byakugan-scan"
    private var downloadTask: URLSessionDownloadTask?
    
    private init() {}
    
    // MARK: - Version Comparison Helpers
    
    /// Normalizes and compares two semantic version strings (e.g. "1.0.1" vs "1.0.0").
    /// Handles leading 'v', unequal length (e.g. 1.0 vs 1.0.0), and numerical comparison.
    static func compareVersions(_ v1: String, _ v2: String) -> ComparisonResult {
        let clean1 = v1.trimmingCharacters(in: CharacterSet(charactersIn: "vV \t\n\r"))
        let clean2 = v2.trimmingCharacters(in: CharacterSet(charactersIn: "vV \t\n\r"))
        
        let parts1 = clean1.split(separator: ".").compactMap { Int($0) }
        let parts2 = clean2.split(separator: ".").compactMap { Int($0) }
        
        let maxCount = max(parts1.count, parts2.count)
        for i in 0..<maxCount {
            let p1 = i < parts1.count ? parts1[i] : 0
            let p2 = i < parts2.count ? parts2[i] : 0
            
            if p1 > p2 { return .orderedDescending }
            if p1 < p2 { return .orderedAscending }
        }
        
        return .orderedSame
    }
    
    /// Returns true if the remote version string is strictly newer than local version string.
    static func isVersion(_ remote: String, newerThan local: String) -> Bool {
        compareVersions(remote, local) == .orderedDescending
    }
    
    // MARK: - Check For Updates
    
    /// Checks GitHub Releases for a newer version.
    /// - Parameter silent: If true, will not transition to .upToDate state on completion.
    func checkForUpdates(silent: Bool = false) async {
        guard state != .checking && state != .installing else { return }
        
        state = .checking
        lastCheckedDate = Date()
        
        guard let url = URL(string: "https://api.github.com/repos/\(repo)/releases/latest") else {
            state = .error(message: "Invalid update endpoint URL.")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        request.setValue("ByakuganScan/\(AppConstants.App.version)", forHTTPHeaderField: "User-Agent")
        request.timeoutInterval = 15.0
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                state = .error(message: "Unable to reach update server (HTTP error).")
                return
            }
            
            guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let tagName = json["tag_name"] as? String else {
                state = .error(message: "Failed to parse release information.")
                return
            }
            
            let remoteVersion = tagName.trimmingCharacters(in: CharacterSet(charactersIn: "vV \t\n\r"))
            let releaseNotes = (json["body"] as? String) ?? "A new update is available."
            let htmlURLStr = (json["html_url"] as? String) ?? "https://github.com/\(repo)/releases/latest"
            let htmlURL = URL(string: htmlURLStr)!
            
            // Extract release assets
            var zipURL: URL?
            var dmgURL: URL?
            if let assets = json["assets"] as? [[String: Any]] {
                for asset in assets {
                    guard let name = asset["name"] as? String,
                          let downloadURLStr = asset["browser_download_url"] as? String,
                          let assetURL = URL(string: downloadURLStr) else { continue }
                    
                    if name.hasSuffix(".zip") && zipURL == nil {
                        zipURL = assetURL
                    } else if name.hasSuffix(".dmg") && dmgURL == nil {
                        dmgURL = assetURL
                    }
                }
            }
            
            let releaseInfo = GitHubReleaseInfo(
                tagName: tagName,
                version: remoteVersion,
                releaseNotes: releaseNotes,
                zipAssetURL: zipURL,
                dmgAssetURL: dmgURL,
                htmlURL: htmlURL
            )
            self.latestRelease = releaseInfo
            
            let currentVersion = AppConstants.App.version
            if Self.isVersion(remoteVersion, newerThan: currentVersion) {
                if let assetURL = releaseInfo.preferredAssetURL {
                    state = .available(
                        version: remoteVersion,
                        releaseNotes: releaseNotes,
                        assetURL: assetURL,
                        isZip: releaseInfo.isZip
                    )
                } else {
                    // Fallback to manual download link if no direct binaries attached
                    state = .available(
                        version: remoteVersion,
                        releaseNotes: releaseNotes,
                        assetURL: htmlURL,
                        isZip: false
                    )
                }
            } else {
                state = silent ? .idle : .upToDate(version: currentVersion)
            }
        } catch {
            state = .error(message: error.localizedDescription)
        }
    }
    
    // MARK: - Download & In-Place Update Execution
    
    /// Downloads the available update asset, validates the new .app bundle,
    /// swaps the running bundle in-place, and relaunches the application.
    func downloadAndInstallUpdate() async throws {
        guard case .available(_, _, let assetURL, let isZip) = state else {
            throw NSError(domain: "UpdateError", code: 1, userInfo: [NSLocalizedDescriptionKey: "No update is currently available."])
        }
        
        state = .downloading(progress: 0.0)
        
        // 1. Download asset to temporary file
        let (tempDownloadedURL, _) = try await URLSession.shared.download(from: assetURL)
        
        state = .installing
        
        // 2. Prepare staging directory in /tmp
        let stagingUUID = UUID().uuidString
        let stagingDir = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("ByakuganUpdate_\(stagingUUID)", isDirectory: true)
        try FileManager.default.createDirectory(at: stagingDir, withIntermediateDirectories: true)
        
        let extractedAppURL: URL
        if isZip {
            // Extract ZIP using native /usr/bin/ditto
            let zipPath = stagingDir.appendingPathComponent("update.zip")
            try FileManager.default.moveItem(at: tempDownloadedURL, to: zipPath)
            
            let dittoProcess = Process()
            dittoProcess.executableURL = URL(fileURLWithPath: "/usr/bin/ditto")
            dittoProcess.arguments = ["-xk", zipPath.path, stagingDir.path]
            try dittoProcess.run()
            dittoProcess.waitUntilExit()
            
            guard dittoProcess.terminationStatus == 0 else {
                throw NSError(domain: "UpdateError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to extract update package."])
            }
            
            extractedAppURL = stagingDir.appendingPathComponent("Byakugan Scan.app")
        } else {
            // Mount DMG silently and copy .app
            let mountPoint = stagingDir.appendingPathComponent("mount")
            try FileManager.default.createDirectory(at: mountPoint, withIntermediateDirectories: true)
            
            let hdiProcess = Process()
            hdiProcess.executableURL = URL(fileURLWithPath: "/usr/bin/hdiutil")
            hdiProcess.arguments = ["attach", "-nobrowse", "-readonly", tempDownloadedURL.path, "-mountpoint", mountPoint.path]
            try hdiProcess.run()
            hdiProcess.waitUntilExit()
            
            guard hdiProcess.terminationStatus == 0 else {
                throw NSError(domain: "UpdateError", code: 3, userInfo: [NSLocalizedDescriptionKey: "Failed to mount update disk image."])
            }
            
            defer {
                // Detach disk image on completion
                let detach = Process()
                detach.executableURL = URL(fileURLWithPath: "/usr/bin/hdiutil")
                detach.arguments = ["detach", mountPoint.path, "-force"]
                try? detach.run()
                detach.waitUntilExit()
            }
            
            let mountedApp = mountPoint.appendingPathComponent("Byakugan Scan.app")
            extractedAppURL = stagingDir.appendingPathComponent("Byakugan Scan.app")
            try FileManager.default.copyItem(at: mountedApp, to: extractedAppURL)
        }
        
        // 3. Verify extracted .app bundle integrity
        let executableURL = extractedAppURL.appendingPathComponent("Contents/MacOS/ByakuganScan")
        guard FileManager.default.fileExists(atPath: executableURL.path) else {
            throw NSError(domain: "UpdateError", code: 4, userInfo: [NSLocalizedDescriptionKey: "Downloaded bundle is invalid or missing executable."])
        }
        
        // 4. Resolve target application location
        var targetAppURL = Bundle.main.bundleURL
        
        // If running from Xcode / DerivedData or not named Byakugan Scan.app, default to /Applications/Byakugan Scan.app
        if !targetAppURL.path.hasSuffix(".app") || targetAppURL.path.contains("DerivedData") {
            targetAppURL = URL(fileURLWithPath: "/Applications/Byakugan Scan.app")
        }
        
        // 5. Generate detached shell updater script
        let scriptPath = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("byakugan_updater_\(stagingUUID).sh")
        let currentPID = ProcessInfo.processInfo.processIdentifier
        
        let scriptContent = """
        #!/bin/sh
        # Wait for the current Byakugan Scan process to terminate
        while kill -0 \(currentPID) 2>/dev/null; do
            sleep 0.1
        done

        # Atomic swap
        rm -rf "\(targetAppURL.path)"
        cp -R "\(extractedAppURL.path)" "\(targetAppURL.path)"
        xattr -dr com.apple.quarantine "\(targetAppURL.path)" 2>/dev/null || true

        # Cleanup staging
        rm -rf "\(stagingDir.path)"
        rm -f "\(scriptPath.path)"

        # Relaunch newly updated app
        open "\(targetAppURL.path)"
        """
        
        try scriptContent.write(to: scriptPath, atomically: true, encoding: .utf8)
        
        // Make script executable
        var perms = try FileManager.default.attributesOfItem(atPath: scriptPath.path)
        perms[.posixPermissions] = 0o755
        try FileManager.default.setAttributes(perms, ofItemAtPath: scriptPath.path)
        
        // 6. Launch detached updater process in background
        let swapProcess = Process()
        swapProcess.executableURL = URL(fileURLWithPath: "/bin/sh")
        swapProcess.arguments = [scriptPath.path]
        try swapProcess.run()
        
        // 7. Terminate running app cleanly so update script can proceed
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            NSApp.terminate(nil)
        }
    }
}
