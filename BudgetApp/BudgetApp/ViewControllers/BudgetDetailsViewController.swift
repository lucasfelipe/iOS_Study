//
//  BudgetDetailsViewController.swift
//  BudgetApp
//
//  Created by Lucas  Felipe on 11/09/2023.
//

import Foundation
import UIKit
import CoreData

class BudgetDetailViewController: UIViewController {
    
    private var persistentContainer: NSPersistentContainer
    private var fetchedResultsController: NSFetchedResultsController<Transaction>
    private var budgetCategory: BudgetCategory
    
    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Transaction name"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField.leftViewMode = .always
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    lazy var amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Transaction amount"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField.leftViewMode = .always
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TransactionTableViewCell")
        return tableView
    }()
    
    lazy var saveTransactionButton: UIButton = {
        var config = UIButton.Configuration.bordered()
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save Transaction", for: .normal)
        return button
    }()
    
    lazy var errorMessageLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.red
        label.text = ""
        label.numberOfLines = 0
        return label
    }()
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.text = budgetCategory.amount.formatAsCurrency()
        return label
    }()
    
    lazy var transactionsTotalLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private func resetForm() {
        nameTextField.text = ""
        amountTextField.text = ""
        errorMessageLabel.text = ""
    }
    
    private func updateTransactionTotal() {
        transactionsTotalLabel.text = budgetCategory.transactionsTotal.formatAsCurrency()
    }
    
    init(budgetCategory: BudgetCategory, persistentContainer: NSPersistentContainer) {
        self.budgetCategory = budgetCategory
        self.persistentContainer = persistentContainer
        
        // create request based on selected budget category
        let request = Transaction.fetchRequest()
        request.predicate = NSPredicate(format: "category = %@", budgetCategory)
        request.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        super.init(nibName: nil, bundle: nil)
        
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch  {
            errorMessageLabel.text = "Unable to fetch transactions"
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateTransactionTotal()
    }
    
    private var isFormValid: Bool {
        guard let name = nameTextField.text, let amount = amountTextField.text else {
            return false
        }
        
        return !name.isEmpty && !amount.isEmpty && amount.isNumeric && amount.isGreaterThan(0)
    }
    
    private func deleteTransaction(_ transaction: Transaction) {
        persistentContainer.viewContext.delete(transaction)
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            errorMessageLabel.text = "Unable to delete transaction"
        }
    }
    
    private func saveTransaction() {
        guard let name = nameTextField.text, let amount = amountTextField.text else {
            return
        }
        
        let transaction = Transaction(context: persistentContainer.viewContext)
        transaction.name = name
        transaction.amount = Double(amount) ?? 0.0
        transaction.category = budgetCategory
        transaction.dateCreated = Date()
        
        //budgetCategory.addToTransactions(transaction)
        
        do {
            try persistentContainer.viewContext.save()
            // reset form
            resetForm()
            tableView.reloadData()
        } catch {
            errorMessageLabel.text = "Unable to save transaction."
        }
    }
    
    @objc func saveTransactionButtonPressed(_ sender: UIButton) {
        
        if isFormValid {
            saveTransaction()
        } else {
            errorMessageLabel.text = "Make sure name and amount is valid."
        }
    }
    
    private func setupUI() {
        
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        title = budgetCategory.name
        
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        
        stackView.addArrangedSubview(amountLabel)
        stackView.setCustomSpacing(50, after: amountLabel)
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(amountTextField)
        stackView.addArrangedSubview(saveTransactionButton)
        stackView.addArrangedSubview(errorMessageLabel)
        stackView.addArrangedSubview(transactionsTotalLabel)
        stackView.addArrangedSubview(tableView)
        
        view.addSubview(stackView)
        
        // add constraints
        nameTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        amountTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        saveTransactionButton.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        saveTransactionButton.addTarget(self, action: #selector(saveTransactionButtonPressed), for: .touchUpInside)
        transactionsTotalLabel.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        
        stackView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: 600).isActive = true
    }
    
}

extension BudgetDetailViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateTransactionTotal()
        tableView.reloadData()
    }
    
}

extension BudgetDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let transaction = fetchedResultsController.object(at: indexPath)
            deleteTransaction(transaction)
        }
        
    }
    
}

extension BudgetDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (fetchedResultsController.fetchedObjects ?? []).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell", for: indexPath)
        
        let transaction = fetchedResultsController.object(at: indexPath)
        // cell configuration
        var content = cell.defaultContentConfiguration()
        content.text = transaction.name
        content.secondaryText = transaction.amount.formatAsCurrency()
        
        cell.contentConfiguration = content
        
        return cell
    }
}
