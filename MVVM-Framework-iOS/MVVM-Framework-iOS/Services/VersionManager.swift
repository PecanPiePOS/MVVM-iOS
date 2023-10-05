//
//  VersionManager.swift
//  MVVM-Framework-iOS
//
//  Created by KYUBO A. SHIM on 2023/10/04.
//

import UIKit

struct VersionModelType {
    
    enum UpdatePolicy {
        case userChoice // Users can choose whether to update or not
        case userChoiceWithWarning // Users can choose whether to update, but there's a warning
        case mandatory // Users must update, or they cannot use the app
    }
    
    let latestVersion: String
    let currentVersion: String
    let isUpdateNeeded: Bool
    let isForceUpdateNeeded: Bool
}

final class VersionManager {
    /// Should work Asynchronous ⚠️
    func getLatestVersion() async -> String? {
        guard let bundleIdentifier = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String,
              let url = URL(string: "https://itunes.apple.com/kr/lookup?bundleId=com.tellingUs.tellingMe"),
              let (data, _) = try? await URLSession.shared.data(from: url),
              let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let results = json["results"] as? [[String: Any]],
              let appStoreVersion = results[0]["version"] as? String else {
            return nil
        }
              
//        
//         else {
//            print("URLSESSION NOPE!!!")
//            return nil }
//        print(data, "🚩")
//        guard  else {
//            return nil
//        }
////              let appStoreVersion = results[0]["version"] as? String else {
////            return nil
////        }
        let version = appStoreVersion
//        print(json, response, "🍕")
        print(version, "🍕")
        return version
    }
    
    func getCurrentVersion() -> String? {
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return nil
        }
        print(version)
        return version
    }
    
    /// Should work Asynchronous ⚠️
    func shouldUpdate() async -> VersionModelType! {
        guard let currentVersion = getCurrentVersion(),
            let latestVersion = await getLatestVersion() else { return nil }
        print("Current Version: \(currentVersion)", "Latest Version: \(latestVersion)")
        
        let currentVersionArray = currentVersion.split(separator: ".").map { $0 }
        let latestVersionArray = latestVersion.split(separator: ".").map { $0 }
        
        let currentMajorVersion = currentVersionArray[0]
        let currentMinorVersion = currentVersionArray[1]
        let currentMaintenanceVersion = currentVersionArray[2]
        
        let latestMajorVersion = latestVersionArray[0]
        let latestMinorVersion = latestVersionArray[1]
        let latestMaintenanceVersion = latestVersionArray[2]
        
        if currentMajorVersion < latestMajorVersion {
            // 취소가 없는 Alert
            print("Version Branch 1")
            return VersionModelType(latestVersion: latestVersion, currentVersion: currentVersion, isUpdateNeeded: true, isForceUpdateNeeded: true)
        }
        
        if currentMinorVersion < latestMinorVersion {
            // 취소가 있지만, Warning 이 있는 Alert
            print("Version Branch 2")
            return VersionModelType(latestVersion: latestVersion, currentVersion: currentVersion, isUpdateNeeded: true, isForceUpdateNeeded: false)
        }
        
        if currentMaintenanceVersion < latestMaintenanceVersion {
            // 취소가 있는 Alert
            print("Version Branch 3")
            return VersionModelType(latestVersion: latestVersion, currentVersion: currentVersion, isUpdateNeeded: true, isForceUpdateNeeded: false)
        }
        
        return nil
    }
}


/**
 
 Checking Times to update automatically
 
 import Foundation

 // Define your UserDefaults key
 let lastUpdateDateKey = "lastUpdateDate"

 // Function to check and update the value
 func checkAndUpdateValue() {
     let userDefaults = UserDefaults.standard
     let currentDate = Date()

     // Check if the last update date is stored in UserDefaults
     if let lastUpdateDate = userDefaults.object(forKey: lastUpdateDateKey) as? Date {
         // Calculate the time interval between current date and last update date
         let timeInterval = currentDate.timeIntervalSince(lastUpdateDate)
         
         // Check if the time interval is greater than or equal to seven days (7 days * 24 hours * 60 minutes * 60 seconds)
         if timeInterval >= 7 * 24 * 60 * 60 {
             // Perform the update here
             // For example, update a UserDefaults value:
             userDefaults.set("NewValue", forKey: "YourValueKey")
             
             // Update the "lastUpdateDate" with the current date
             userDefaults.set(currentDate, forKey: lastUpdateDateKey)
         }
     } else {
         // If the last update date is not stored, set it to the current date
         userDefaults.set(currentDate, forKey: lastUpdateDateKey)
     }
     
     // Synchronize UserDefaults to save changes
     userDefaults.synchronize()
 }

 // Call the function when needed to check and update the value
 checkAndUpdateValue()

 
 */


/**
 
 
 import UIKit
 import UserNotifications

 // Define your UserDefaults key
 let lastUpdateDateKey = "lastUpdateDate"

 @UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate {

     var window: UIWindow?

     func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
         // Request user permission for notifications
         UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
             if granted {
                 // Schedule a repeating local notification every seven days
                 self.scheduleLocalNotification()
             }
         }
         return true
     }
     
     // Function to schedule a repeating local notification every seven days
     func scheduleLocalNotification() {
         let content = UNMutableNotificationContent()
         content.title = "Update Reminder"
         content.body = "It's time to update something!"
         content.sound = UNNotificationSound.default
         
         // Create a date component representing the current date and time
         var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
         
         // Add seven days to the current date and time
         dateComponents.day! += 7
         
         // Create a trigger that repeats every seven days
         let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
         
         // Create a notification request
         let request = UNNotificationRequest(identifier: "updateReminder", content: content, trigger: trigger)
         
         // Schedule the notification
         UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
     }
     
     func applicationDidEnterBackground(_ application: UIApplication) {
         // Save the current date to UserDefaults when the app enters the background
         UserDefaults.standard.set(Date(), forKey: lastUpdateDateKey)
     }

     func applicationWillEnterForeground(_ application: UIApplication) {
         // Check if it's been more than seven days since the last update
         if let lastUpdateDate = UserDefaults.standard.object(forKey: lastUpdateDateKey) as? Date {
             let currentDate = Date()
             let timeInterval = currentDate.timeIntervalSince(lastUpdateDate)
             
             if timeInterval >= 7 * 24 * 60 * 60 {
                 // Perform the update here
                 // For example, update a UserDefaults value:
                 UserDefaults.standard.set("NewValue", forKey: "YourValueKey")
                 
                 // Update the last update date
                 UserDefaults.standard.set(currentDate, forKey: lastUpdateDateKey)
                 
                 // Synchronize UserDefaults to save changes
                 UserDefaults.standard.synchronize()
                 
                 // Schedule the next local notification
                 scheduleLocalNotification()
             }
         }
     }
 }

 
 
 */
