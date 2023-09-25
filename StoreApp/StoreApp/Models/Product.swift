//
//  Product.swift
//  StoreApp
//
//  Created by Lucas  Felipe on 25/09/2023.
//

import Foundation

struct Product: Codable {
    var id: Int?
    let title: String
    let price: Double
    let description: String
    let images: [URL]?
    let category: Category
}
