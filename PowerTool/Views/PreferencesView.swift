//
//  PreferencesView.swift
//  PowerTool
//
//  Created by Omer Dan on 07/03/2025.
//


import SwiftUI

/// A SwiftUI view that shows a TabView with multiple "Preferences" tabs.
struct PreferencesView: View {
    var body: some View {
        TabView {
            GeneralPreferencesView()
                .tabItem {
                    Label("General", systemImage: "gearshape")
                }
            
            // Our existing "Right Click" feature
            RightClickView()
                .tabItem {
                    Label("Right Click", systemImage: "contextualmenu.and.cursorarrow")
                }
            
            // Another placeholder feature to illustrate multiple tabs
            Feature2PreferencesView()
                .tabItem {
                    Label("Feature 2", systemImage: "star")
                }
        }
        .padding()
        .frame(minWidth: 700, minHeight: 400)
    }
}
