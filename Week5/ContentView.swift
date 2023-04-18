//
//  ContentView.swift
//  Week5
//
//  Created by Poter Pan on 2023/4/17.
//

import SwiftUI
import UserNotifications

class NotificationManager {
    
    static let instance = NotificationManager()  // Singleton
    
    func requestAuthrization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            if let error = error {     // 新版可寫成 if let error
                print("ERROR: \(error.localizedDescription)")
            } else {
                print("Permision request SUCCESS")
            }
        }
    }
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "通知推播"
        content.subtitle = "就是內容"
        content.sound = .default
        content.badge = 1
        
        // time interval
        let trigger1 = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        // calendar
        var dateComponents = DateComponents()
        dateComponents.hour = 9
        dateComponents.minute = 20
        let trigger2 = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        // location
        
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger2)
        
        UNUserNotificationCenter.current().add(request)
        
    }
    
    func cancelNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
}

struct ContentView: View {
    var body: some View {
        VStack {
            Button {
                NotificationManager.instance.requestAuthrization()
            } label: {
                Text("Request Premission")
            }
            
            Button {
                NotificationManager.instance.scheduleNotification()
            } label: {
                Text("Schedule Notification")
            }
            
            Button {
                NotificationManager.instance.cancelNotification()
            } label: {
                Text("Cancel Notification")
            }

        }
        .onAppear {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
