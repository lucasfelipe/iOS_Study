//
//  FrameworkGridViewModel.swift
//  Apple-Frameworks
//
//  Created by Lucas  Felipe on 27/03/2024.
//

import SwiftUI

final class FrameworkGridViewModel: ObservableObject {
    
    var selectedFramework: Framework? {
        didSet { isShowingDetailView = true }
    }
    
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    @Published var isShowingDetailView = false
}
