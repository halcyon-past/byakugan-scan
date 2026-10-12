import AppKit
import SwiftUI
import UserNotifications

/// Application delegate: sets up the menu bar item, hotkeys, and notification permissions.
@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    // MARK: - Properties
    private var statusItem: NSStatusItem?
    private var popover: NSPopover?
    private var mainWindow: NSWindow?
    
    // Hotkey IDs for cleanup
    private var textScanHotkeyID: UInt32?
    private var qrScanHotkeyID: UInt32?
    private var barcodeScanHotkeyID: UInt32?
    
    // MARK: - Lifecycle
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Hide dock icon – we live in the menu bar
        NSApp.setActivationPolicy(.accessory)
        
        setupMenuBarItem()
        setupHotkeys()
        requestNotificationPermissions()
        
        // Listen for settings changes to re-register hotkeys
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(settingsDidChange),
            name: NSNotification.Name(AppConstants.Notifications.settingsChanged),
            object: nil
        )
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        HotkeyService.shared.unregisterAll()
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
            pop.contentSize = NSSize(width: 340, height: 460)
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
    
    @objc func triggerTextScan() {
        ScanCoordinator.shared.startTextScan()
    }
    
    @objc func triggerQRScan() {
        ScanCoordinator.shared.startQRScan()
    }
    
    @objc func triggerBarcodeScan() {
        ScanCoordinator.shared.startBarcodeScan()
    }
    
    @objc private func openSettings() {
        NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @objc private func openAbout() {
        NSApp.orderFrontStandardAboutPanel(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    // MARK: - Hotkeys
    
    private func setupHotkeys() {
        let settings = AppSettings.shared
        
        if let parsed = HotkeyService.parseShortcut(settings.textScanShortcut) {
            textScanHotkeyID = HotkeyService.shared.register(
                keyCode: parsed.keyCode,
                modifiers: parsed.modifiers
            ) {
                Task { @MainActor in
                    ScanCoordinator.shared.startTextScan()
                }
            }
        }
        
        if let parsed = HotkeyService.parseShortcut(settings.qrScanShortcut) {
            qrScanHotkeyID = HotkeyService.shared.register(
                keyCode: parsed.keyCode,
                modifiers: parsed.modifiers
            ) {
                Task { @MainActor in
                    ScanCoordinator.shared.startQRScan()
                }
            }
        }
        
        if let parsed = HotkeyService.parseShortcut(settings.barcodeScanShortcut) {
            barcodeScanHotkeyID = HotkeyService.shared.register(
                keyCode: parsed.keyCode,
                modifiers: parsed.modifiers
            ) {
                Task { @MainActor in
                    ScanCoordinator.shared.startBarcodeScan()
                }
            }
        }
    }
    
    @objc private func settingsDidChange() {
        // Re-register hotkeys when settings change
        if let id = textScanHotkeyID { HotkeyService.shared.unregister(id: id) }
        if let id = qrScanHotkeyID { HotkeyService.shared.unregister(id: id) }
        if let id = barcodeScanHotkeyID { HotkeyService.shared.unregister(id: id) }
        setupHotkeys()
    }
    
    // MARK: - Notifications
    
    private func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }
}
