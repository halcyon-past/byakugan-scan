import AppKit
import SwiftUI
import UserNotifications

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
    
    // MARK: - Lifecycle
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        Self.shared = self
        
        // Hide dock icon – we live in the menu bar
        NSApp.setActivationPolicy(.accessory)
        
        setupMenuBarItem()
        setupHotkeys()
        requestNotificationPermissions()
        
        // Pre-warm the Vision & Neural Engine models in background
        OCRService.shared.warmUp()
        
        // Check for updates if enabled in user settings
        if AppSettings.shared.autoCheckForUpdates {
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
            let customImage = NSImage(named: "MenuBarIcon")
            let fallbackImage = NSImage(systemSymbolName: "eye.viewfinder", accessibilityDescription: "Byakugan Scan")
            let finalImage = customImage ?? fallbackImage
            finalImage?.isTemplate = true
            button.image = finalImage
            button.action = #selector(statusBarButtonClicked(_:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
            button.target = self
        }
    }
    
    @objc private func statusBarButtonClicked(_ sender: NSStatusBarButton) {
        let event = NSApp.currentEvent!
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
        menu.addItem(NSMenuItem(title: "Settings...", action: #selector(openSettings), keyEquivalent: ","))
        menu.addItem(NSMenuItem(title: "About Byakugan Scan", action: #selector(openAbout), keyEquivalent: ""))
        menu.addItem(.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        statusItem?.menu = menu
        statusItem?.button?.performClick(nil)
        statusItem?.menu = nil
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
                contentRect: NSRect(x: 0, y: 0, width: 620, height: 520),
                styleMask: [.titled, .closable, .miniaturizable, .resizable],
                backing: .buffered,
                defer: false
            )
            window.center()
            window.title = "Byakugan Scan Settings"
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
