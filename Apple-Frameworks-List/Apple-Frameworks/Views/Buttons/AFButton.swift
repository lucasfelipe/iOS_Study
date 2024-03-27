//
//  AFButton.swift
//  Apple-Frameworks
//
//  Created by Lucas  Felipe on 27/03/2024.
//

import SwiftUI

struct AFButton: View {
    var title: String
    
    var body: some View {
        Text(title)
            .font(.title2)
            .fontWeight(.semibold)
            .frame(width: 280, height: 50)
            .background(Color.red)
            .foregroundStyle(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    AFButton(title: "Test Title")
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
}
