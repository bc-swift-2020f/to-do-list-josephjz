//  AppDelegate.swift
//  To Do List
//  Created by Jennifer Joseph on 9/22/20.


// file automatically has import UIKit, but we need to add import UserNotifications

import UIKit
import UserNotifications


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // allows notifications center to send messages that trigger functions in our app
        // gives notification center on device right to send messages that are intercepted and received by our app so that we can respond to them
        UNUserNotificationCenter.current().delegate = self
                
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


// need to add this extension!

extension AppDelegate: UNUserNotificationCenterDelegate {

    // code completion tells us that this function asks the delegate how to handle a notification that arrived while the app was running in the foreground
    // this is IMPORTANT because if you were to get a notification from the app, while you're in the app, that notification won't show up
    
    // if we want app to show notifications when it is open (almost always do!); aka ensures notification will show when app is in the foreground
    // close to the same from app to app
    // need to add userNotificationCenter function
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // this code is useful because it gives you a heads up when a notification has been recieved, and its about to be displayed in a running app
        
        let id = notification.request.identifier            // each notification has a unique id
        print("Recieved in-app notification with notification ID: \(id)")
        
        // don't want notifications lingering once the notification has been delivered
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        
        // elements of array represent different types of notifications that the app offers
        completionHandler([.alert,.sound])
    }
}
