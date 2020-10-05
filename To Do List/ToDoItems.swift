//
//  ToDoItems.swift
//  To Do List
//
//  Created by Jennifer Joseph on 10/5/20.
//

import Foundation
import UserNotifications

class ToDoItems {
    var itemsArray: [ToDoItem] = []
    
    
    //go through file manager for saving directory location
    func saveData() {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentURL = directoryURL.appendingPathComponent("todos").appendingPathExtension("json")
        let jsonEncoder = JSONEncoder()
        let data = try? jsonEncoder.encode(itemsArray)
        do {
            try data?.write(to: documentURL, options: .noFileProtection)
        } catch {
            print("😡Error: Could not save data \(error.localizedDescription)")
        }
        setNotifications()
    }
    
    // () -> () means completion handler isnt accepting anything inside, or expecting to pass anything out
    func loadData(completed: @escaping ()->() ) {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentURL = directoryURL.appendingPathComponent("todos").appendingPathExtension("json")
        
        // read in data at this document url inside of let guard statement
        guard let data = try? Data(contentsOf: documentURL) else {return}
        let jsonDecoder = JSONDecoder()
        
        do  {
            itemsArray = try jsonDecoder.decode(Array<ToDoItem>.self, from: data)
        } catch {
            print("😡Error: Could not load data \(error.localizedDescription)")
        }
        completed()
    }
    
    
    func setNotifications() {
        // dont want to run this if there are no items in toDoItems List
        guard itemsArray.count > 0 else {
            return
        }
        //remove all notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        //now we recreate the notifications with the data we just saved
        
        // note if we did for item in toDoItems we couldnt change item because it wpuld be a constant so instead we use index to access the data and change it
        for index in  0..<itemsArray.count {
            if itemsArray[index].reminderSet {
                let toDoItem = itemsArray[index]
                itemsArray[index].notificationID = LocalNotificationManager.setCalendarNotification(title: toDoItem.name, subtitle: "", body: toDoItem.notes, badgeNumber: nil, sound: .default, date: toDoItem.date)
            }
        }
    }
    
    
}
