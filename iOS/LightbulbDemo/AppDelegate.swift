//
//  AppDelegate.swift
//  LightbulbDemo
//
//  Created by Chris Beauchamp on 3/28/16.
//  Copyright © 2016 Kii. All rights reserved.
//

import UIKit
import ThingIFSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        Kii.beginWithID("7acef728", andKey: "79446442d468a012151a6a57c3d72ff6", andSite: KiiSite.US)
        
        // Register APNS
        let settings = UIUserNotificationSettings(forTypes: UIUserNotificationType([.Alert, .Badge, .Sound]), categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {

        print("registered with token")
        
        do {
            let api = try ThingIFAPI.loadWithStoredInstance()!
            api.installPush(deviceToken, development: true, completionHandler: { (installationID: String?, error: ThingIFError?) -> Void in
                if error != nil {
                    // Error handling
                    print("push error", error)
                } else {
                    print("push installed")
                }
            })
        } catch ThingIFError.API_NOT_STORED {
            // The instance has not stored
            print("API not stored yet")
        } catch {
            // Error handling
            print("Unknown catch")
        }

    }
    
    func application(application: UIApplication!, didFailToRegisterForRemoteNotificationsWithError error: NSError!) {
        print("Failed to register notifications", error)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        print("got remote notification")
        print(userInfo)
        
        NSNotificationCenter.defaultCenter().postNotificationName("deviceUpdated", object: nil)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

