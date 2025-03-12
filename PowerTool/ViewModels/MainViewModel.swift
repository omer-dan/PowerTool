//
//  MainViewModel.swift
//  PowerTool
//
//  Created by Omer Dan on 10/03/2025.
//


import SwiftUI

class MainViewModel: ObservableObject {
    @Published var selectedFeature: SelectedFeature = .rightClick
    @Published var rightClickViewModel = RightClickViewModel()
    //@Published var anotherFeatureViewModel = AnotherFeatureViewModel()
}
