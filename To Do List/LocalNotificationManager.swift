//
//  LocalNotificationManager.swift
//  To Do List
//
//  Created by Jennifer Joseph on 10/5/20.
//

import Foundation
import UserNotifications

struct LocalNotificationManager {
    
    // this code gets user authorization to send them notifications
    // pass in the kinds of notifications that will be authorized
    // remember that UNUserNotificationCenter.current() go together
    // when code completion comes up, double click bool part to change it to "trailing closure" because last parameter in method is a closure, aka block of code that we operate on after we get a bool or an optionally wrapped error; therefore code has to decide what to do when given either one of these
    // granted for true or false that authorization has been given
    static func authorizeLocalNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]) { (granted, error) in
            
            // code for error
            // want to deal w error if error is not nil
            // guards and makes sure that the only thing that pass are if the error is nil (no error)
            // else happens if there is a error
            guard error == nil else {
                print("ERROR: \(error!.localizedDescription)")
                return
            }
            
            //code for bool
            if granted {
                print("notification authorization granted" )
                
            } else {
                print("user denied notifications")
                // TODO: add alert later on telling the user what to do
                
            }
        }
    }
    
    
    
    // the values set for .title,subtitle,and body are the only 3 modifications specific to this app
    // if you want a diff sound you have to make a custom sound using variable and UNNotificationSoundName, and UNNotificationName
    // audio data is a lil finicky, have to drag .wav, .aiff, or .caf and have to be < 30 second
    // note that it returns a String and this is the unique identifier of each notification
    static func setCalendarNotification(title: String, subtitle: String, body: String, badgeNumber: NSNumber?, sound: UNNotificationSound?, date: Date) -> String {
        
        // create content
        // first create empty var content of type UNMutableNotificationContent and then populate it
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.sound = sound
        content.badge = badgeNumber
        
        //create trigger -- pass in date components
        // first line breaks up date conviently as day, month year
        var dateComponents = Calendar.current.dateComponents([.year,.month,.day, .hour, .minute], from: date)
        dateComponents.second = 00
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        //create request
        let notificationID = UUID().uuidString
        let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)
        
        //register request with the notification center
        UNUserNotificationCenter.current().add(request) { (error) in
            // means error is not nil
            if let error = error {
                print("ERROR: \(error.localizedDescription) YIKES MAN, adding notification request went wrong")
            } else {
                print("Notification scheduled \(notificationID), title: \(content.title)")
            }
        }
        
        return notificationID
    }
    
    
}
