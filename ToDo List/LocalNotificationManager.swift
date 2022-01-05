//
//  LocalNotificationManager.swift
//  ToDo List
//
//  Created by Korlin Favara on 1/4/22.
//

import UserNotifications
import UIKit

struct LocalNotificationsManager {
    static func authorizeLocalNotifications(viewController: UIViewController) {
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
                DispatchQueue.main.async {
                    viewController.oneButtonAlert(title: "User Has Not Allowed Notifications", message: "To receive alerts for reminders, open the Settings app, select To Do List > Notifications > Allow Notifications.")
                }
            }
        }
    }
    static func isAuthorized(completed: @escaping (Bool)->() ) {
        // requests authorization from user for local notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            guard error == nil else {
                print("ERROR: \(error!.localizedDescription)")
                completed (false)
                return
            }
            if granted {
                print("Notification Authorization Granted")
                completed (true)
            } else {
                print("User has denied access to Notifications")
                completed (false)
            }
        }
    }
    static func setCalendarNotifications (title: String, subtitle: String, body: String, badgeNumber: NSNumber?, sound: UNNotificationSound!, date: Date) -> String {
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
}
