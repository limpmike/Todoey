//
//  ViewController.swift
//  Todoey
//
//  Created by Miguel Ángel Hernández Muñoz on 4/28/18.
//  Copyright © 2018 Miguel Ángel Hernández Muñoz. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadItems()
    }
    
    //MARK:- Create table view data source methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
    
        return cell
    }
    
    //MARK:- Table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        itemArray[indexPath.row].done =  !itemArray[indexPath.row].done
        
        tableView.cellForRow(at: indexPath)?.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        
        self.saveItems()
        
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
                    let newItem = Item()
                    newItem.title = newTodo
                    self.itemArray.append(newItem)
                    self.saveItems()
                    self.tableView.reloadData()
                }
                
            }
            
        }
        
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    
    //MARK:- Model manipulation methods
    
    func saveItems() {
        let enconder = PropertyListEncoder()
        
        do{
            let data = try enconder.encode(self.itemArray)
            try data.write(to : self.dataFilePath!)
        }catch{
            print("Error encoding array \(error)")
        }
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([Item].self, from: data)
            }catch{
                print("Error decoding array \(error)")
            }
        }
    }
}

