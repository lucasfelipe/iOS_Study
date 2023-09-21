//
//  NSSet+Extensions.swift
//  BudgetApp
//
//  Created by Lucas  Felipe on 18/09/2023.
//

import Foundation

extension NSSet {
    
    func toArray<T>() -> [T] {
        return self.map { $0 as! T }
    }
    
}
