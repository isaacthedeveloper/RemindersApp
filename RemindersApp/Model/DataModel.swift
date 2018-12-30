//
//  DataModel.swift
//  RemindersApp
//
//  Created by Isaac Ballas on 12/28/18.
//  Copyright © 2018 Isaac Ballas. All rights reserved.
//

import Foundation

class DataModel {
    var lists = [Checklist]()
    
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    // Use that path to get the data file path where reminder items will be stored
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklist.plist")
    }
    
    func saveChecklists() {
        // Create an instance of PropoertyListEncoder, Add reminder items in it in binary data.
        let encoder = PropertyListEncoder()
        // Block of code to catch errors begins here
        do {
            // The encoder is used to try to encode the items array, and it throws a swift error if encoding fails. the Try keyword lets us know it can fail and if it does it will throw an error. if it fails go to catch.
            let data = try encoder.encode(lists)
            // If the data constant was created, write the data to a file using dataFilePath. write method throws an error so use the Try statment.
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
            // catch statement indicates the blcok of code to be executes if error was thrown.
        } catch {
            print("Error encoding items array \(error.localizedDescription)")
        }
    }
    
    func loadChecklists() {
        // Put the results of dateFilePath here.
        let path = dataFilePath()
        // try to load the contents of the plist into a new Data object. try? command attempts to create the Data object but returns nil if it fails.
        if let data = try? Data(contentsOf: path) {
            // load ReminderItem using a decoder.
            let decoder = PropertyListDecoder()
            do {
                // load saved data back into items using decode method.
                lists = try decoder.decode([Checklist].self, from: data)
            } catch {
                print("Error decoding item array: \(error.localizedDescription)")
            }
        }
    }
    
    var indexOfSelectedChecklist: Int {
        get {
            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
        }
    }
    
    func registerDefaults() {
        // Create a new Dictionary that adds the value -1 for the key.
        let dictionary = ["ChecklistIndex": -1, "FirstTime": true ] as [String : Any]
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    func handleFirstTime() {
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        
        if firstTime {
            let checklist = Checklist(name: "List")
            lists.append(checklist)
            
            indexOfSelectedChecklist = 0
            userDefaults.set(false, forKey: "FirstTime")
            userDefaults.synchronize()
        }
    }
    
    init() {
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }
}
