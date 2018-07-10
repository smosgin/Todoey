//
//  ViewController.swift
//  Todoey
//
//  Created by Seth Mosgin on 7/8/18.
//  Copyright © 2018 Seth Mosgin. All rights reserved.
//

import UIKit

// Since we inherit uitableviewcontroller, we don't need to set ourselves as the delegates for it, or set up iboutlets for it
class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    var dataArray = [Data]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        let newItem2 = Item(title: "First item")
//        itemArray.append(newItem2)
//        let newItem3 = Item(title: "Second item")
//        itemArray.append(newItem3)
//        let newItem = Item()
//        newItem.title = "Third item"
//        itemArray.append(newItem)
//        itemArray.append(newItem)
//        itemArray.append(newItem)
//        itemArray.append(newItem)
//        itemArray.append(newItem)
//        itemArray.append(newItem)
//        itemArray.append(newItem)
//        itemArray.append(newItem)
//        itemArray.append(newItem)
//        itemArray.append(newItem)
//        itemArray.append(newItem)
//        itemArray.append(newItem)
        
        if let items = defaults.array(forKey: "ToDoListArray") as? [Data] {
            for i in items {
                itemArray.append(dataToItem(data: i))
            }
            dataArray = items
            print(dataArray)
        } else {
            print("failllllled to load old stuff")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Transforming between Item objects and Data objects
    
    func itemToData(item: Item) -> Data {
        return NSKeyedArchiver.archivedData(withRootObject: item)
    }
    
    func dataToItem(data: Data) -> Item {
        return NSKeyedUnarchiver.unarchiveObject(with: data) as! Item
    }
    
    func saveData() {
        for i in itemArray {
            dataArray.append(itemToData(item: i))
        }
        defaults.set(dataArray, forKey: "ToDoListArray") // Add the dataArray to the user defaults to store locally
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
//        print(itemArray[indexPath.row])
//        let cell = tableView.cellForRow(at: indexPath) // Grab a reference to the cell that we selected
        let row = indexPath.row
        let item = itemArray[row]
        
        // Invert the value of the done property, since it was selected
        item.done = !item.done
        
        // Now that we've changed the done property, reload the data so it can be reflected in the table
        tableView.reloadData()
        
        dataArray[row] = itemToData(item: item)
        self.defaults.set(self.dataArray, forKey: "ToDoListArray")
        
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
            let newItem = Item(title: textField.text!, done: false)
            
            //transform item into
            
            self.itemArray.append(newItem)
            self.dataArray.append(self.itemToData(item: newItem))
            self.tableView.reloadData() // Need to reload data once data is changed
            
            self.defaults.set(self.dataArray, forKey: "ToDoListArray") // Add the dataArray to the user defaults to store locally
        }
        alert.addTextField { (alertTextField) in
            // What will happen once the text field is added to the alert
            alertTextField.placeholder = "Create new item"
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

