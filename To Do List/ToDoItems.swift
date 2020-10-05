//
//  ToDoItems.swift
//  To Do List
//
//  Created by Jennifer Joseph on 10/5/20.
//

import Foundation

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
}
