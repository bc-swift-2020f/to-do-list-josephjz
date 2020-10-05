//  ToDoDetailTableViewController.swift
//  To Do List
//
//  Created by Jennifer Joseph on 9/27/20.


import UIKit

private let dateFormatter: DateFormatter = {
    print("CREATED 📆 FORMATTER")
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    dateFormatter.timeStyle = .short
    return dateFormatter
}()



class ToDoDetailTableViewController: UITableViewController {
    
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var noteView: UITextView!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var reminderSwitch: UISwitch!
    
    // in the destination view controller, declare (but don't initialize) a variable to catch the data we are about to pass over from source; the destination is ToDoDetailTableViewController.swift
    // String! so that it is an implicitly unwrapped optional
    var toDoItem: ToDoItem!
    
    let datePickerIndexPath = IndexPath(row: 1, section: 1)
    let notesTextViewIndexPath = IndexPath(row: 0, section: 2)
    let notesRowHeight : CGFloat = 200
    let defaultRowHeight : CGFloat = 44
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide keyboard if we tap outside of a field
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        nameField.delegate = self
        
        // check to see if we received a value
        if toDoItem == nil {
            toDoItem = ToDoItem(name: "", date: Date().addingTimeInterval(24*60*60), notes: "", reminderSet: false, completed: false)
            nameField.becomeFirstResponder()
        }
        updateUserInterface()
    }
    
    
    
    
    func updateUserInterface() {
        // so that the User Interface shows updated data
        nameField.text = toDoItem.name
        datePicker.date = toDoItem.date
        noteView.text = toDoItem.notes
        reminderSwitch.isOn = toDoItem.reminderSet
//        if reminderSwitch.isOn{
//            dateLabel.textColor = .black
//        } else {
//            dateLabel.textColor = .gray
//        }
        dateLabel.textColor = (reminderSwitch.isOn ? .black : .gray)
        dateLabel.text = dateFormatter.string(from: toDoItem.date)
        enableDisableSaveButton(text: nameField.text!)
        }
    
    
    // update toDoItem with value inside of nameField.text
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //toDoItem = nameField.text
        toDoItem = ToDoItem(name: nameField.text!, date: datePicker.date, notes: noteView.text, reminderSet: reminderSwitch.isOn, completed: toDoItem.completed)
    }
    
    func enableDisableSaveButton(text: String) {
        if text.count > 0 {
            saveBarButton.isEnabled = true
        } else {
            saveBarButton.isEnabled = false
        }
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
    
    
    @IBAction func reminderSwitchChanged(_ sender: UISwitch) {
        self.view.endEditing(true)
        dateLabel.textColor = (reminderSwitch.isOn ? .black : .gray)
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        self.view.endEditing(true)
        dateLabel.text = dateFormatter.string(from: sender.date)
    }
    
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        enableDisableSaveButton(text: sender.text!)
    }
    
    
}


extension ToDoDetailTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case datePickerIndexPath:
            return reminderSwitch.isOn ? datePicker.frame.height :0
        case notesTextViewIndexPath:
            return notesRowHeight
        default:
            return defaultRowHeight
        }
    }
}

extension ToDoDetailTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        noteView.becomeFirstResponder()
        return true
    }
}
