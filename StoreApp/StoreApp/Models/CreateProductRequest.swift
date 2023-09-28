//
//  CreateProductRequest.swift
//  StoreApp
//
//  Created by Lucas  Felipe on 28/09/2023.
//

import Foundation

struct CreateProductRequest: Encodable {
    
    let title: String
    let price: Double
    let description: String
    let categoryId: Int
    let images: [URL]
    
    
    init(product: Product) {
        title = product.title
        price = product.price
        description = product.description
        categoryId = product.category.id
        images = product.images ?? []
    }
}
