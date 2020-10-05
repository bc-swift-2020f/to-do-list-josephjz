//  Created by Jennifer Joseph on 9/22/20.
//  To Do List App for Chapter 5 of Swift / iOS App Development Fall 2020
//  Learning to work with Table Views in our apps

import UIKit
import UserNotifications    // MAKE SURE TO INCLUDE THIS LINE FOR FRAMEWORK

// change the class name of ViewController in this app because we are
// going to have multiple view controllers; this is going to show list of data in
// our To Do List

class ToDoListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    // class wide arary variable to hold the To Do items for the app
    //var toDoArray = ["Learn Swift", "Build Apps", "Change the World", "Take a Vacation"]
    
    // using stuct instead of array
    var toDoItems: [ToDoItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // this line tells storyboard that this file will be the data source for the tableView object
        tableView.dataSource = self
        
        // also will be delegate code for storyboard
        tableView.delegate = self
        
        loadData()
        authorizeLocalNotifications()
    }
    
    
    func setNotifications() {
        
        // dont want to run this if there are no items in toDoItems List
        guard toDoItems.count > 0 else {
            return
        }
        //remove all notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        //now we recreate the notifications with the data we just saved
        
        // note if we did for item in toDoItems we couldnt change item because it wpuld be a constant so instead we use index to access the data and change it
        for index in  0..<toDoItems.count {
            if toDoItems[index].reminderSet {
                let toDoItem = toDoItems[index]
                toDoItems[index].notificationID = setCalendarNotification(title: toDoItem.name, subtitle: "", body: toDoItem.notes, badgeNumber: nil, sound: .default, date: toDoItem.date)
            }
            
        }
        
    }
    
    
    
    
    
    
    // the values set for .title,subtitle,and body are the only 3 modifications specific to this app
    // if you want a diff sound you have to make a custom sound using variable and UNNotificationSoundName, and UNNotificationName
    // audio data is a lil finicky, have to drag .wav, .aiff, or .caf and have to be < 30 second
    // note that it returns a String and this is the unique identifier of each notification
    func setCalendarNotification(title: String, subtitle: String, body: String, badgeNumber: NSNumber?, sound: UNNotificationSound?, date: Date) -> String {
        
        // create content
        // first create empty var content of type UNMutableNotificationContent and then populate it
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.sound = sound
        content.badge = badgeNumber
        
        //create trigger -- pass in date components
        // first line breaks up date conviently as day, month year
        var dateComponents = Calendar.current.dateComponents([.year,.month,.day, .hour, .minute], from: date)
        dateComponents.second = 00
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        //create request
        let notificationID = UUID().uuidString
        let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)
        
        //register request with the notification center
        UNUserNotificationCenter.current().add(request) { (error) in
            // means error is not nil
            if let error = error {
                print("ERROR: \(error.localizedDescription) YIKES MAN, adding notification request went wrong")
            } else {
                print("Notification scheduled \(notificationID), title: \(content.title)")
            }
        }
        
        return notificationID
    }
    
    
    // this code gets user authorization to send them notifications
    // pass in the kinds of notifications that will be authorized
    // remember that UNUserNotificationCenter.current() go together
    // when code completion comes up, double click bool part to change it to "trailing closure" because last parameter in method is a closure, aka block of code that we operate on after we get a bool or an optionally wrapped error; therefore code has to decide what to do when given either one of these

    // granted for true or false that authorization has been given
    func authorizeLocalNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]) { (granted, error) in
            
            // code for error
            // want to deal w error if error is not nil
            // guards and makes sure that the only thing that pass are if the error is nil (no error)
            // else happens if there is a error
            guard error == nil else {
                print("ERROR: \(error!.localizedDescription)")
                return
            }
            
            //code for bool
            if granted {
                print("notification authorization granted" )
                
            } else {
                print("user denied notifications")
                // TODO: add alert later on telling the user what to do
                
            }
        }
    }
    
    
    func loadData() {
        
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentURL = directoryURL.appendingPathComponent("todos").appendingPathExtension("json")
        
        // read in data at this document url inside of let guard statement
        guard let data = try? Data(contentsOf: documentURL) else {return}
        let jsonDecoder = JSONDecoder()
       
        do  {
            toDoItems = try jsonDecoder.decode(Array<ToDoItem>.self, from: data)
            tableView.reloadData()
        } catch {
            print("😡Error: Could not load data \(error.localizedDescription)")
        }
    }
    
    
    
    //go through file manager for saving directory location
    func saveData() {
        
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentURL = directoryURL.appendingPathComponent("todos").appendingPathExtension("json")
        let jsonEncoder = JSONEncoder()
        let data = try? jsonEncoder.encode(toDoItems)
       
        do {
            try data?.write(to: documentURL, options: .noFileProtection)
        } catch {
            print("😡Error: Could not save data \(error.localizedDescription)")
        }
        
        setNotifications()
   
    }
    
     
    
    // function passes in UIStoryboardSegue, triggered automatically just before segue happens in this viewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // ShowDetail is the Identifier name we gave to segue from to do list to scene for adding event
        if segue.identifier == "ShowDetail" {
            
            // constant to hold destination
            // using as! allows us to set name of subclass so we are using file we want
            // destination is the ToDoDetailTableViewController which has "ShowDetail" which we are referencing
            let destination = segue.destination as! ToDoDetailTableViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
           
            //destination.toDoItem = toDoArray[selectedIndexPath.row]
            destination.toDoItem = toDoItems[selectedIndexPath.row]
        
        } else {
            
            // we only have 2 segues, so the other is "AddDetail"
            // selectedIndexPath is telling us if we have existing selection, and then deselect if we do
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        }
    }
    
    
    @IBAction func unwindFromDetail(segue: UIStoryboardSegue) {
        let source = segue.source as! ToDoDetailTableViewController
        // if the table view has an existing row selection, because then we want to update this row
        // if there is a non nil value in selectedIndexPath, then curlies will execute (aka checking if the user has clicked on a cell, and remembering what that click was so we can return there with our unwind
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            // updating data
            //toDoArray[selectedIndexPath.row] = source.toDoItem
            toDoItems[selectedIndexPath.row] = source.toDoItem
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
        } else {
            // will execute if selected if selectedIndexPath was nil (happens when we click + because of else clause in prepare() executing and thus deselecting any selectedIndexPath index
            // create new index path: row is toDoArray.count because this will be at the index one past our last used index, giving us space to make new value
            //let newIndexPath = IndexPath(row: toDoArray.count, section: 0)
            let newIndexPath = IndexPath(row: toDoItems.count, section: 0)
            //appends new value we are getting from source
            //toDoArray.append(source.toDoItem)
            toDoItems.append(source.toDoItem)
            tableView.insertRows(at: [newIndexPath], with: .bottom)
            //scrolls user down to row we just inserted
            tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
        }
        
        saveData()
        
    }
    
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        // check if table view is in editing mode
        if tableView.isEditing {
            //opposite of else block
            tableView.setEditing(false, animated: true)
            sender.title = "Edit"
            addBarButton.isEnabled = true
            
        } else {
            // want to set tableView.isEditing to true, set title of editing button to done using sender as button that was clicked on (aka edit), disable the add bar button
            tableView.setEditing(true, animated: true)
            sender.title = "Done"
            addBarButton.isEnabled = false
        }
    }
}


