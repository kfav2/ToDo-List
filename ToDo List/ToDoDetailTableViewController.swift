//
//  ToDoDetailTableViewController.swift
//  ToDo List
//
//  Created by Korlin Favara on 1/1/22.
//

import UIKit

// cached dateFormatter to this doc. allows you to use it, while only calling once
private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.timeStyle = .short
    dateFormatter.dateStyle = .short
    return dateFormatter
}()

class ToDoDetailTableViewController: UITableViewController {
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var noteView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var reminderSwitch: UISwitch!
    
    var toDoItem: ToDoItem!
    
    let datePickerIndexPath = IndexPath(row: 1, section: 1)
    let notesViewIndexPath = IndexPath(row: 0, section: 2)
    let notesRowHeight: CGFloat = 200
    let defaultRowHeight: CGFloat = 44
    
     override func viewDidLoad() {
        super.viewDidLoad()
        
         if toDoItem == nil {
             toDoItem = ToDoItem(name: "", date: Date().addingTimeInterval(24*60*60), notes: "", reminderSet: false, completed: false)
         }
        
         updateUserInterface()
    }
    
    func updateUserInterface() {
        nameField.text = toDoItem.name
        datePicker.date = toDoItem.date
        noteView.text = toDoItem.notes
        reminderSwitch.isOn = toDoItem.reminderSet
        dateLabel.textColor = (reminderSwitch.isOn ? .black: .gray)
        dateLabel.text = dateFormatter.string(from: toDoItem.date)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        toDoItem = ToDoItem(name: nameField.text!, date: datePicker.date, notes: noteView.text, reminderSet: reminderSwitch.isOn, completed: toDoItem.completed)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        // code is asking the presentingViewController if it is a UINavigationController.
        // UINavigationControllers present modally - have to dismiss
        // otherwise view controller is not going through navigation controller - have to pop
        // it should be noted these are all in a higher level navigatio controller
        // isPresentingInAddMode becomes true or false
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            // although at this point you would not be in a UINavigationController, popViewController pops the top view controller from the stack
            navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func reminderSwitchChanged(_ sender: UISwitch) {
        dateLabel.textColor = (reminderSwitch.isOn ? .black: .gray)
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        dateLabel.text = dateFormatter.string(from: sender.date)
    }
    
    
}

extension ToDoDetailTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case datePickerIndexPath:
            return reminderSwitch.isOn ? datePicker.frame.height : 0
        case notesViewIndexPath:
            return notesRowHeight
        default:
            return defaultRowHeight
        }
    }
}
