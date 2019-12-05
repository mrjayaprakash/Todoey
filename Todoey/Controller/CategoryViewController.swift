//
//  CategoryViewController.swift
//  Todoey
//
//  Created by developer on 05/12/19.
//  Copyright © 2019 Cognizant. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

var categoryArray = [TodoCategory]()
let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
        var textfield = UITextField()
               let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
               let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
                   let newItem = TodoCategory(context: self.context)
                   newItem.categoryName = textfield.text!
                   self.categoryArray.append(newItem)
                   self.saveCategories()
               }
               alert.addTextField { (alertTextField) in
                   alertTextField.placeholder = "Create new item"
                   textfield = alertTextField
               }
               alert.addAction(action)
               present(alert,animated: true, completion: nil)
    }
    
    //MARK: - Tableview datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           // #warning Incomplete implementation, return the number of rows
           return categoryArray.count
       }

      
       override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
           
        cell.textLabel?.text = categoryArray[indexPath.row].categoryName
           return cell
       }
    
   
    
    //MARK: - Tableview delegate methods
    
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
            
            performSegue(withIdentifier: "GoTodoItem", sender: self)
            
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexpath = tableView.indexPathForSelectedRow {
        destinationVC.selectedCategory = categoryArray[indexpath.row]
        }
    }
    //MARK: - Data manipulate methods
    
    func saveCategories()
       {
           do {
                try context.save()
            }
            catch{
                print("Error \(error)")
            }
            tableView.reloadData()
       }
    
    func loadCategories()
      {
        let request: NSFetchRequest<TodoCategory> = TodoCategory.fetchRequest()
        
          do{
            categoryArray =  try context.fetch(request)
          }
          catch{
              print("Error fetching data from context \(error)")
          }
          tableView.reloadData()
      }
}
