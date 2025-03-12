//
//  PowerToolApp.swift
//  PowerTool
//
//  Created by Omer Dan on 07/03/2025.
//

import SwiftUI

@main
struct PowerToolApp: App {
    // We use an `@StateObject` for the manager that controls showing/hiding the Preferences window.
    @StateObject private var preferencesWindowManager = PreferencesWindowManager()
    @StateObject private var rightClickViewModel = RightClickViewModel()
    
    var body: some Scene {
        WindowGroup {
            // Your main app UI here. Could be a Dashboard, a main window, etc.
            // For demonstration, we’ll just show a simple text for the main UI.
            ContentView()
                .frame(minWidth: 600, minHeight: 400)
                .environmentObject(preferencesWindowManager)
                .environmentObject(rightClickViewModel)
        }
        .commands {
            CommandGroup(after: .appInfo) {
                // Add a Preferences command to the app menu (⌘,)
                Button("Preferences…") {
                    preferencesWindowManager.openPreferences()
                }
                .keyboardShortcut(",", modifiers: .command)
            }
        }
    }
}
