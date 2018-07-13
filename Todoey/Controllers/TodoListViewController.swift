//
//  ViewController.swift
//  Todoey
//
//  Created by Seth Mosgin on 7/8/18.
//  Copyright © 2018 Seth Mosgin. All rights reserved.
//

import UIKit
import CoreData

// Since we inherit uitableviewcontroller, we don't need to set ourselves as the delegates for it, or set up iboutlets for it
class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    var selectedCategory : Category? {
        // Everything here happens once a value is set for selectedCategory
        didSet {
            loadItems()
        }
    }
    
    let documentsFolderPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first // Path to Documents in User dir
    // Grab a reference to the singleton app instance (our app when it's running) and its delegate, to then access AppDelegate's conainer/database's context var
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Tableview Datasource Methods
    
    // Populate table with data
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        // Ternary operator
        // value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none // This does the same thing as the previous (commented out) if statement
        
        return cell
    }
    
    // How many rows in a section?
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK: - Tableview Delegate Methods
    
    // Row was selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let item = itemArray[row]
        
        // Invert the value of the done property, since it was selected
        item.done = !item.done
        
        // Now that we've changed the done property, save and reload the data so it can be reflected in the table
        saveItems()
        
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
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            self.saveItems()
            
//            self.dataArray.append(self.itemToData(item: newItem))
            
            
        }
        alert.addTextField { (alertTextField) in
            // What will happen once the text field is added to the alert
            alertTextField.placeholder = "Create new item"
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manipulation Methods
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        self.tableView.reloadData() // Need to reload data once data is changed
    }
    
    // The = Item.fetchrequest() here is a default value, allowing us to call this method without providing a request
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {

        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let predicate = request.predicate {
            let compound = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, categoryPredicate])
            request.predicate = compound
        } else {
            request.predicate = categoryPredicate
        }
    
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
}

//MARK: - Search bar methods
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!) // [cd] here means that our search is case and diacretic insensitive
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request)
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

