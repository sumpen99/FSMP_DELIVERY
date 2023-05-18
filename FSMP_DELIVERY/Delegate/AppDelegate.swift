//
//  AppDelegate.swift
//  FSMP_DELIVERY
//
//  Created by fredrik sundström on 2023-05-18.
//

import SwiftUI
import Firebase
import FirebaseMessaging

/*
 private func subscribe(to topic: String) {
   // 1
   Messaging.messaging().subscribe(toTopic: topic)
 }

 private func unsubscribe(from topic: String) {
   // 2.
   Messaging.messaging().unsubscribe(fromTopic: topic)
 }
 
 */

class AppDelegate: NSObject, UIApplicationDelegate{
 
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        self.registerForFirebaseNotification(application: application)
        
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
          options: authOptions) { _, _ in }
        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self
        return true
    }
   
    func registerForFirebaseNotification(application: UIApplication) {
        if #available(iOS 10.0, *) {
         
            UNUserNotificationCenter.current().delegate = self

            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
        func application(_ application: UIApplication,didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data){
            Messaging.messaging().apnsToken = deviceToken
        }
    
        func application(_ application: UIApplication,
                         didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                         fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
            print("APNs received with: \(userInfo)")
        }
    
        private func process(_ notification: UNNotification) {
            
              let userInfo = notification.request.content.userInfo
              UIApplication.shared.applicationIconBadgeNumber = 0
            
            if let newsTitle = userInfo["newsTitle"] as? String,
                let newsBody = userInfo["newsBody"] as? String {
                let newsItem = NewsItem(title: newsTitle, body: newsBody, date: Date())
                NewsModel.shared.add([newsItem])
              }
        }

        func userNotificationCenter(_ center: UNUserNotificationCenter,
                                      willPresent notification: UNNotification,
                                      withCompletionHandler completionHandler:@escaping (UNNotificationPresentationOptions) -> Void) {
            
            process(notification)
            completionHandler([[.banner, .sound]])
        }

       func userNotificationCenter(_ center: UNUserNotificationCenter,
                                 didReceive response: UNNotificationResponse,
                                 withCompletionHandler completionHandler: @escaping () -> Void) {
           
           process(response.notification)
           completionHandler()
       }
  
}

extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        let tokenDict = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: tokenDict)
    }

}
