import AppKit
import SwiftUI
import UserNotifications
import Combine

/// Application delegate: sets up the menu bar item, hotkeys, settings window, and notification permissions.
@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    // MARK: - Singleton reference for easy access
    static weak var shared: AppDelegate?
    
    // MARK: - Properties
    private var statusItem: NSStatusItem?
    private var popover: NSPopover?
    private var settingsWindow: NSWindow?
    
    // Hotkey IDs for cleanup
    private var activeHotkeyIDs: [UInt32] = []
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        Self.shared = self
        
        // Ensure no conflicting instance (Dev vs Prod) holds Carbon hotkeys
        terminateConflictingInstance()
        
        // Hide dock icon – we live in the menu bar
        NSApp.setActivationPolicy(.accessory)
        
        if AppSettings.shared.showInMenuBar {
            setupMenuBarItem()
        }
        setupMenuBarVisibilityObserver()
        setupHotkeys()
        requestNotificationPermissions()
        setupScanningStateObserver()
        
        // Pre-warm the Vision & Neural Engine models in background
        OCRService.shared.warmUp()
        
        // Check for updates if enabled in user settings (production only)
        if !AppConstants.App.isDevelopment && AppSettings.shared.autoCheckForUpdates {
            Task {
                await UpdateService.shared.checkForUpdates(silent: true)
            }
        }
        
        // Listen for settings window triggers & setting changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(openSettings),
            name: NSNotification.Name("OpenSettingsWindow"),
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(settingsDidChange),
            name: NSNotification.Name(AppConstants.Notifications.settingsChanged),
            object: nil
        )
        // Setup URL Scheme route handlers
        setupURLRouting()
        
        // On initial first run, present Settings so user immediately knows the app is active
        if !AppSettings.shared.hasCompletedInitialLaunch {
            AppSettings.shared.hasCompletedInitialLaunch = true
            DispatchQueue.main.async { [weak self] in
                self?.openSettings()
            }
        }
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        // If the user closed or hid the menu bar icon, restore it when they click the app icon in Finder/Applications
        if !AppSettings.shared.showInMenuBar {
            AppSettings.shared.showInMenuBar = true
            if statusItem == nil {
                setupMenuBarItem()
            }
        }
        
        // Open Settings window so user receives clear, immediate visual confirmation
        openSettings()
        
        // Briefly flash the status bar item so the user sees where the menu bar icon lives
        if let button = statusItem?.button {
            button.highlight(true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                button.highlight(false)
            }
        }
        
        return true
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        HotkeyService.shared.unregisterAll()
    }
    
    // MARK: - URL Scheme & Deep Links
    
    func application(_ application: NSApplication, open urls: [URL]) {
        for url in urls {
            _ = URLRouteService.shared.handle(url: url)
        }
    }
    
    private func setupURLRouting() {
        URLRouteService.shared.onScan = { [weak self] mode in
            Task { @MainActor in
                self?.closePopover()
                switch mode {
                case .text:
                    ScanCoordinator.shared.startTextScan()
                case .qr:
                    ScanCoordinator.shared.startQRScan()
                case .barcode:
                    ScanCoordinator.shared.startBarcodeScan()
                case .last:
                    ScanCoordinator.shared.startLastSelectionScan()
                }
            }
        }
        
        URLRouteService.shared.onSettings = { [weak self] in
            Task { @MainActor in
                self?.openSettings()
            }
        }
        
        URLRouteService.shared.onHistory = { [weak self] in
            Task { @MainActor in
                self?.openHistory()
            }
        }
    }
    
    // MARK: - Menu Bar
    
    private func setupMenuBarItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem?.button {
            resetMenuBarIcon()
            button.action = #selector(statusBarButtonClicked(_:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
            button.target = self
        }
    }
    
    private func setupMenuBarVisibilityObserver() {
        AppSettings.shared.$showInMenuBar
            .receive(on: DispatchQueue.main)
            .sink { [weak self] show in
                guard let self = self else { return }
                if show && self.statusItem == nil {
                    self.setupMenuBarItem()
                } else if !show && self.statusItem != nil {
                    if let item = self.statusItem {
                        NSStatusBar.system.removeStatusItem(item)
                        self.statusItem = nil
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupScanningStateObserver() {
        ScanCoordinator.shared.$isScanning
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isScanning in
                self?.handleScanningStateChange(isScanning)
            }
            .store(in: &cancellables)
    }
    
    private func handleScanningStateChange(_ isScanning: Bool) {
        guard let button = statusItem?.button else { return }
        
        if isScanning {
            // Live scanning activity state: illuminated/active reticle
            let activeImage = NSImage(systemSymbolName: "viewfinder.circle.fill", accessibilityDescription: "\(AppConstants.App.name) Scanning...")
            activeImage?.isTemplate = true
            activeImage?.size = NSSize(width: 18, height: 18)
            button.image = activeImage
            if AppConstants.App.isDevelopment {
                button.title = " DEV"
                button.imagePosition = .imageLeading
            }
        } else {
            // Briefly flash success check reticle before restoring default state
            if ScanCoordinator.shared.lastResult != nil && ScanCoordinator.shared.lastError == nil {
                let checkImage = NSImage(systemSymbolName: "checkmark.circle.fill", accessibilityDescription: "Scan Complete")
                checkImage?.isTemplate = true
                checkImage?.size = NSSize(width: 18, height: 18)
                button.image = checkImage
                if AppConstants.App.isDevelopment {
                    button.title = " DEV"
                    button.imagePosition = .imageLeading
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) { [weak self] in
                    self?.resetMenuBarIcon()
                }
            } else {
                resetMenuBarIcon()
            }
        }
    }
    
    private func resetMenuBarIcon() {
        guard let button = statusItem?.button else { return }
        let customImage = NSImage(named: "MenuBarIcon")
        let fallbackImage = NSImage(systemSymbolName: "eye.viewfinder", accessibilityDescription: AppConstants.App.name)
        let finalImage = (customImage ?? fallbackImage)?.copy() as? NSImage ?? fallbackImage
        finalImage?.isTemplate = true
        finalImage?.size = NSSize(width: 18, height: 18)
        button.image = finalImage
        
        if AppConstants.App.isDevelopment {
            button.title = " DEV"
            button.toolTip = "Byakugan Scan [DEV VERSION]"
            button.imagePosition = .imageLeading
        } else {
            button.title = ""
            button.toolTip = "Byakugan Scan"
        }
    }
    
    @objc private func statusBarButtonClicked(_ sender: NSStatusBarButton) {
        guard let event = NSApp.currentEvent else {
            togglePopover(sender)
            return
        }
        if event.type == .rightMouseUp {
            showContextMenu()
        } else {
            togglePopover(sender)
        }
    }
    
    private func togglePopover(_ sender: NSStatusBarButton) {
        if popover == nil {
            let pop = NSPopover()
            pop.contentSize = NSSize(width: 340, height: 480)
            pop.behavior = .transient
            pop.contentViewController = NSHostingController(
                rootView: MenuBarPopoverView()
                    .environmentObject(AppSettings.shared)
                    .environmentObject(HistoryService.shared)
            )
            self.popover = pop
        }
        
        if popover?.isShown == true {
            popover?.performClose(sender)
        } else {
            popover?.show(relativeTo: sender.bounds, of: sender, preferredEdge: .minY)
        }
    }
    
    private func showContextMenu() {
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Capture Text", action: #selector(triggerTextScan), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Capture Last Selection", action: #selector(triggerLastSelectionScan), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Scan QR Code", action: #selector(triggerQRScan), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Scan Barcode", action: #selector(triggerBarcodeScan), keyEquivalent: ""))
        menu.addItem(.separator())
        
        if AppConstants.App.isDevelopment {
            menu.addItem(NSMenuItem(title: "⇄ Switch to Production App", action: #selector(switchToOtherApp), keyEquivalent: ""))
            menu.addItem(.separator())
        } else if AppSwitcher.isDevInstalled {
            menu.addItem(NSMenuItem(title: "⇄ Switch to Dev App", action: #selector(switchToOtherApp), keyEquivalent: ""))
            menu.addItem(.separator())
        }
        
        menu.addItem(NSMenuItem(title: "Settings...", action: #selector(openSettings), keyEquivalent: ","))
        menu.addItem(NSMenuItem(title: "About \(AppConstants.App.name)", action: #selector(openAbout), keyEquivalent: ""))
        menu.addItem(.separator())
        menu.addItem(NSMenuItem(title: "Quit \(AppConstants.App.name)", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        if let button = statusItem?.button {
            menu.popUp(positioning: nil, at: NSPoint(x: 0, y: button.bounds.height + 4), in: button)
        }
    }
    
    private func terminateConflictingInstance() {
        let otherBundleID = AppConstants.App.isDevelopment ? AppConstants.App.prodBundleID : AppConstants.App.devBundleID
        let runningApps = NSRunningApplication.runningApplications(withBundleIdentifier: otherBundleID)
        for app in runningApps {
            app.terminate()
        }
    }
    
    @objc func switchToOtherApp() {
        closePopover()
        AppSwitcher.switchToOtherApp()
    }
    
    // MARK: - Actions
    
    func closePopover() {
        popover?.performClose(nil)
    }
    
    @objc func triggerTextScan() {
        closePopover()
        ScanCoordinator.shared.startTextScan()
    }
    
    @objc func triggerLastSelectionScan() {
        closePopover()
        ScanCoordinator.shared.startLastSelectionScan()
    }
    
    @objc func triggerQRScan() {
        closePopover()
        ScanCoordinator.shared.startQRScan()
    }
    
    @objc func triggerBarcodeScan() {
        closePopover()
        ScanCoordinator.shared.startBarcodeScan()
    }
    
    @objc func openHistory() {
        closePopover()
        if let button = statusItem?.button {
            togglePopover(button)
        }
        NotificationCenter.default.post(name: NSNotification.Name("SwitchToHistoryTab"), object: nil)
    }
    
    @objc func openSettings() {
        popover?.performClose(nil)
        
        if settingsWindow == nil {
            let window = NSWindow(
                contentRect: NSRect(
                    x: 0,
                    y: 0,
                    width: AppConstants.UI.settingsWindowWidth,
                    height: AppConstants.UI.settingsWindowHeight
                ),
                styleMask: [.titled, .closable, .miniaturizable, .resizable],
                backing: .buffered,
                defer: false
            )
            window.minSize = NSSize(width: 660, height: 500)
            window.center()
            window.title = "\(AppConstants.App.name) Settings"
            window.isReleasedWhenClosed = false
            window.level = .floating
            window.collectionBehavior = [.moveToActiveSpace, .participatesInCycle]
            window.contentView = NSHostingView(
                rootView: SettingsView()
                    .environmentObject(AppSettings.shared)
                    .environmentObject(HistoryService.shared)
            )
            self.settingsWindow = window
        }
        
        settingsWindow?.center()
        settingsWindow?.makeKeyAndOrderFront(nil)
        settingsWindow?.orderFrontRegardless()
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @objc private func openAbout() {
        NSApp.orderFrontStandardAboutPanel(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    // MARK: - Hotkeys
    
    private func setupHotkeys() {
        let settings = AppSettings.shared
        
        registerShortcut(settings.textScanShortcut) {
            ScanCoordinator.shared.startTextScan()
        }
        
        registerShortcut(settings.qrScanShortcut) {
            ScanCoordinator.shared.startQRScan()
        }
        
        registerShortcut(settings.barcodeScanShortcut) {
            ScanCoordinator.shared.startBarcodeScan()
        }
        
        registerShortcut(settings.captureLastSelectionShortcut) {
            ScanCoordinator.shared.startLastSelectionScan()
        }
        
        registerShortcut(settings.captureWithoutLineBreaksShortcut) {
            ScanCoordinator.shared.startTextScan(overridePreserveLineBreaks: false)
        }
        
        registerShortcut(settings.captureWithLineBreaksShortcut) {
            ScanCoordinator.shared.startTextScan(overridePreserveLineBreaks: true)
        }
        
        registerShortcut(settings.captureWithTTSShortcut) {
            ScanCoordinator.shared.startTextScan(overrideTTS: true)
        }
        
        registerShortcut(settings.stopSpeakingShortcut) {
            ScanCoordinator.shared.stopSpeaking()
        }
    }
    
    private func registerShortcut(_ shortcutString: String, action: @escaping () -> Void) {
        guard !shortcutString.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        guard let parsed = HotkeyService.parseShortcut(shortcutString) else { return }
        
        let id = HotkeyService.shared.register(keyCode: parsed.keyCode, modifiers: parsed.modifiers) {
            Task { @MainActor in
                action()
            }
        }
        activeHotkeyIDs.append(id)
    }
    
    @objc private func settingsDidChange() {
        // Unregister existing hotkeys and re-register newly saved ones
        for id in activeHotkeyIDs {
            HotkeyService.shared.unregister(id: id)
        }
        activeHotkeyIDs.removeAll()
        setupHotkeys()
    }
    
    // MARK: - Notifications
    
    private func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }
}
