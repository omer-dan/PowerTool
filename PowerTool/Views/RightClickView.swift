//
//  RightClickView.swift
//  PowerTool
//
//  Created by Omer Dan on 07/03/2025.
//

import SwiftUI

struct RightClickView: View {
    @EnvironmentObject var rightClickViewModel: RightClickViewModel
    @State private var selectedFileTypeID: FileType.ID?
    @State private var showAddFileTypeDialog = false
    @State private var newFileTypeName = ""
    @State private var newFileTypeExtension = ""

    var body: some View {
        VStack {
            if rightClickViewModel.rightClickEnabled {
                Text("Manage Right Click File Types")
                    .font(.title)
                    .padding()
                
                Table(rightClickViewModel.fileTypes, selection: $selectedFileTypeID) {
                    TableColumn("File Type") { fileType in
                        TextField("Enter file type", text: getSetDisplayName(for: fileType))
                    }
                    TableColumn("Suffix") { suffix in
                        TextField("Enter file type", text: getSetSuffix(for: suffix))
                    }
                    TableColumn("Is enabled") { fileType in
                        Toggle("", isOn: getSetIsEnabled(for: fileType))
                            .labelsHidden()
                    }
                }
                .frame(minHeight: 200)
                
                HStack {
                    Button("Add File Type") {
                        showAddFileTypeDialog = true
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("Remove Selected") {
                        if let selectedID = selectedFileTypeID,
                           let index = rightClickViewModel.fileTypes.firstIndex(where: { $0.id == selectedID }) {
                            rightClickViewModel.fileTypes.remove(at: index)
                        }
                    }
                    .buttonStyle(.bordered)
                    .disabled(selectedFileTypeID == nil)
                    
                    Toggle("Enable Right Click", isOn: $rightClickViewModel.rightClickEnabled)
                        .onChange(of: rightClickViewModel.rightClickEnabled) { oldValue, newValue in
                            // Call function in RightClickViewModel when toggle is switched
                            // rightClickViewModel.toggleRightClickFeature(newValue)
                        }
                    
                }
                .padding()
            } else {
                Toggle("Enable Right Click", isOn: $rightClickViewModel.rightClickEnabled)
                    .onChange(of: rightClickViewModel.rightClickEnabled) { oldValue, newValue in
                        // Call function in RightClickViewModel when toggle is switched
                        // rightClickViewModel.toggleRightClickFeature(newValue)
                        rightClickViewModel.registerFileTypesWithFinder()

                    }
                    .padding()
            }
        }
        .sheet(isPresented: $showAddFileTypeDialog) {
            VStack {
                Text("Add New File Type")
                    .font(.headline)
                    .padding()

                TextField("Display Name", text: $newFileTypeName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                TextField("Extension", text: $newFileTypeExtension)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                HStack {
                    Button("Cancel") {
                        showAddFileTypeDialog = false
                    }
                    .padding()

                    Button("Save") {
                        rightClickViewModel.addFileType(newFileTypeName, newFileTypeExtension)
                        newFileTypeName = ""
                        newFileTypeExtension = ""
                        showAddFileTypeDialog = false
                        rightClickViewModel.registerFileTypesWithFinder()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
            .frame(width: 300)
            .padding()
        }
    }

    private func getSetDisplayName(for fileType: FileType) -> Binding<String> {
        guard let index = rightClickViewModel.fileTypes.firstIndex(where: { $0.id == fileType.id }) else {
            return .constant(fileType.displayName)
        }
        return Binding(
            get: { rightClickViewModel.fileTypes[index].displayName },
            set: { newValue in
                rightClickViewModel.fileTypes[index].displayName = newValue
//                rightClickViewModel.registerFileTypesWithFinder()
            }
        )
    }
    
    private func getSetSuffix(for fileType: FileType) -> Binding<String> {
        guard let index = rightClickViewModel.fileTypes.firstIndex(where: { $0.id == fileType.id }) else {
            return .constant(fileType.suffix)
        }
        return Binding(
            get: { rightClickViewModel.fileTypes[index].suffix },
            set: { newValue in
                rightClickViewModel.fileTypes[index].suffix = newValue
               // rightClickViewModel.registerFileTypesWithFinder()
            }
        )
    }
    
    private func getSetIsEnabled(for fileType: FileType) -> Binding<Bool> {
        guard let index = rightClickViewModel.fileTypes.firstIndex(where: { $0.id == fileType.id }) else {
            return .constant(fileType.isEnabled)
        }
        return Binding(
            get: { rightClickViewModel.fileTypes[index].isEnabled },
            set: { newValue in
                rightClickViewModel.fileTypes[index].isEnabled = newValue
//                rightClickViewModel.registerFileTypesWithFinder()
            }
        )
    }
}
