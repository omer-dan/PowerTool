//
//  TableView.swift
//  PowerTool
//
//  Created by Omer Dan on 07/03/2025.
//


import SwiftUI

/// A simple SwiftUI list that shows each FileType row with toggles and text fields.
struct TableView: View {
    @Binding var fileTypes: [FileType]
    
    var body: some View {
        List {
            ForEach($fileTypes) { $fileType in
                HStack {
                    // "Enabled" checkbox
                    Toggle("", isOn: $fileType.isEnabled)
                        .labelsHidden()
                        .frame(width: 30)
                    
                    // "File" column: display name
                    TextField("File name", text: $fileType.displayName)
                    
                    // "Suffix" column
                    TextField("Suffix", text: $fileType.suffix)
                        .frame(width: 60)
                        .multilineTextAlignment(.leading)
                    
                    // "Executable" checkbox
                    Toggle("Executable", isOn: $fileType.isExecutable)
                        .toggleStyle(.checkbox)
                }
            }
        }
        .frame(minHeight: 200)
    }
}