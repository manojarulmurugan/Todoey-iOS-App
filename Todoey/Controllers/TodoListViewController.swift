//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//
//MARK: - ********* REALM DB IMPLEMENTATION ************
/*import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    var todoItems: Results<ItemR>?
    let realm = try! Realm()
    
    var selectedCategory : CategoryR? {
        didSet{
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
//MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for:indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else{
            cell.textLabel?.text = "No Items added"
        }
        
        return cell
    }
    
//MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                    /*Deleting Data in Realm DB
                    realm.delete(item)*/
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        self.tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var newItem = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default){  (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem0 = ItemR()
                        newItem0.title = newItem.text!
                        newItem0.dateCreated = Date()
                        currentCategory.items.append(newItem0)
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            newItem = alertTextField
        }
        
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
        
    }
    
//MARK: - Data Model Manupulation Methods
    
    func loadItems(){
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
}
//MARK: - Search bar Methods

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@",searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}*/
//MARK: - ********* CORE DATA IMPLEMENTATION ************
import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    //let cat : CategoryViewController
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        /*ADDING elements one by one:-
         let newItem1 = Item()
        newItem1.title = "Find Mike"
        itemArray.append(newItem1)*/
        
        /* CODE FOR 'userDefaults':-
         if let items = defaults.array(forKey: "ToDoList Array") as? [Item]{
            itemArray = items
        }*/
        
        //searchBar.delegate = self
        
        /*let request: NSFetchRequest<Item> = Item.fetchRequest()
        loadItems(with: request)*/
    }
    
//MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count;
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for:indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
//MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        /*CODE FOR DELETING AN ITEM IN CoreData:
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)*/
        
        //UPDATING VALUE OF 'DONE' USING NSManagedObject: (ALSO CAN BE USED FOR CoreData)
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var newItem = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default){  (action) in
            //What will happen when the user clicks the Add Item button on our UIAlert:-
            
            let newItem0 = Item(context: self.context)
            newItem0.title = newItem.text!
            newItem0.done = false
            newItem0.parentCategory = self.selectedCategory
            self.itemArray.append(newItem0)
            
            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            newItem = alertTextField
        }
        
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
        
    }
    
//MARK: - Data Model Manupulation Methods
    
    func saveItems(){
        //let encoder = PropertyListEncoder()
        do{
            /*let data = try encoder.encode(itemArray)
            try data.write(to:dataFilePath!)*/
            try context.save()
        } catch{
            /*print("Error encodeing item array, \(error)")*/
            print("Error saving context, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
/* CODE FOR LOADIND DATA FOR NSManagedObject:-
     func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error encodeing item array, \(error)")
            }
        }
    }*/
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        /*NO NEED AS REQUEST PARAMETER IS THERE:
        let request: NSFetchRequest<Item> = Item.fetchRequest()*/
        
        let categoryPredicate = NSPredicate(format:"parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        /*let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,predicate])
        request.predicate = compoundPredicate*/
        
        do{
            itemArray = try context.fetch(request)
        }catch{
            print("Error fetching data from context, \(error)")
        }
 
        tableView.reloadData()
    }
}
//MARK: - Search bar Methods

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@",searchBar.text!)
        request.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        
        /*INSTEAD OF THIS CODE:
         do{
            itemArray = try context.fetch(request)
        }catch{
            print("Error fetching data from context, \(error)")
        }*/
        
        //USE THIS:
        loadItems(with: request, predicate: predicate)
        
        /*NO need coz this comes in loadItems() itself:
        tableView.reloadData()*/
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

