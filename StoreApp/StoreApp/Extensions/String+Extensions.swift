//
//  String+Extensions.swift
//  StoreApp
//
//  Created by Lucas  Felipe on 28/09/2023.
//

import Foundation

extension String {
    
    var isNumeric: Bool {
        Double(self) != nil
    }
    
}
