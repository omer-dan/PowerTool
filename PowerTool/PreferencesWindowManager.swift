//
//  PreferencesWindowManager.swift
//  PowerTool
//
//  Created by Omer Dan on 07/03/2025.
//


import SwiftUI

/// Manages showing/hiding a separate window for Preferences.
class PreferencesWindowManager: ObservableObject {
    private var window: NSWindow?

    func openPreferences() {
        if let window = window {
            // If the preferences window already exists, bring it to front
            window.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }

        // Create the preferences window
        let preferencesView = PreferencesView()
        let hostingController = NSHostingController(rootView: preferencesView)
        
        let newWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 700, height: 400),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )
        newWindow.title = "Preferences"
        newWindow.contentViewController = hostingController
        newWindow.center()
        
        // Store and show
        self.window = newWindow
        newWindow.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func closePreferences() {
        window?.close()
        window = nil
    }
}