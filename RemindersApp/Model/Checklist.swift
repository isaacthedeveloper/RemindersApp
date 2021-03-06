//
//  Reminder.swift
//  RemindersApp
//
//  Created by Isaac Ballas on 12/27/18.
//  Copyright © 2018 Isaac Ballas. All rights reserved.
//

import Foundation
import UIKit

class Checklist: NSObject, Codable {
    var name: String
    var items = [ChecklistItem]()
    var iconName = "No Icon"
    
    init(name: String, iconName: String = "No Icon") {
        self.name = name
        self.iconName = iconName
        super.init()
    }
    
    func countUncheckedItem() -> Int {
        var count = 0
        for item in items where !item.checked {
            count += 1
        }
        return count
    }
}
