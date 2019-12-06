//
//  TodoListViewController.swift
//  Todoey
//
//  Created by developer on 27/11/19.
//  Copyright © 2019 Cognizant. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class TodoListViewController: UITableViewController {

    //var itemArray = [TodoItem]() // Core Data
    var itemArray: Results<RealmItem>? // Realm DB
    let realm = try! Realm()
    //var selectedCategory: TodoCategory? { this is used for Coredata
    var selectedCategory: RealmCategory? { //RealmDB
        didSet{
            //loadItems() // Core data fetching
            loadRealmItems() // RealmDB data fetching
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in : .userDomainMask).first?.appendingPathComponent("Item.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in : .userDomainMask))
        
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemArray?.count ?? 1
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = itemArray?[indexPath.row]{
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        }
        else{
            cell.textLabel?.text = "No Items Added"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
//To delete items using coredata
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        
// update item with core data
/*itemArray[indexPath.row].done = !itemArray[indexPath.row].done // using CoreData
        saveItems()*/
// update item with Realm DB
        if let item = itemArray?[indexPath.row]{
            do{
                try realm.write {
                    item.done = !item.done
//                    realm.delete(item) //delete an item from Realm DB
                }
            }
                catch{
                    print("error \(error)")
                }
            
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Item

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //Save todo item using core data
           /* let newItem = TodoItem(context: self.context)
            newItem.title = textfield.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            self.saveItems()*/
            
            ////Save todo item using realm database
            if let currentCategroy = self.selectedCategory {
                
                do{
                    try self.realm.write {
                        let newItem = RealmItem()
                        newItem.title = textfield.text!
                        newItem.dateCreated = Date()
                        currentCategroy.items.append(newItem)
                    }
                }
                catch{
                    print("error \(error)")
                }

                self.tableView.reloadData()
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textfield = alertTextField
        }
        alert.addAction(action)
        present(alert,animated: true, completion: nil)
    }
    
    func saveItems()
    {
        
        do {
            try context.save()
        }
        catch{
            print("Error \(error)")
        }
        tableView.reloadData()
    }
    func loadRealmItems()
    {
        itemArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
         tableView.reloadData()
    }
    
   /* func loadItems(with request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest(),predicate:NSPredicate? = nil)
    {
        let categoryPredicate = NSPredicate(format: "parentCategory.categoryName MATCHES %@", selectedCategory!.categoryName!)
        
        if let additonalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additonalPredicate])
        }
        else{
            request.predicate = categoryPredicate
        }

        
        do{
          itemArray =  try context.fetch(request)
        }
        catch{
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }*/
    
}

//MARK: - SEARCH BAR METHODS
extension TodoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
       /* let request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request,predicate:predicate)*/
        
        itemArray = itemArray?.filter("title CONTAINS[cd] %@",searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
           // loadItems() // for using Core data
            loadRealmItems() // used for Realm DB
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
                
            }
        }
    }
}
