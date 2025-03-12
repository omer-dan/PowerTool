//
//  ContentView.swift
//  PowerTool
//
//  Created by Omer Dan on 07/03/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var mainViewModel = MainViewModel()

    var body: some View {
        NavigationView {
            List(SelectedFeature.allCases, selection: $mainViewModel.selectedFeature) { feature in
                Text(feature.rawValue)
                    .tag(feature)
            }
            .frame(minWidth: 200)
            .listStyle(SidebarListStyle())

            VStack {
                // Show the correct view depending on selected feature
                switch mainViewModel.selectedFeature {
                case .rightClick:
                    RightClickView()
                        .environmentObject(mainViewModel.rightClickViewModel)

                case .anotherFeature:
                    RightClickView()
                        .environmentObject(mainViewModel.rightClickViewModel)
//                    AnotherFeatureView()
//                        .environmentObject(mainViewModel.anotherFeatureViewModel)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}


struct DetailView: View {
    let menuItem: MenuItem

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(menuItem.title)
                .font(.headline)
            Text(menuItem.content)
        }
        .padding()
        .navigationTitle(menuItem.title)
    }
}

