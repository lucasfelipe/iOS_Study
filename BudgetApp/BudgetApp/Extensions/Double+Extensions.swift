//
//  Double+Extensions.swift
//  BudgetApp
//
//  Created by Lucas  Felipe on 11/09/2023.
//

import Foundation

extension Double {
    
    func formatAsCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: self)) ?? "0.00"
    }
}
