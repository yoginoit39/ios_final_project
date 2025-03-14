//
//  NotificationManager.swift
//  weatherApp
//
//  Created by Yogesh lakhani on 3/13/25.
//

import Foundation
import UserNotifications

class AppNotificationManager {
    static let shared = AppNotificationManager()
    
    private init() {
        requestNotificationPermission()
    }

    // ✅ Request permission for notifications
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("✅ Notification permission granted.")
            } else {
                print("❌ Notification permission denied.")
            }
        }
    }

    // ✅ Schedule a local notification
    func scheduleNotification(title: String, body: String, timeInterval: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Failed to schedule notification: \(error)")
            } else {
                print("📢 Notification scheduled: \(title) - \(body)")
            }
        }
    }
}
