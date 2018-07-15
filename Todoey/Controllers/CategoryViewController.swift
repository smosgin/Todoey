//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Seth Mosgin on 7/12/18.
//  Copyright © 2018 Seth Mosgin. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    // From the Realm docs:
    /* Like any disk I/O operation, creating a Realm instance could sometimes fail if resources are constrained. In practice, this can only happen the first time a Realm instance is created on a given thread. Subsequent accesses to a Realm from the same thread will reuse a cached instance
    */
    // Already tried accessing Realm the first time in AppDelegate
    let realm = try! Realm()
    
    var categories : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
//        realm = try! Realm()
        loadCategories()
        tableView.separatorStyle = .none
    }

    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath) // Take the cell from the SwipeTableViewController superclass and modify it
        
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name
            
            guard let categoryColor = UIColor(hexString: category.backgroundColor) else {fatalError()}
            cell.backgroundColor = categoryColor
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1 // Return categories.count if not nil. If nil, return 1. Nil coalescing operator
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
            destinationVC.categoryColor = categories?[indexPath.row].backgroundColor
        }
    }
    
    //MARK: - Data Manipulation Methods
    func save(category: Category) {
//        let realm = try! Realm()
        do{
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving categories \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories() {
//        let realm = try! Realm()
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    //MARK: - Delete Data from Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
        }
    }
    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add a new category", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let category = Category()
            category.name = alert.textFields![0].text!
            category.backgroundColor = UIColor.randomFlat.hexValue()
            
            self.save(category: category)
        }
        alert.addAction(action)
        alert.addTextField { (textField) in
            textField.placeholder = "Add a new category"
        }
        present(alert, animated: true, completion: nil)
    }
    
}
