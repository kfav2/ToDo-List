//
//  ToDoDetailTableViewController.swift
//  ToDo List
//
//  Created by Korlin Favara on 1/1/22.
//

import UIKit
import UserNotifications

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
    @IBOutlet weak var compactDatePicker: UIDatePicker!
    
    var toDoItem: ToDoItem!
    
    let datePickerIndexPath = IndexPath(row: 1, section: 1)
    let notesViewIndexPath = IndexPath(row: 0, section: 2)
    let notesRowHeight: CGFloat = 200
    let defaultRowHeight: CGFloat = 44
    
     override func viewDidLoad() {
        super.viewDidLoad()
        
         // show or hide the appropriate date picker
         if #available(iOS 14.0, *) { // use compact
             datePicker = compactDatePicker
             datePicker.isHidden = false
             dateLabel.isHidden = true
         } else { // use old wheel
             compactDatePicker.isHidden = true
             dateLabel.isHidden = false
         }
         
         // setup foreground notification
         let notificationCenter = NotificationCenter.default
         notificationCenter.addObserver(self, selector: #selector(appActiveNotification), name: UIApplication.didBecomeActiveNotification, object: nil)
         
         // hide keyboard if we tap  outside of a field
         let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
         tap.cancelsTouchesInView = false
         self.view.addGestureRecognizer(tap)
         
         if toDoItem == nil {
             toDoItem = ToDoItem(name: "", date: Date().addingTimeInterval(24*60*60), notes: "", reminderSet: false, completed: false)
             nameField.becomeFirstResponder()
             nameField.delegate = self
         }
        
         updateUserInterface()
    }
    
    @objc func appActiveNotification() {
        print("The app just came to the foregroud")
        updateReminderSwitch()
    }
    
    func enableDisableSaveButton(text: String) {
        if text.count > 0 {
            saveBarButton.isEnabled = true
        } else {
            saveBarButton.isEnabled = false
        }
    }
    
    func updateUserInterface() {
        nameField.text = toDoItem.name
        datePicker.date = toDoItem.date
        noteView.text = toDoItem.notes
        reminderSwitch.isOn = toDoItem.reminderSet
        dateLabel.textColor = (reminderSwitch.isOn ? .black: .gray)
        dateLabel.text = dateFormatter.string(from: toDoItem.date)
        datePicker.isEnabled = reminderSwitch.isOn
        enableDisableSaveButton(text: nameField.text!)
        updateReminderSwitch()
    }
    
    func updateReminderSwitch() {
        LocalNotificationsManager.isAuthorized { (authorized) in
            DispatchQueue.main.async {
                if !authorized && self.reminderSwitch.isOn {
                    self.oneButtonAlert(title: "User Has Not Allowed Notifications", message: "To receive alerts for reminders, open the Settings app, select To Do List > Notifications > Allow Notifications.")
                    self.reminderSwitch.isOn = false
                }
                self.view.endEditing(true)
                self.dateLabel.textColor = (self.reminderSwitch.isOn ? .black: .gray)
                self.datePicker.isEnabled = self.reminderSwitch.isOn
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            }
        }
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
        updateReminderSwitch()
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
            if #available(iOS 14.0, *) {
                return 0
            } else {
                return reminderSwitch.isOn ? datePicker.frame.height : 0
            }
            
        case notesViewIndexPath:
            return notesRowHeight
        default:
            return defaultRowHeight
        }
    }
}

extension ToDoDetailTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textfield: UITextField) -> Bool {
        noteView.becomeFirstResponder()
        return true
    }
}
