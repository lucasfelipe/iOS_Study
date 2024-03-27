//
//  WeatherButton.swift
//  SwiftUI-Weather
//
//  Created by Lucas  Felipe on 20/03/2024.
//

import SwiftUI

struct WeatherButton: View {
    
    var title: String
    var textColor: Color
    var backgroundColor: Color
    
    var body: some View {
        Text(title)
            .frame(width: 280, height: 50)
            .background(backgroundColor)
            .foregroundColor(textColor)
            .font(.system(size: 20, weight: .bold, design: .default))
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

#Preview {
    WeatherButton(title: "Change Button", textColor: .white, backgroundColor: .blue)
}
