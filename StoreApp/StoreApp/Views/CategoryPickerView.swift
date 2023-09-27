//
//  CategoryPickerView.swift
//  StoreApp
//
//  Created by Lucas  Felipe on 27/09/2023.
//

import SwiftUI

struct CategoryPickerView: View {
    
    let client = StoreHTTPClient()
    @State private var categories: [Category] = []
    @State private var selectedCategory: Category?
    
    let onSelected: (Category) -> Void
    
    var body: some View {
        Picker("Categories", selection: $selectedCategory) {
            ForEach(categories, id: \.id) { category in
                Text(category.name).tag(Optional(category))
            }
        }
        .onChange(of: selectedCategory, { _, category in
            if let category {
                onSelected(category)
            }
        })
        .pickerStyle(.wheel)
            .task {
                do {
                    categories = try await client.getAllCategories()
                    selectedCategory = categories.first
                } catch {
                    print(error)
                }
            }
    }
}

#Preview {
    CategoryPickerView(onSelected: { _ in } )
}