// adopting protocols for tableView
extension ToDoListViewController: UITableViewDelegate, UITableViewDataSource, ListTableViewCellDelegate {
    func checkBoxToggle(sender: ListTableViewCell) {
        if let selectedIndexPath = tableView.indexPath(for: sender) {
            // toggle the selection of button that holds check box; this will turn true to false, false to true
            toDoItems[selectedIndexPath.row].completed = !toDoItems[selectedIndexPath.row].completed
            //reloads the row we just changed to update interface
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
        }
        // DONT FORGET TO CALL SAVE DATA AFTER CHANGING DATA ASSOCIATED WITH BUTTON
        saveData()
    }
    
    
    // two functions in body of protocol listen in for messages from tableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("numberOfRowsInSection was just called, returning \(toDoArray.count)")
//        return toDoArray.count
        print("numberOfRowsInSection was just called, returning \(toDoItems.count)")
        return toDoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // cell is of type UITableViewCell -- this doesnt have IB outlets, subclass listtableviewcell has them
        // we use as! so that the constant is taken as the subclass u assign
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListTableViewCell
        // next line makes the viewController the delegate of the listTableViewCell
        cell.delegate = self
        cell.toDoItem = toDoItems[indexPath.row]
        //cell.nameLabel.text = toDoItems[indexPath.row].name
        //cell.checkBoxButton.isSelected = toDoItems[indexPath.row].completed
        //cell.textLabel?.text = toDoItems[indexPath.row].name
        //print("cellForRowAt was just called, for indexPath = \(indexPath.row) which is the  cell containing \(toDoItems[indexPath.row])")
        return cell
    }
    
    
    // works for both insertion and deletion
    // asks the data source to commit the insertion or deletion of a specified row in the receiver
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // index value of element to remove is passed in as arg
            //toDoArray.remove(at: indexPath.row)
            toDoItems.remove(at: indexPath.row)
            // now element is removed from array, and need to remove row from table view
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveData()
        }
    }
    

    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // need to move data by deleting data from source index path.row, and insert the data at destination indexpath. row
        // need a copy of data since we delete it first
//        let itemToMove = toDoArray[sourceIndexPath.row]
//        toDoArray.remove(at: sourceIndexPath.row)
//        toDoArray.insert(itemToMove, at: destinationIndexPath.row)
        let itemToMove = toDoItems[sourceIndexPath.row]
        toDoItems.remove(at: sourceIndexPath.row)
        toDoItems.insert(itemToMove, at: destinationIndexPath.row)
        saveData()
    }
    
    
}

