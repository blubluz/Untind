//
//  PushNotificationManager.swift
//  Untind
//
//  Created by Mihai Honceriu on 30/03/2020.
//  Copyright © 2020 FincPicsels. All rights reserved.
//

import UIKit
import Firebase

class PushNotificationManager: NSObject {
    static var shared = PushNotificationManager()
    var currentFcmToken : String?
    
    func syncToken() {
        if let loggedUserProfile = UTUser.loggedUser?.userProfile, let token = currentFcmToken {
            let db = Firestore.firestore()
            db.collection("NotificationTokens").document(loggedUserProfile.uid).setData([
                "fcmToken" : token])
        }
    }
    
    func deleteToken(){
        if let loggedUserProfile = UTUser.loggedUser?.userProfile {
            let db = Firestore.firestore()
            db.collection("NotificationTokens").document(loggedUserProfile.uid).delete()
        }
    }
    
    func registerforRemoteNotifications() {
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
            UIApplication.shared.registerUserNotificationSettings(settings)
        }

        UIApplication.shared.registerForRemoteNotifications()
    }
    
    override init() {
        super.init()
    }
}

extension PushNotificationManager : UNUserNotificationCenterDelegate {
    
}
