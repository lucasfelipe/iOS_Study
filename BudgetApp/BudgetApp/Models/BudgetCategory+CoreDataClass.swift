//
//  BudgetCategory+CoreDataClass.swift
//  BudgetApp
//
//  Created by Lucas  Felipe on 18/09/2023.
//

import Foundation
import CoreData

@objc(BudgetCategory)
public class BudgetCategory: NSManagedObject {
    
    var transactionsTotal: Double {
        let transactions: [Transaction] = transactions?.toArray() ?? []
        return transactions.reduce(0) { next, transaction in
            next + transaction.amount
        }
    }
    
    var remainingAmount: Double {
        amount - transactionsTotal
    }
    
}
