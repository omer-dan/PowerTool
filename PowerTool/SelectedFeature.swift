//
//  SelectedFeature.swift
//  PowerTool
//
//  Created by Omer Dan on 10/03/2025.
//


import Foundation

enum SelectedFeature: String, CaseIterable, Identifiable {
    case rightClick = "Right-Click"
    case anotherFeature = "Feature 2"
    
    var id: String { self.rawValue }
}
