//
//  ToDoDetailTableViewController.swift
//  ToDo List
//
//  Created by Korlin Favara on 1/1/22.
//

import UIKit

class ToDoDetailTableViewController: UITableViewController {
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var noteView: UITextView!
   
    var toDoItem: String!
    
     override func viewDidLoad() {
        super.viewDidLoad()
        
         if toDoItem == nil {
             toDoItem = ""
         }
        
        nameField.text = toDoItem
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        toDoItem = nameField.text
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
    
}
