//
//  ReminderItem.swift
//  RemindersApp
//
//  Created by Isaac Ballas on 12/21/18.
//  Copyright © 2018 Isaac Ballas. All rights reserved.
//

import Foundation

class ReminderItem: NSObject {
    var text = ""
    var checked = false
    
    func toggleChecked() {
        checked = !checked
    }
}
