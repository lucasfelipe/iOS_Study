//
//  FrameworkGridViewIOS16.swift
//  Apple-Frameworks
//
//  Created by Lucas  Felipe on 27/03/2024.
//

import SwiftUI

struct FrameworkGridViewIOS16: View {
    
    @StateObject var viewModel = FrameworkGridViewIOS16ViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: viewModel.columns) {
                    ForEach(MockData.frameworks) { framework in
                        NavigationLink(value: framework) {
                            FrameworkTitleView(framework: framework)
                        }
                    }
                }
            }
            .navigationTitle("🍎 Frameworks")
            .navigationDestination(for: Framework.self) { framework in
                FrameworkDetailViewIOS16(framework: framework)
            }
        }
        .tint(Color(.label))
    }
}

#Preview {
    FrameworkGridViewIOS16()
        .preferredColorScheme(.dark)
}
