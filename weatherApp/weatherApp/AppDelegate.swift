//
//  AppDelegate.swift
//  weatherApp
//
//  Created by Yogesh lakhani on 3/4/25.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // ✅ Set UNUserNotificationCenter delegate to handle notifications when app is open
        UNUserNotificationCenter.current().delegate = self
        
        NotificationManager.shared.requestPermission()

        // ✅ Request notification permission
        NotificationManager.shared.requestPermission()
        
        return true
    }

    // ✅ Handle foreground notifications
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("📢 Received Notification while in foreground: \(notification.request.content.title)")
        completionHandler([.banner, .sound])
    }

    // ✅ Handle background notification tap action
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("📩 Notification clicked: \(response.notification.request.content.title)")
        completionHandler()
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) { }
}
