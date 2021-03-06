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
    //var toDoItems: [ToDoItem] = []
    
    // creates object
    var toDoItems = ToDoItems()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // this line tells storyboard that this file will be the data source for the tableView object
        tableView.dataSource = self
        
        // also will be delegate code for storyboard
        tableView.delegate = self
        
        toDoItems.loadData {
            self.tableView.reloadData()
        }
        
        LocalNotificationManager.authorizeLocalNotifications(viewController: self)
    }
    

    //go through file manager for saving directory location
    func saveData() {
        toDoItems.saveData()
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
            destination.toDoItem = toDoItems.itemsArray[selectedIndexPath.row]
        
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
            toDoItems.itemsArray[selectedIndexPath.row] = source.toDoItem
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
        } else {
            // will execute if selected if selectedIndexPath was nil (happens when we click + because of else clause in prepare() executing and thus deselecting any selectedIndexPath index
            // create new index path: row is toDoArray.count because this will be at the index one past our last used index, giving us space to make new value
            //let newIndexPath = IndexPath(row: toDoArray.count, section: 0)
            let newIndexPath = IndexPath(row: toDoItems.itemsArray.count, section: 0)
            //appends new value we are getting from source
            //toDoArray.append(source.toDoItem)
            toDoItems.itemsArray.append(source.toDoItem)
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
            toDoItems.itemsArray[selectedIndexPath.row].completed = !toDoItems.itemsArray[selectedIndexPath.row].completed
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
        print("numberOfRowsInSection was just called, returning \(toDoItems.itemsArray.count)")
        return toDoItems.itemsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // cell is of type UITableViewCell -- this doesnt have IB outlets, subclass listtableviewcell has them
        // we use as! so that the constant is taken as the subclass u assign
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListTableViewCell
        // next line makes the viewController the delegate of the listTableViewCell
        cell.delegate = self
        cell.toDoItem = toDoItems.itemsArray[indexPath.row]
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
            toDoItems.itemsArray.remove(at: indexPath.row)
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
        let itemToMove = toDoItems.itemsArray[sourceIndexPath.row]
        toDoItems.itemsArray.remove(at: sourceIndexPath.row)
        toDoItems.itemsArray.insert(itemToMove, at: destinationIndexPath.row)
        saveData()
    }
    
    
}

