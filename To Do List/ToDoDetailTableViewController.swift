//  ToDoDetailTableViewController.swift
//  To Do List
//
//  Created by Jennifer Joseph on 9/27/20.


import UIKit

class ToDoDetailTableViewController: UITableViewController {
    
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var noteView: UITextView!
    
    // in the destination view controller, declare (but don't initialize) a variable to catch the data we are about to pass over from source; the destination is ToDoDetailTableViewController.swift
    // String! so that it is an implicitly unwrapped optional
    var toDoItem: ToDoItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // check to see if we received a value
        if toDoItem == nil {
            toDoItem = ToDoItem(name: "", date: Date(), notes: "")
        }
        
        // so that the User Interface shows updated data
        nameField.text = toDoItem.name
        datePicker.date = toDoItem.date
        noteView.text = toDoItem.notes
    }
    
    
    // update toDoItem with value inside of nameField.text
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //toDoItem = nameField.text
        toDoItem = ToDoItem(name: nameField.text!, date: datePicker.date, notes: noteView.text)
    }
    
    
    
    
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        // able to reuse this whenever you need similar cancel button behavior
        // depending on how view controller was presented, we are going to use 1 of 2 diff commands
        //      present modally? Cancel with dismiss command
        //      show segue? Cancel with pop (remember that show pushes view controller on stack)
        
        // check to see if view controller that we are looking at was presented from a navigation controller
        let isPresentingInAddMode = presentingViewController is UINavigationController
        
        // else corresponds to show segue, if with present modally
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}
