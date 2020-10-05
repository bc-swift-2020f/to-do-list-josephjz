//
//  ListTableViewCell.swift
//  To Do List
//
//  Created by Jennifer Joseph on 10/5/20.
//

// first, delete everything within the class {} to start from scratch

// have to go to ID inspector for table view cell and change the custom class to this file name

import UIKit

// PROTOCOLS: "a blueprint of methods, properties, and other requirements to implement functionality
//            need to add : class after whatever name we give the protocol

protocol ListTableViewCellDelegate: class {
    
    // (sender: ListTableViewCell) means that this tableViewCell can send message to any viewcontroller that adopts this protocol
    func checkBoxToggle(sender: ListTableViewCell)
}

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    // keeps track of which object is our delegate
    weak var delegate : ListTableViewCellDelegate?
    
    var toDoItem: ToDoItem! {
        didSet {
            // if we change either toDoItem, update nameLabel and checkBoxItem.isSelected
            nameLabel.text = toDoItem.name
            checkBoxButton.isSelected = toDoItem.completed
        }
    }
    
    @IBAction func checkToggled(_ sender: Any) {
        // holds any viewController that adopts this protocol
        delegate?.checkBoxToggle(sender: self)
    }
}
