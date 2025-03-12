//
//  FinderSync.swift
//  PowerToolFinderExtension
//
//  Created by Omer Dan on 12/03/2025.
//

import Cocoa
import FinderSync

// IMPORTANT: Make sure the Swift file is part of the Finder Extension target,
// not just the main app target.
class FinderExtension: FIFinderSync {

    override init() {
        super.init()

        // Specify the directories you want the extension to appear in.
        // If you want it to appear everywhere, set it to the root slash.
        FIFinderSyncController.default().directoryURLs = [URL(fileURLWithPath: "/")]
    }

    /// This is called by the system when it needs to build the context menu for Finder.
    override func menu(for menuKind: FIMenuKind) -> NSMenu? {
        // 1) Load the user’s file-type preferences (e.g., from an App Group or standard defaults).
        let fileTypes = loadFileTypesFromUserDefaults()

        // 2) Build the menu items:
        let menu = NSMenu(title: "")
        for fileType in fileTypes where fileType.isEnabled {
            let itemTitle = "New \(fileType.displayName)"
            let item = NSMenuItem(title: itemTitle, action: #selector(createFile(_:)), keyEquivalent: "")
            item.representedObject = fileType // so we know which type to create
            menu.addItem(item)
        }
        return menu
    }

    @objc func createFile(_ sender: AnyObject?) {
        guard
            let menuItem = sender as? NSMenuItem,
            let fileType = menuItem.representedObject as? FileType
        else {
            return
        }

        // 3) Figure out which folder the user right-clicked on:
        guard let targetFolder = FIFinderSyncController.default().targetedURL() else {
            return
        }

        // 4) Create the new file in that folder
        let newFileURL = targetFolder.appendingPathComponent("New.\(fileType.suffix)")
        FileManager.default.createFile(atPath: newFileURL.path, contents: nil, attributes: nil)
    }

    // Example of reading from an App Group or standard defaults:
    func loadFileTypesFromUserDefaults() -> [FileType] {
        // If you set up an App Group:
        // let defaults = UserDefaults(suiteName: "grou     bp.com.yourcompany.PowerTool") ?? .standard
        let defaults = UserDefaults.standard

        guard
            let data = defaults.data(forKey: "fileTypes"),
            let decoded = try? JSONDecoder().decode([FileType].self, from: data)
        else {
            return [] // or return a default list
        }
        return decoded
    }
}

//import Cocoa
//import FinderSync
//
//class FinderSync: FIFinderSync {
//
//    var myFolderURL = URL(fileURLWithPath: "/Users/Shared/MySyncExtension Documents")
//
//    override init() {
//        super.init()
//
//        NSLog("FinderSync() launched from %@", Bundle.main.bundlePath as NSString)
//
//        // Set up the directory we are syncing.
//        FIFinderSyncController.default().directoryURLs = [self.myFolderURL]
//
//        // Set up images for our badge identifiers. For demonstration purposes, this uses off-the-shelf images.
//        FIFinderSyncController.default().setBadgeImage(NSImage(named: NSImage.colorPanelName)!, label: "Status One" , forBadgeIdentifier: "One")
//        FIFinderSyncController.default().setBadgeImage(NSImage(named: NSImage.cautionName)!, label: "Status Two", forBadgeIdentifier: "Two")
//    }
//
//    // MARK: - Primary Finder Sync protocol methods
//
//    override func beginObservingDirectory(at url: URL) {
//        // The user is now seeing the container's contents.
//        // If they see it in more than one view at a time, we're only told once.
//        NSLog("beginObservingDirectoryAtURL: %@", url.path as NSString)
//    }
//
//
//    override func endObservingDirectory(at url: URL) {
//        // The user is no longer seeing the container's contents.
//        NSLog("endObservingDirectoryAtURL: %@", url.path as NSString)
//    }
//
//    override func requestBadgeIdentifier(for url: URL) {
//        NSLog("requestBadgeIdentifierForURL: %@", url.path as NSString)
//
//        // For demonstration purposes, this picks one of our two badges, or no badge at all, based on the filename.
//        let whichBadge = abs(url.path.hash) % 3
//        let badgeIdentifier = ["", "One", "Two"][whichBadge]
//        FIFinderSyncController.default().setBadgeIdentifier(badgeIdentifier, for: url)
//    }
//
//    // MARK: - Menu and toolbar item support
//
//    override var toolbarItemName: String {
//        return "FinderSy"
//    }
//
//    override var toolbarItemToolTip: String {
//        return "FinderSy: Click the toolbar item for a menu."
//    }
//
//    override var toolbarItemImage: NSImage {
//        return NSImage(named: NSImage.cautionName)!
//    }
//
//    override func menu(for menuKind: FIMenuKind) -> NSMenu {
//        // Produce a menu for the extension.
//        let menu = NSMenu(title: "")
//        menu.addItem(withTitle: "Example Menu Item", action: #selector(sampleAction(_:)), keyEquivalent: "")
//        return menu
//    }
//
//    @IBAction func sampleAction(_ sender: AnyObject?) {
//        let target = FIFinderSyncController.default().targetedURL()
//        let items = FIFinderSyncController.default().selectedItemURLs()
//
//        let item = sender as! NSMenuItem
//        NSLog("sampleAction: menu item: %@, target = %@, items = ", item.title as NSString, target!.path as NSString)
//        for obj in items! {
//            NSLog("    %@", obj.path as NSString)
//        }
//    }
//
//}
//
