//
//  LocalNotificationService.swift
//  PokeApp
//
//  Created by Кирилл Романенко on 02.04.2021.
//

import Foundation
import UserNotifications

class LocalNotificationService: NSObject {
    let notificationCenter = UNUserNotificationCenter.current()
    
    func notificationRequest() {
        notificationCenter.delegate = self
        let options: UNAuthorizationOptions = [.alert, .sound]
        
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }
    }
    
    func scheduleNotification(pokemon: Pokemon, urlImage: URL) {
        let content = UNMutableNotificationContent() // Содержимое уведомления
        content.title = "Новый покемон!"
        content.body = "По имени \(pokemon.species!.name!)"
        if let attachment = try? UNNotificationAttachment(identifier: "image", url: urlImage, options: nil) {
            content.attachments.append(attachment)
        }
        
        let date = Date(timeIntervalSinceNow: 1)
        let dateComponents = Calendar.current.dateComponents([.second], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let identifier = UUID().uuidString
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }
    
    func getListOfNotifications() {
        notificationCenter.getDeliveredNotifications { notifications in
            print("DeliveredNotifications \(notifications)")
        }
        
        notificationCenter.getPendingNotificationRequests { notifications in
            print("PendingNotifications \(notifications)")
        }
    }
    
    func removeIdentifier(_ id: String) {
        notificationCenter.removeDeliveredNotifications(withIdentifiers: [id])
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [id])
    }
}

extension LocalNotificationService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.identifier == "Local Notification" {
            print("Handling notifications with the Local Notification Identifier")
        }
        
        completionHandler()
    }
}
