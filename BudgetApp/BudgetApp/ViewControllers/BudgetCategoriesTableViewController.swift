//
//  ViewController.swift
//  BudgetApp
//
//  Created by Mohammad Azam on 11/8/22.
//

import UIKit
import CoreData

class BudgetCategoriesTableViewController: UITableViewController {
    
    private var persistentContainer: NSPersistentContainer
    private var fetchResultsController: NSFetchedResultsController<BudgetCategory>!
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
        super.init(nibName: nil, bundle: nil)
        
        let request = BudgetCategory.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        fetchResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultsController.delegate = self
        
        do {
            try fetchResultsController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // register cell
        tableView.register(BudgetCategoryTableViewCell.self, forCellReuseIdentifier: "BudgetCategoryTableViewCell")
    }
    
    @objc func showAddBudgetCategory(_ sender: UIBarButtonItem) {
        let navigationController = UINavigationController(rootViewController: AddBudgetCategoryViewController(persistentContainer: persistentContainer))
        present(navigationController, animated: true)
    }
    
    private func setupUI() {
        let addBudgetCategoryButton = UIBarButtonItem(title: "Add Category", style: .done, target: self, action: #selector(showAddBudgetCategory))
        self.navigationItem.rightBarButtonItem = addBudgetCategoryButton
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Budget"
    }
    
    private func deleteBudgetCategory(_ budgetCategory: BudgetCategory) {
        persistentContainer.viewContext.delete(budgetCategory)
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            showAlert(title: "Error", message: "Unable to delete budget category.")
        }
    }
    
    // UITableViewDelegate functions
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let budgetCategory = fetchResultsController.object(at: indexPath)
            deleteBudgetCategory(budgetCategory)
        }
        
    }
    
    // UITableViewDataSource delegate functions
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (fetchResultsController.fetchedObjects ?? []).count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BudgetCategoryTableViewCell", for: indexPath) as? BudgetCategoryTableViewCell else {
            return BudgetCategoryTableViewCell(style: .default, reuseIdentifier: "BudgetCategoryTableViewCell")
        }
        
        cell.accessoryType = .disclosureIndicator
        
        let budgetCategory = fetchResultsController.object(at: indexPath)
        cell.configure(budgetCategory)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let budgetCategory = fetchResultsController.object(at: indexPath)
        
        self.navigationController?.pushViewController(BudgetDetailViewController(budgetCategory: budgetCategory, persistentContainer: persistentContainer), animated: true)
    }

}

extension BudgetCategoriesTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
    
}
