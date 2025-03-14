//
//  NotificationManager.swift
//  weatherApp
//
//  Created by Yogesh lakhani on 3/4/25.
import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()

    private init() {}

    // ✅ Request permission for push notifications
    func requestPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("✅ Notification permission granted.")
            } else {
                print("❌ Notification permission denied.")
            }
        }
    }

    // ✅ Function to schedule push notifications
    func scheduleNotification(title: String, body: String, timeInterval: TimeInterval = 2) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Failed to schedule notification: \(error)")
            } else {
                print("✅ Notification scheduled: \(title)")
            }
        }
    }
    
    func sendNotification(title: String, message: String) {
          let content = UNMutableNotificationContent()
          content.title = title
          content.body = message
          content.sound = .default

          let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
          let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

          UNUserNotificationCenter.current().add(request) { error in
              if let error = error {
                  print("❌ Failed to send notification: \(error.localizedDescription)")
              } else {
                  print("✅ Notification scheduled: \(title)")
              }
          }
      }
}
