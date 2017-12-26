//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Ritu Jain on 12/20/17.
//  Copyright © 2017 Ritu Jain. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray: [Item] = []
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }
    
    // Mark - Tableview datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title;
        cell.accessoryType = (item.done == true) ? .checkmark : .none
        return cell
    }
    
    // Mark - tableview delegate method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        self.saveItems()
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // Mark add new items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todo item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let newTitle = Item()
            newTitle.title = textField.text!
            self.itemArray.append(newTitle)
            self.saveItems()
            self.tableView.reloadData()
        }
        alert.addTextField{ (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array, \(error)")
            }
        }
    }
    
}

