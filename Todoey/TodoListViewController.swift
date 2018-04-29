//
//  ViewController.swift
//  Todoey
//
//  Created by Miguel Ángel Hernández Muñoz on 4/28/18.
//  Copyright © 2018 Miguel Ángel Hernández Muñoz. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = ["Find Mike","Buy Eggos","Destroy Demogorgon"]
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let items = defaults.array(forKey: "TodoListArray") as? [String]{
            itemArray = items
        }
    }
    
    //MARK:- Create table view data source methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    //MARK:- Table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
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
                    self.itemArray.append(newTodo)
                    self.defaults.set(self.itemArray, forKey: "TodoListArray")
                    self.tableView.reloadData()
                }
                
            }
            
        }
        
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
}

