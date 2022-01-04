//
//  ToDoItems.swift
//  ToDo List
//
//  Created by Korlin Favara on 1/4/22.
//

import Foundation
import UserNotifications

class ToDoItems {
    var itemsArray: [ToDoItem] = []
    
    func loadData(completed: @escaping ()->() ) {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentURL = directoryURL.appendingPathComponent("todos").appendingPathExtension("json")

        // if there is no data to load, without this statement app would crash. This says, if no data, then no need to load data
        guard let data = try? Data(contentsOf: documentURL) else {return}
        let jsonDecoder = JSONDecoder()
        do {
            itemsArray = try jsonDecoder.decode(Array<ToDoItem>.self, from: data)
        } catch {
            print("ERROR: Count not save data \(error.localizedDescription )")
        }
        completed()
    }
    
    func saveData() {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentURL = directoryURL.appendingPathComponent("todos").appendingPathExtension("json")
        let jsonEncoder = JSONEncoder()
        let data = try? jsonEncoder.encode(itemsArray)
        do {
            try data?.write(to: documentURL, options: .noFileProtection)
        } catch {
            print("ERROR: Count not save data \(error.localizedDescription )")
        }
        setNotifications()
    }
    
    func setNotifications() {
        guard itemsArray.count > 0 else {
            return
        }
        // remove all notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        // and lets re-create them with the data we just saved
        for index in 0..<itemsArray.count {
            if itemsArray[index].reminderSet {
                itemsArray[index].notificationID = LocalNotificationsManager.setCalendarNotifications(title: itemsArray[index].name, subtitle: "", body: itemsArray[index].notes, badgeNumber: nil, sound: .default, date: itemsArray [index].date)
            }
        }
    }
}
