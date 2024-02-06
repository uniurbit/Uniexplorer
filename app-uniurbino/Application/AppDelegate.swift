//
//  AppDelegate.swift
//  app-uniurbino
//
//  Created by Lorenzo on 17/01/23.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if let launchOptionsElems = launchOptions, let locationElem = launchOptionsElems[UIApplication.LaunchOptionsKey.location] {
            Logger.log.info("\(#function) locationElem \(locationElem)")
        }
        FirebaseApp.configure()
        Messaging.messaging().isAutoInitEnabled = true
        registerNotification(application: application)
        customAppearance()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
    

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping(UIBackgroundFetchResult) -> Void) {
        //Entro quando ricevo una notifica silenziosa da firebase
        print(userInfo)
        Logger.log.info("Ricevuta notifica da firebase")
        NotificationCenter.default.post(name: .receive_fcm_notification, object: nil, userInfo: userInfo)
        let aps = userInfo["aps"] as? NSDictionary
        if let aps = aps {
            let alert = aps["alert"] as! NSDictionary
            let title = alert["body"] as! String
            if title.lowercased() == "calendar update"{
                getCalendar()
            }
        }
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func registerNotification(application: UIApplication){
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert, .badge],completionHandler: {granted, _ in
            guard granted else { return }
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        })
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        if UserSettingsManager.sharedInstance.backgroundScanSetting {
            PushNotificationSender.sendPushNotification(title: "L'applicazione è stata chiusa", body: "Riaprila per continuare a rilevare le aule")
            sleep(3)
        }
    }
    
}
extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate{
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Logger.log.info("APNs token retrieved: \(deviceToken)")
        Messaging.messaging().apnsToken = deviceToken
        Messaging.messaging().subscribe(toTopic: "calendar"){ error in
            if error == nil{
                print("Subscribed to topic")
            }
            else{
                print("Not Subscribed to topic")
            }
        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        Logger.log.info("Firebase registration token: \(fcmToken ?? "")")
        UserSettingsManager.sharedInstance.pushIdentifierString = fcmToken
    }
    
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification) async-> UNNotificationPresentationOptions {
        //Per ora non serve ma lo lasciamo
        return []
    }
    
    //CLICK DELLA NOTIFICA
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        //Per ora non serve ma lo lasciamo
        
        completionHandler()
    }
    
    
    private func getCalendar(){
        guard let user = UserSettingsManager.sharedInstance.getSavedUser(), (user.isUniurbUser ?? false) else {return}
        UserService.getCalendar(completion: { result in
            UserSettingsManager.sharedInstance.saveCalendar(calendar: result)
            Logger.log.info("getCalendar OK")
        }, completionError: {_ in
            Logger.log.error("getCalendar error")
        })
    }
    
}




extension String {
    func stringTodictionary() -> [String:Any]? {
        var dictonary:[String:Any]?
        if let data = self.data(using: .utf8) {
            do {
                dictonary = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                if let myDictionary = dictonary
                {
                    return myDictionary;
                }
            } catch let error as NSError {
                print(error)
            }
        }
        return dictonary;
    }
}

