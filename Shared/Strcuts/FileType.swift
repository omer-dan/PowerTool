//
//  FileType.swift
//  PowerTool
//
//  Created by Omer Dan on 07/03/2025.
//


import Foundation

/// A model representing a file type entry in the preferences.
public struct FileType: Identifiable, Codable, Equatable {
    public let id: UUID
    public var displayName: String
    public var suffix: String
    public var isEnabled: Bool
    public var isExecutable: Bool
    
    init(id: UUID = UUID(),
         displayName: String,
         suffix: String,
         isEnabled: Bool,
         isExecutable: Bool) {
        self.id = id
        self.displayName = displayName
        self.suffix = suffix
        self.isEnabled = isEnabled
        self.isExecutable = isExecutable
    }
}
