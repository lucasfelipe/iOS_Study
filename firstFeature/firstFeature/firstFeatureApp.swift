//
//  firstFeatureApp.swift
//  firstFeature
//
//  Created by Lucas  Felipe on 15/04/2024.
//

import SwiftUI
import ComposableArchitecture

@main
struct firstFeatureApp: App {
    
    static let store = Store(initialState: CounterFeature.State()) {
        CounterFeature()
            ._printChanges()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(store: firstFeatureApp.store)
        }
    }
}
