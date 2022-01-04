//
//  ViewController.swift
//  ToDo List
//
//  Created by Korlin Favara on 1/1/22.
//

import UIKit

class ToDoListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    // var toDoItems: [ToDoItem] = []
    var toDoItems = ToDoItems()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Swift needs data for tableView to do what it needs to
        // This line says you can get the data from self
        tableView.delegate = self
        tableView.dataSource = self
        
        toDoItems.loadData {
            self.tableView.reloadData()
        }
        authorizeLocalNotifications()
    }
    
    func authorizeLocalNotifications() {
        // requests authorization from user for local notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            guard error == nil else {
                print("ERROR: \(error!.localizedDescription)")
                return
            }
            if granted {
                print("Notification Authorization Granted")
            } else {
                print("User has denied access to Notifications")
                //TODO: Put in alert here to tell user what to do
            }
        }
    }
    
    func setNotifications() {
        guard toDoItems.itemsArray.count > 0 else {
            return
        }
        // remove all notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        // and lets re-create them with the data we just saved
        for index in 0..<toDoItems.itemsArray.count {
            if toDoItems.itemsArray[index].reminderSet {
                toDoItems.itemsArray[index].notificationID = setCalendarNotifications(title: toDoItems.itemsArray[index].name, subtitle: "", body: toDoItems.itemsArray[index].notes, badgeNumber: nil, sound: .default, date: toDoItems.itemsArray [index].date)
            }
        }
    }
    
    func setCalendarNotifications (title: String, subtitle: String, body: String, badgeNumber: NSNumber?, sound: UNNotificationSound!, date: Date) -> String {
        let content = UNMutableNotificationContent()
        // create content
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.badge = badgeNumber
        content.sound = sound
        
        // create trigger
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        dateComponents.second = 00
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        // create request
        let notificationID = UUID().uuidString // creates unique universal identifier for notificationID
        let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)
        
        // register reuqest with UNNotificationCenter
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("ERROR: \(error.localizedDescription). Adding notification requests went wrong!")
            } else {
                print("Notification scheduled \(notificationID), title: \(content.title)")
            }
        }
        return notificationID
    }
    
    // reusable code to access file directory
    func saveData() {
        toDoItems.saveData()
        setNotifications()
    }
     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let destination = segue.destination as! ToDoDetailTableViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.toDoItem = toDoItems.itemsArray[selectedIndexPath.row]
        } else {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedIndexPath, animated: true )
            }
        }
    }
    
    @IBAction func unwindFromDetail(segue: UIStoryboardSegue ) {
        let source = segue.source as! ToDoDetailTableViewController
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            toDoItems.itemsArray[selectedIndexPath.row] = source.toDoItem
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
        } else {
            let newIndexPath = IndexPath(row: toDoItems.itemsArray.count, section: 0)
            toDoItems.itemsArray.append(source.toDoItem)
            tableView.insertRows(at: [newIndexPath], with: .bottom)
            tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
        }
        saveData()
    }
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            sender.title = "Edit"
            addBarButton.isEnabled = true
        } else {
            tableView.setEditing(true, animated: true)
            sender.title = "Done"
            addBarButton.isEnabled = false
        }
    }
    

}

extension ToDoListViewController: UITableViewDelegate, UITableViewDataSource, ListTableViewCellDelegate {
    func checkBoxToggled(sender: ListTableViewCell) {
        // figure out which row was pressed
        if let selectedIndexPath = tableView.indexPath(for: sender) {
            toDoItems.itemsArray[selectedIndexPath.row].completed = !toDoItems.itemsArray[selectedIndexPath.row].completed
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
            saveData()
        } 
    }
    
    // how many cells are in UITable, returns Int
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        toDoItems.itemsArray.count
    }
    
    // formatting cells so that they are "re-used", iOS only uses a defined amount of cells on a page. e.g. if table has 1000 elements, when you scroll the cells move and are reused
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListTableViewCell
        cell.delegate = self
        cell.toDoItem = toDoItems.itemsArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            toDoItems.itemsArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveData()
        }
        
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = toDoItems.itemsArray[sourceIndexPath.row]
        toDoItems.itemsArray.remove(at: sourceIndexPath.row)
        toDoItems.itemsArray.insert(itemToMove, at: destinationIndexPath.row)
        saveData()
    }
}
