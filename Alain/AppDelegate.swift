//
//  AppDelegate.swift
//  Alain
//
//  Created by MicroExcel on 5/18/20.
//  Copyright © 2020 Microexcel. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import UserNotifications
import Firebase
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
         //PushNotification
               FirebaseApp.configure()
               Messaging.messaging().isAutoInitEnabled = true
               // [START set_messaging_delegate]
               Messaging.messaging().delegate = self
               // [START register_for_notifications]
               if #available(iOS 10.0, *) {
                   // For iOS 10 display notification (sent via APNS)
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

        IQKeyboardManager.shared.enable = true
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
            if error != nil {
                print("Request authorization failed!")
            } else {
                print("Request authorization succeeded!")
//                self.showAlert()
            }
        }
//        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate

        let loginDetailsDefaults = UserDefaults.standard
       if let data = loginDetailsDefaults.object(forKey: "Token") as? String
       {
        if data != ""
        {
            let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let nav = mainStoryboardIpad.instantiateViewController(withIdentifier: "DashBoardNavigation")as? UINavigationController
            self.window?.rootViewController = nav
        }else{
            let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let nav = mainStoryboardIpad.instantiateViewController(withIdentifier: "LoginNavigation")as? UINavigationController
            self.window?.rootViewController = nav
        }
       }else{
           let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
           let nav = mainStoryboardIpad.instantiateViewController(withIdentifier: "LoginNavigation")as? UINavigationController
           self.window?.rootViewController = nav
       }

        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
            // If you are receiving a notification message while your app is in the background,
            // this callback will not be fired till the user taps on the notification launching the application.
            // TODO: Handle data of notification
            // With swizzling disabled you must let Messaging know about the message, for Analytics
            // Messaging.messaging().appDidReceiveMessage(userInfo)
            // Print message ID.
            if let messageID = data[gcmMessageIDKey] {
                print("Message ID: \(messageID)")
            }
            
            
            // Print full message.
            print(data)
            Messaging.messaging().appDidReceiveMessage(data)
            
            
        }
        func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
            // Print message id
            if let messageId = userInfo[gcmMessageIDKey] {
                print("Message Id: \(messageId)")
            }
            // Print full message.
            print(userInfo)
    //        let strTitle = (userInfo["aps"] as! NSDictionary)
    //        let alert = strTitle.object(forKey: "alert") as! NSDictionary
    //        print(alert)
            //        let alertMsg = userInfo["alert"]as? NSDictionary
            //        print(alertMsg!)
            Messaging.messaging().appDidReceiveMessage(userInfo)
            
            completionHandler(UIBackgroundFetchResult.newData)
        }
    internal
        // [END receive_message]
        func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
            print("Unable to register for remote notifications: \(error.localizedDescription)")
        }
        func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            print("APNs token retrieved: \(deviceToken)")
            
            Messaging.messaging().apnsToken = deviceToken
            Messaging.messaging().setAPNSToken(deviceToken, type: MessagingAPNSTokenType.sandbox)
            Messaging.messaging().setAPNSToken(deviceToken, type: MessagingAPNSTokenType.prod)
            
            // With swizzling disabled you must set the APNs token here.
            // Messaging.messaging().apnsToken = deviceToken
        }
        func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
            // 1
            // let aps = userInfo["aps"] as! [String: AnyObject]
            
            // 2
            
        }
        
        func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
            // 1
            // let aps = userInfo["aps"] as! [String: AnyObject]
            
            // 2
            
        }

    
    
//    // MARK: UISceneSession Lifecycle
//    @available(iOS 13.0, *)
//
//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//    @available(iOS 13.0, *)
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Covid_19")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        //ForeGroundTime
        // Print full message.
        print(userInfo)
        
        let strTitle = (userInfo["aps"] as! NSDictionary)
        let alert = strTitle.object(forKey: "alert") as! NSDictionary
        print(alert)
        
        // Change this to your preferred presentation option
        completionHandler([.alert, .badge, .sound])
        
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }

        //NotificationClickTime
        print(userInfo)
        if(UserDefaults.standard.object(forKey: "UserName") == nil)
        {
            let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let nav = mainStoryboardIpad.instantiateViewController(withIdentifier: "Flash")as? UINavigationController
            self.window?.rootViewController = nav
        }else{
            let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let nav = mainStoryboardIpad.instantiateViewController(withIdentifier: "Alert")as? UINavigationController
            self.window?.rootViewController = nav
        }

        completionHandler()
    }
    
    
}
// [END ios_10_message_handling]
extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?)
    {
        print("Firebase registration token: \(String(describing: fcmToken))")
        let KUserDefault = UserDefaults.standard
        KUserDefault.set(fcmToken, forKey: "FCMToken")
        KUserDefault.synchronize()
        
        let dataDict:[String: String] = ["token": fcmToken!]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
  
    // [END refresh_token]
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
//    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
//        print("Received data message: \(remoteMessage.appData)")
//    }
    // [END ios_10_data_message]
}
