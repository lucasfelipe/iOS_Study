//
//  ProductsTableViewController.swift
//  StoreApp
//
//  Created by Lucas  Felipe on 25/09/2023.
//

import Foundation
import UIKit
import SwiftUI

class ProductsTableViewController: UITableViewController {
    
    private var category: Category
    private var client = StoreHTTPClient()
    private var products: [Product] = []
    
    init(category: Category) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = category.name
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ProductTableViewCell")
        
        Task {
            await populateProducts()
        }
    }
    
    private func populateProducts() async {
        do {
            products = try await client.getProductsByCategory(categoryId: category.id)
            tableView.reloadData()
        } catch {
            print(error)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath)
        let product = products[indexPath.row]
        
        cell.contentConfiguration = UIHostingConfiguration(content: {
            ProductCellView(product: product)
        })
        
        return cell
    }
    
    
    
}
