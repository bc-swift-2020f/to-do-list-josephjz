//
//  ToDoItem.swift
//  To Do List
//
//  Created by Jennifer Joseph on 9/28/20.
//

import Foundation

// make this struct in its own file so that it has project wide scope 
struct ToDoItem: Codable {
    var name: String
    var date: Date
    var notes: String
    var reminderSet: Bool
    var notificationID: String?
    var completed: Bool
}
