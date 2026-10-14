import Foundation
import Combine

/// Service for persisting and managing scan history.
final class HistoryService: ObservableObject {
    // MARK: - Singleton
    static let shared = HistoryService()
    
    // MARK: - Published State
    @Published private(set) var history: [ScanResult] = []
    
    // MARK: - Private
    private let storageURL: URL
    private let maxItems: Int
    
    private init() {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let folder = AppConstants.App.isDevelopment ? "ByakuganScanDev" : "ByakuganScan"
        let dir = appSupport.appendingPathComponent(folder, isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        self.storageURL = dir.appendingPathComponent("history.json")
        self.maxItems = AppSettings.shared.maxHistoryItems
        load()
    }
    
    // MARK: - Public API
    
    /// Adds a new scan result to the history.
    func add(_ result: ScanResult) {
        guard AppSettings.shared.historyEnabled else { return }
        history.insert(result, at: 0)
        if history.count > AppSettings.shared.maxHistoryItems {
            history = Array(history.prefix(AppSettings.shared.maxHistoryItems))
        }
        save()
    }
    
    /// Removes a scan result from history by ID.
    func remove(id: UUID) {
        history.removeAll { $0.id == id }
        save()
    }
    
    /// Clears all history entries.
    func clearAll() {
        history.removeAll()
        save()
    }
    
    /// Toggles the favourite flag on a result.
    func toggleFavourite(id: UUID) {
        if let idx = history.firstIndex(where: { $0.id == id }) {
            history[idx].isFavourite.toggle()
            save()
        }
    }
    
    // MARK: - Persistence
    
    private func save() {
        guard let data = try? JSONEncoder().encode(history) else { return }
        try? data.write(to: storageURL, options: .atomic)
    }
    
    private func load() {
        guard let data = try? Data(contentsOf: storageURL),
              let decoded = try? JSONDecoder().decode([ScanResult].self, from: data) else { return }
        history = decoded
    }
}
