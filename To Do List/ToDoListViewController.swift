//  Created by Jennifer Joseph on 9/22/20.
//  To Do List App for Chapter 5 of Swift / iOS App Development Fall 2020
//  Learning to work with Table Views in our apps

import UIKit

// change the class name of ViewController in this app because we are
// going to have multiple view controllers; this is going to show list of data in
// our To Do List

class ToDoListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    // class wide arary variable to hold the To Do items for the app
    var toDoArray = ["Learn Swift", "Build Apps", "Change the World", "Take a Vacation"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // this line tells storyboard that this file will be the data source for the tableView object
        tableView.dataSource = self
        // also will be delegate code for storyboard
        tableView.delegate = self
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
            destination.toDoItem = toDoArray[selectedIndexPath.row]
        } else {
            // we only have 2 segues, so the other is "AddDetail"
            // selectedIndexPath is telling us if we have existing selection, and then deselect if we do
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        }
    }
    
    
    
    //
    @IBAction func unwindFromDetail(segue: UIStoryboardSegue) {
        let source = segue.source as! ToDoDetailTableViewController
        // if the table view has an existing row selection, because then we want to update this row
        // if there is a non nil value in selectedIndexPath, then curlies will execute (aka checking if the user has clicked on a cell, and remembering what that click was so we can return there with our unwind
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            // updating data
            toDoArray[selectedIndexPath.row] = source.toDoItem
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
        } else {
            // will execute if selected if selectedIndexPath was nil (happens when we click + because of else clause in prepare() executing and thus deselecting any selectedIndexPath index
            // create new index path: row is toDoArray.count because this will be at the index one past our last used index, giving us space to make new value
            let newIndexPath = IndexPath(row: toDoArray.count, section: 0)
            //appends new value we are getting from source
            toDoArray.append(source.toDoItem)
            tableView.insertRows(at: [newIndexPath], with: .bottom)
            //scrolls user down to row we just inserted
            tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
        }
    }
}


// adopting protocols for tableView
extension ToDoListViewController: UITableViewDelegate, UITableViewDataSource {
    
    // two functions in body of protocol listen in for messages from tableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowsInSection was just called, returning \(toDoArray.count)")
        return toDoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = toDoArray[indexPath.row]
        print("cellForRowAt was just called, for indexPath = \(indexPath.row) which is the  cell containing \(toDoArray[indexPath.row])")
        return cell
    }
    
    
}

