//
//  Reminder.swift
//  RemindersApp
//
//  Created by Isaac Ballas on 12/27/18.
//  Copyright © 2018 Isaac Ballas. All rights reserved.
//

import Foundation
import UIKit

class Checklist: NSObject {
    var name: String
    var items = [ChecklistItem]()
    init(name: String) {
        self.name = name
        super.init()
    }
}
