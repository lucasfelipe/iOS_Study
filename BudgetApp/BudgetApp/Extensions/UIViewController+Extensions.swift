//
//  UIViewController+Extensions.swift
//  BudgetApp
//
//  Created by Lucas  Felipe on 21/09/2023.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
