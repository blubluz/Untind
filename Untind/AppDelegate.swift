//
//  AppDelegate.swift
//  Untind
//
//  Created by Honceriu Mihai on 27/07/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import SVProgressHUD

@UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        FirebaseApp.configure()
        SVProgressHUD.setForegroundColor(UIColor.flatOrange)
        SVProgressHUD.setBackgroundColor(UIColor(red: 255, green: 255, blue: 255, alpha: 0.4))
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }


}

