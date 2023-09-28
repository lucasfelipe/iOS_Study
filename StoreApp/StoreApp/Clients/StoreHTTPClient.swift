//
//  StoreHTTPClient.swift
//  StoreApp
//
//  Created by Lucas  Felipe on 25/09/2023.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidServerResponse
    case decodingError
}

class StoreHTTPClient {
    
    func getProductsByCategory(categoryId: Int) async throws -> [Product] {
        
        let (data, response) = try await URLSession.shared.data(from: URL.productsByCategory(categoryId))
        
        guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200
        else {
            throw NetworkError.invalidServerResponse
        }
        
        guard let products = try? JSONDecoder().decode([Product].self, from: data) else {
            throw NetworkError.decodingError
        }
        
        return products
    }
    
    func getAllCategories() async throws -> [Category] {
        
        let (data, response) = try await URLSession.shared.data(from: URL.allCategories)
        
        guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200
        else {
            throw NetworkError.invalidServerResponse
        }
        
        guard let categories = try? JSONDecoder().decode([Category].self, from: data) else {
            throw NetworkError.decodingError
        }
        
        return categories
    }
    
    func createProduct(productRequest: CreateProductRequest) async throws -> Product {
        
        var request = URLRequest(url: URL.createProduct)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(productRequest)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 201
        else {
            throw NetworkError.invalidServerResponse
        }
        
        guard let product = try? JSONDecoder().decode(Product.self, from: data) else {
            throw NetworkError.decodingError
        }
        
        return product
    }
    
}
