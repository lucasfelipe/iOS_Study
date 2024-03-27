//
//  Apple_FrameworksApp.swift
//  Apple-Frameworks
//
//  Created by Lucas  Felipe on 27/03/2024.
//

import SwiftUI

@main
struct Apple_FrameworksApp: App {
    var body: some Scene {
        WindowGroup {
            FrameworkGridView()
                .preferredColorScheme(.dark)
        }
    }
}
