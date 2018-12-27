//
//  ReminderViewController.swift
//  RemindersApp
//
//  Created by Isaac Ballas on 12/21/18.
//  Copyright © 2018 Isaac Ballas. All rights reserved.
//

import UIKit

class ReminderViewController: UITableViewController, ItemDetailViewControllerDelegate {
    var items = [ReminderItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = editButtonItem
        
        loadReminderItem()
       }
    // MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = items[indexPath.row]
            }
        }
    }
    
    // MARK:- Private Methods
    func configureCheckmark(for cell: UITableViewCell, with item: ReminderItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        
        if item.checked {
            label.text = "√"
        } else {
            label.text = " "
        }
    }
    
    func configureText(for cell: UITableViewCell, with item: ReminderItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    // MARK:- Data Persistance
    // Get the path to document directory
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    // Use that path to get the data file path where reminder items will be stored
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("RemindersApp.plist")
    }

    func saveReminderItem() {
        // Create an instance of PropoertyListEncoder, Add reminder items in it in binary data.
        let encoder = PropertyListEncoder()
        // Block of code to catch errors begins here
        do {
            // The encoder is used to try to encode the items array, and it throws a swift error if encoding fails. the Try keyword lets us know it can fail and if it does it will throw an error. if it fails go to catch.
            let data = try encoder.encode(items)
            // If the data constant was created, write the data to a file using dataFilePath. write method throws an error so use the Try statment.
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
            // catch statement indicates the blcok of code to be executes if error was thrown.
        } catch {
            print("Error encoding items array \(error.localizedDescription)")
        }
    }
    
    func loadReminderItem() {
        // Put the results of dateFilePath here.
        let path = dataFilePath()
        // try to load the contents of the plist into a new Data object. try? command attempts to create the Data object but returns nil if it fails.
        if let data = try? Data(contentsOf: path) {
            // load ReminderItem using a decoder.
            let decoder = PropertyListDecoder()
            do {
                // load saved data back into items using decode method.
                items = try decoder.decode([ReminderItem].self, from: data)
            } catch {
                print("Error decoding item array: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderItem", for: indexPath)
        let item = items[indexPath.row]
      //  configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        configureText(for: cell, with: item)
        return cell
    }

    // MARK: Table View Delegates
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {return}
        let item = items[indexPath.row]
        item.toggleChecked()
        configureCheckmark(for: cell, with: item)
        tableView.deselectRow(at: indexPath, animated: true)
        saveReminderItem()
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        items.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        saveReminderItem()
    }

    // MARK: - ItemDetailViewController Delegates
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }

    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ReminderItem) {
        let newRowIndex = items.count
        items.append(item)
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated: true)
        saveReminderItem()
    }

    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditting item: ReminderItem) {
        // Get the row number, the row number is the same as the index of the ReminderItem in the array.
        if let index = items.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
              configureText(for: cell, with: item)
         }
        }
        navigationController?.popViewController(animated: true)
        saveReminderItem()
    }


}
