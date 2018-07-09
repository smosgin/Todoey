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

    let itemArray = ["Find Mike", "Buy Eggos", "destroy demogorgon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row])
        let cell = tableView.cellForRow(at: indexPath) // Grab a reference to the cell that we selected
        
        if cell?.accessoryType == .checkmark {
            cell?.accessoryType = .none
        } else {
            cell?.accessoryType = .checkmark
        }
        
        // Make the selection not persist or stay highlighted
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

