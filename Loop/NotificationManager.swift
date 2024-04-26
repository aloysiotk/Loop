//
//  NotificationManager.swift
//  Loop
//
//  Created by Aloysio Tiscoski on 4/21/24.
//

import Foundation
import UserNotifications
import UIKit

@Observable
class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    let notificationCenter: UNUserNotificationCenter
    private var pendingNotifications = [UNNotificationRequest]()
    
    init(notificationCenter: UNUserNotificationCenter = UNUserNotificationCenter.current()) {
        self.notificationCenter = notificationCenter
        super.init()
        
        self.notificationCenter.delegate = self
        updatePendingNotifications()
    }
    
    func updatePendingNotifications() {
        notificationCenter.getPendingNotificationRequests(completionHandler: {n in self.updatePendingNotifications(notifications: n)})
    }
    
    private func updatePendingNotifications(notifications: [UNNotificationRequest]) {
        pendingNotifications = notifications
    }
    
    
    private func getAuthorizationStatus() async -> UNAuthorizationStatus {
        let settings = await notificationCenter.notificationSettings()
        return settings.authorizationStatus
    }
    
    func requestAuthorizationIfNeeded() async -> (()-> Void)? {
        async let authorizationStatus = getAuthorizationStatus()
        
        switch await authorizationStatus {
        case .notDetermined:
            requestAuthorization()
            return nil
        case .denied:
            return openSystemSettings
        default:
            return nil
        }
    }
    
    private func requestAuthorization() {
       notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("User authorized send notifications")
            } else if let error {
                print(error.localizedDescription)
            }
        }
    }
    
    private func openSystemSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }
    }
    
    func scheduleNotification(id: UUID, title: String, subtitle: String? = nil, body: String? = nil, startingAt date: Date, repeats: Bool = false) {
        let content = UNMutableNotificationContent(id: id, title: title, subtitle: subtitle, body: body, badge: 1)

        let interval = date.timeIntervalSince(Date.now)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: repeats)
       
        addRequest(withId: id, content: content, andTrigger: trigger)
    }
    
    func scheduleNotification(id: UUID, title: String, subtitle: String? = nil, body: String? = nil, dateComponents: DateComponents, repeats: Bool = false) {
        let content = UNMutableNotificationContent(id: id, title: title, subtitle: subtitle, body: body, badge: 1)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: repeats)
       
        addRequest(withId: id, content: content, andTrigger: trigger)
    }
    
    private func addRequest(withId id: UUID, content: UNNotificationContent, andTrigger trigger: UNNotificationTrigger) {
        let request = UNNotificationRequest(identifier: id.uuidString, content: content, trigger: trigger)
        notificationCenter.add(request)
        updatePendingNotifications()
    }
    
    
    func removeNotification(withIdentifier id: String) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [id])
        updatePendingNotifications()
    }
    
    //MARK: UNUserNotificationCenterDelegate
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("didReceiveresponse")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .banner, .badge])
        print("willPresentnotification")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        print("openSettingsFor")
    }
}

extension UNMutableNotificationContent {
    public convenience init(id: UUID, title: String, subtitle: String? = nil, body: String? = nil, badge: NSNumber? = nil, sound: UNNotificationSound = UNNotificationSound.default) {
        self.init()
        self.title = title
        self.subtitle = subtitle ?? ""
        self.body = body ?? ""
        self.badge = badge
        self.sound = sound
    }
}
