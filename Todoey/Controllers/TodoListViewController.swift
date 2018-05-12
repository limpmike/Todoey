//
//  ViewController.swift
//  Todoey
//
//  Created by Miguel Ángel Hernández Muñoz on 4/28/18.
//  Copyright © 2018 Miguel Ángel Hernández Muñoz. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController{

    var todoItems : Results<Item>?
    let realm = try! Realm()
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    //MARK:- Create table view data source methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No Items Added"
        }
        return cell
    }
    
    //MARK:- Table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write {
                    item.done = !item.done
                    //realm.delete(item)
                }
                //tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.cellForRow(at: indexPath)?.accessoryType = item.done ? .checkmark : .none
            }catch{
                print("Error saving status, \(error)")
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK:- Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
        }
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the add item button on our UIAlert
            if let textFields = alert.textFields{
                let newTodo = textFields[0].text!
                if !newTodo.isEmpty{
                    if let currentCategory = self.selectedCategory{
                        do{
                            try self.realm.write {
                                let newItem = Item()
                                newItem.title = newTodo
                                currentCategory.items.append(newItem)
                                self.realm.add(newItem)
                            }
                        }catch{
                            print("Error saving context \(error)")
                        }
                        self.tableView.reloadData()
                    }
                }
                
            }
            
        }
        
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    
    //MARK:- Model manipulation methods
    
    func save(item : Item) {
        do{
            try realm.write {
                realm.add(item)
            }
        }catch{
            print("Error saving context \(error)")
        }
    }
    
    func loadItems(){
        todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated",ascending: false)
        tableView.reloadData()
    }
}

//MARK:- SearchBar methods
extension TodoListViewController : UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated",ascending: true)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

