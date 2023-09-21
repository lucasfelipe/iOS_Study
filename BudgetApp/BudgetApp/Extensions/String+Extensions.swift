//
//  String+Extensions.swift
//  BudgetApp
//
//  Created by Lucas  Felipe on 10/09/2023.
//

import Foundation

extension String {
    
    var isNumeric: Bool {
        Double(self) != nil
    }
    
    func isGreaterThan(_ value: Double) -> Bool {
        guard self.isNumeric else {
            return false
        }
        
        return Double(self)! > value
    }
    
}
