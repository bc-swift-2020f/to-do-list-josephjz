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

