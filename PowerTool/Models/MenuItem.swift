//
//  MenuItem.swift
//  PowerTool
//
//  Created by Omer Dan on 07/03/2025.
//

import SwiftUI

struct MenuItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let content: String
}

extension MenuItem {
    static let sampleItems = [
        MenuItem(title: "Right Click",
                 content: "Hello, this is the detail for Feature 1."),
        MenuItem(title: "Feature 2",
                 content: "Here’s more detail for Feature 2."),
        MenuItem(title: "Feature 3",
                 content: "Yet another Feature’s details.")
    ]
}
