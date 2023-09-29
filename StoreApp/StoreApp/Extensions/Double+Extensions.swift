//
//  Double+Extensions.swift
//  StoreApp
//
//  Created by Lucas  Felipe on 29/09/2023.
//

import Foundation

extension Double {
    
    func formatAsCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: self)) ?? "0.00"
    }
    
}
