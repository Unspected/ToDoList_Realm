//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class ToDoListViewController: UITableViewController {

    var todoItems: Results<Item>?
    
//    var index = Int()
    private let localRealm = try! Realm()
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    let cellID = "toDoItemCell"
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }
    
    func loadItems() {
        guard let saveCategory = self.selectedCategory else { return }
        todoItems = saveCategory.items.sorted(byKeyPath: "title")
        tableView.reloadData()
    }
    
    
    
    // MARK: - TableView methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        }
        return cell
    }
    
    // MARK: - TableViewDelegate method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let saveItem = todoItems?[indexPath.row] else { return}
        
        RealmManager.shared.updateStatusItem(item: saveItem)
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
   //  MARK: - Delete Item Method
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
            self?.deleteItem(indexPath: indexPath)
            completionHandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
 
    
    // MARK: - Add new item

    @IBAction func AddNewItem(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey item", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Add item", style: .default) { [self] action in
            
            guard let saveText = textField.text else { return }
            
            if let currentCategory = self.selectedCategory {
                try! localRealm.write({
                    let newItem = Item()
                    newItem.title = saveText
                    currentCategory.items.append(newItem)
                })
                self.tableView.reloadData()
            }
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(alertAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    // MARK: - Delete Item Method
    private func deleteItem(indexPath: IndexPath) {
        guard let item = todoItems?[indexPath.row] else { return }
        let areYouSureAlert = UIAlertController(title: "Are you sure you want to delete this Item?", message: "", preferredStyle: .alert)
        let yesDeleteAction = UIAlertAction(title: "Yes", style: .destructive) { [self] (action) in
            RealmManager.shared.deleteItem(data: item)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
        
        let noDeleteAction = UIAlertAction(title: "No", style: .default) { (action) in
            //do nothing
        }
        areYouSureAlert.addAction(noDeleteAction)
        areYouSureAlert.addAction(yesDeleteAction)
        self.present(areYouSureAlert, animated: true, completion: nil)
    }
}

//MARK: - Extension Search Bar methods

extension ToDoListViewController: UISearchBarDelegate {
    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//        let request = NSFetchRequest<Item>(entityName: "Item")
//        guard let saveText = searchBar.text else { return }
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", saveText)
//        request.predicate = predicate
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request)
//    }
    
    // MARK: - refresh table if remove all characters in searchbar
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            loadItems()
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//
//        }
//    }
 
}
