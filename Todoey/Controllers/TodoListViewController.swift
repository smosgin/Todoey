//
//  ViewController.swift
//  Todoey
//
//  Created by Seth Mosgin on 7/8/18.
//  Copyright © 2018 Seth Mosgin. All rights reserved.
//

import UIKit
import RealmSwift

// Since we inherit uitableviewcontroller, we don't need to set ourselves as the delegates for it, or set up iboutlets for it
class TodoListViewController: SwipeTableViewController {
    
    var todoItems : Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        // Everything here happens once a value is set for selectedCategory
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Tableview Datasource Methods
    
    // Populate table with data
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            //        if item.done == true {
            //            cell.accessoryType = .checkmark
            //        } else {
            //            cell.accessoryType = .none
            //        }
            
            // Ternary operator
            // value = condition ? valueIfTrue : valueIfFalse
            cell.accessoryType = item.done ? .checkmark : .none // This does the same thing as the previous (commented out) if statement
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    // How many rows in a section?
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    //MARK: - Tableview Delegate Methods
    
    // Row was selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        
        if let item = todoItems?[row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("error saving done status \(error)")
            }
        }
        
        // Now that we've changed the done property, reload the data so it can be reflected in the table
        tableView.reloadData()
        
        // Make the selection not persist or stay highlighted
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen once the user click the Add Item button on the UIAlert
            print("Success!")
            
            let textField = alert.textFields![0]
            print("Textfield: \(textField.text!)")
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving item to realm \(error)")
                }
            }
            
            self.tableView.reloadData()
            
        }
        alert.addTextField { (alertTextField) in
            // What will happen once the text field is added to the alert
            alertTextField.placeholder = "Create new item"
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manipulation Methods
    
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = self.todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            } catch {
                print("Error deleting item, \(error)")
            }
        }
    }
}

//MARK: - Search bar methods
extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }

    // Text changed in the search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 { // If text has changed down to 0 chars (user clicked the X button)
            loadItems() // Get everything out of the table

            DispatchQueue.main.async {
                searchBar.resignFirstResponder() // We grabbed a reference to the main thread to ensure that we resignFirstResponder in the foreground
            }

        }
    }
}

