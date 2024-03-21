//
//  WeatherDay.swift
//  SwiftUI-Weather
//
//  Created by Lucas  Felipe on 20/03/2024.
//

import Foundation

struct WeatherDay: Identifiable {
    let dayOfWeek: String
    let imageName: String
    let temperature: Int
    var id: String { dayOfWeek }
}
