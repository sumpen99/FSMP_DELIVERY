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

class AppDelegate: NSObject,UIApplicationDelegate{
    
    static private(set) var instance: AppDelegate! = nil
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppDelegate.instance = self
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        
        UNUserNotificationCenter.current().delegate = self
        
        //askForPushNotificationPermission()
        
        application.registerForRemoteNotifications()
        
         return true
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error){
        print(error.localizedDescription)
    }
    
    func askForPushPermission(){
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        UNUserNotificationCenter.current().requestAuthorization(
          options: authOptions) { _, _ in }
    }
   
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
        func application(_ application: UIApplication,didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data){
            Messaging.messaging().apnsToken = deviceToken
        }
    
        func application(_ application: UIApplication,
                         didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                         fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
         }
    
        func userNotificationCenter(_ center: UNUserNotificationCenter,
                                      willPresent notification: UNNotification,
                                      withCompletionHandler completionHandler:@escaping (UNNotificationPresentationOptions) -> Void) {
            // when app is active
            completionHandler([[.banner, .sound]])
        }

       func userNotificationCenter(_ center: UNUserNotificationCenter,
                                 didReceive response: UNNotificationResponse,
                                 withCompletionHandler completionHandler: @escaping () -> Void) {
           // when message is tapped
           completionHandler()
       }
    
    /*private func process(_ notification: UNNotification) {
          let userInfo = notification.request.content.userInfo
          UIApplication.shared.applicationIconBadgeNumber = 0
        
        if let newsTitle = userInfo["newsTitle"] as? String,
            let newsBody = userInfo["newsBody"] as? String {
            let newsItem = NewsItem(title: newsTitle, body: newsBody, date: Date())
            NewsModel.shared.add([newsItem])
          }
    }*/
  
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
