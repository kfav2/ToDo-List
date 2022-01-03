//
//  ToDoItem.swift
//  ToDo List
//
//  Created by Korlin Favara on 1/2/22.
//

import Foundation

struct ToDoItem: Codable {
    var name: String
    var date: Date
    var notes: String
    var reminderSet: Bool
}

