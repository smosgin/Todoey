//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Seth Mosgin on 7/12/18.
//  Copyright © 2018 Seth Mosgin. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadCategories()
        
    }

    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    func saveCategories() {
        do{
            try context.save()
        } catch {
            print("Error saving categories \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories(with request : NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching categories \(error)")
        }
        tableView.reloadData()
    }
    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add a new category", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let category = Category(context: self.context)
            category.name = alert.textFields![0].text!
            
            self.categoryArray.append(category)
            self.saveCategories()
        }
        alert.addAction(action)
        alert.addTextField { (textField) in
            textField.placeholder = "Add a new category"
        }
        present(alert, animated: true, completion: nil)
    }
    
}
