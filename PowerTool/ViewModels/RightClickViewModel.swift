//
//  RightClickViewModel.swift
//  PowerTool
//
//  Created by Omer Dan on 07/03/2025.
//

import SwiftUI
import AppKit

class RightClickViewModel: ObservableObject {
    
    @AppStorage("rightClickEnabled") var rightClickEnabled = false

    @Published var fileTypes: [FileType] = [] {
        didSet {
            save()
        }
    }

    private let defaultFileTypes = [
        FileType(displayName: "PDF Document", suffix: "pdf", isEnabled: true, isExecutable: true),
        FileType(displayName: "TXT file", suffix: "txt", isEnabled: true, isExecutable: true),
        FileType(displayName: "Word document", suffix: "docx", isEnabled: true, isExecutable: true),
    ]

    init() {
        loadFileTypes()
    }

    func loadFileTypes() {
        if let savedData = UserDefaults.standard.data(forKey: "fileTypes"),
           let decoded = try? JSONDecoder().decode([FileType].self, from: savedData) {
            fileTypes = decoded
        } else {
            fileTypes = defaultFileTypes
            save()
        }
    }

    func save() {
        if let encoded = try? JSONEncoder().encode(fileTypes) {
            UserDefaults.standard.set(encoded, forKey: "fileTypes")
        }
    }

    func addFileType(_ displyName: String, _ suffix: String, _ isEnabled: Bool = true, _ isExecutable: Bool = false) {
        fileTypes.append(FileType(displayName: displyName, suffix: suffix, isEnabled: isEnabled, isExecutable: isExecutable))
    }

    func removeFileType(at offsets: IndexSet) {
        fileTypes.remove(atOffsets: offsets)
    }

    func registerFileTypesWithFinder() {
        logToFile("Started registering file types with Finder...")
        print("Started registering file types with Finder...")

        let servicesPath = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Library/Services")

        // Ensure Services directory exists
        do {
            if !FileManager.default.fileExists(atPath: servicesPath.path) {
                try FileManager.default.createDirectory(at: servicesPath, withIntermediateDirectories: true)
                logToFile("✅ Created Services directory at: \(servicesPath.path)")
            } else {
                logToFile("ℹ️ Services directory already exists.")
            }
        } catch {
            logToFile("❌ Failed to create Services directory: \(error)")
            return
        }

        for fileType in fileTypes where fileType.isEnabled {
            let serviceFilePath = servicesPath.appendingPathComponent("New \(fileType.displayName).workflow")
            let automatorScript = """
            <?xml version="1.0" encoding="UTF-8"?>
            <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
            <plist version="1.0">
            <dict>
                <key>AMApplicationBuild</key>
                <string>524</string>
                <key>AMApplicationVersion</key>
                <string>2.10</string>
                <key>AMDocumentType</key>
                <string>AutomatorWorkflow</string>
                <key>actions</key>
                <array>
                    <dict>
                        <key>actionID</key>
                        <string>com.apple.automator.runapplescript</string>
                        <key>parameters</key>
                        <dict>
                            <key>AMActionScript</key>
                            <string>
                            on run {input, parameters}
                                set folderPath to POSIX path of (item 1 of input)
                                set newFilePath to folderPath & "/New.\(fileType.suffix)"
                                do shell script "touch " & quoted form of newFilePath
                            end run
                            </string>
                        </dict>
                    </dict>
                </array>
            </dict>
            </plist>
            """

            do {
                try automatorScript.write(to: serviceFilePath, atomically: true, encoding: .utf8)
                logToFile("✅ Created Finder Quick Action at: \(serviceFilePath.path)")
            } catch {
                logToFile("❌ Failed to create service file for \(fileType.displayName): \(error)")
            }
        }
        
        // Show a confirmation alert before opening System Preferences
        DispatchQueue.main.async {
            let alert = NSAlert()
            alert.messageText = "Enable Finder Quick Actions"
            alert.informativeText = "To use this feature, you need to enable it in System Preferences. Would you like to open the settings now?"
            alert.alertStyle = .warning
            alert.addButton(withTitle: "Open System Preferences")
            alert.addButton(withTitle: "Cancel")

            if alert.runModal() == .alertFirstButtonReturn {
                // Open System Preferences to enable Finder Quick Actions
                let preferencesCommand = """
                open "x-apple.systempreferences:com.apple.preference.extensions"
                """
                _ = try? Process.run(URL(fileURLWithPath: "/bin/zsh"), arguments: ["-c", preferencesCommand])
                self.logToFile("🔔 Prompted user to enable Quick Actions in System Preferences.")
            }
        }
    }
    
    // Called if the user toggles the feature on/off in the UI
    func toggleFeature(_ isOn: Bool) {
        rightClickEnabled = isOn
        if isOn {
            registerFileTypesWithFinder()
        }
        else {
            //unregisterFileTypesWithFinder()
        }
        // Update the feature to not work if it is false
    }
    
    func logToFile(_ message: String) {
        print(message)
        let logFilePath = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("PowerToolLogs.txt")
        let timestamp = Date().formatted(date: .numeric, time: .standard)
        let logMessage = "[\(timestamp)] \(message)\n"
        
        do {
            let handle = try FileHandle(forWritingTo: logFilePath)
            handle.seekToEndOfFile()
            if let data = logMessage.data(using: .utf8) {
                handle.write(data)
            }
            handle.closeFile()
        } catch {
            try? logMessage.write(to: logFilePath, atomically: true, encoding: .utf8)
        }
    }
}
