//
//  Locale+Extensions.swift
//  StoreApp
//
//  Created by Lucas  Felipe on 25/09/2023.
//

import Foundation

extension Locale {
    static var currencyCode: String {
        Locale.current.currency?.identifier ?? "EUR"
    }
}
