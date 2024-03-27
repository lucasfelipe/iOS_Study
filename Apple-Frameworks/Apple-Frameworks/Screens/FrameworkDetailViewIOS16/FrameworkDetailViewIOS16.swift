//
//  FrameworkDetailViewIOS16.swift
//  Apple-Frameworks
//
//  Created by Lucas  Felipe on 27/03/2024.
//

import SwiftUI

struct FrameworkDetailViewIOS16: View {
    var framework: Framework
    @State private var isShowingSafariView = false
    
    var body: some View {
        VStack {
            
            FrameworkTitleView(framework: framework)
            
            Text(framework.description)
                .font(.body)
                .padding()
            
            Spacer()
            
            Button {
                isShowingSafariView = true
            } label: {
                AFButton(title: "Learn More")
            }
        }
        .fullScreenCover(isPresented: $isShowingSafariView) {
            SafariView(url: URL(string: framework.urlString) ?? URL(string: "www.apple.com")!)
        }
    }
}

#Preview {
    FrameworkDetailViewIOS16(framework: MockData.sampleFramework)
        .preferredColorScheme(.dark)
}
