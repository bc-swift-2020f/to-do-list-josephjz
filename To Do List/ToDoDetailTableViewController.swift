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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
