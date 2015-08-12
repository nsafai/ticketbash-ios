//
//  AppDelegate.swift
//  TicketBash
//
//  Created by Nicolai Safai on 7/27/15.
//  Copyright (c) 2015 Lime. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Parse
import ParseUI
import FBSDKLoginKit
import ParseFacebookUtils
import RealmSwift
import Stripe



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let StripePublishableKey = "pk_test_NPRQHdM6jMvSoWV0D74zEdIE"
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
       
        UINavigationBar.appearance().barTintColor = paletteDarkBlue
        UINavigationBar.appearance().tintColor = paletteWhite
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: paletteWhite]
        UINavigationBar.appearance().translucent = false
        
        UIToolbar.appearance().barTintColor = paletteDarkBlue
        UIToolbar.appearance().tintColor = paletteWhite
        UIToolbar.appearance().translucent = false

        
        Stripe.setDefaultPublishableKey(StripePublishableKey)

        Parse.setApplicationId("XGBNSjq1RRCVmAiiX1QRVbcbqik1wJo41uUAomIu", clientKey: "YpZD16HyM0cq0w2sblzad4ecstKGjo5JAtp9IJ8C")
        
        let acl = PFACL()
        acl.setPublicReadAccess(true)
        PFACL.setDefaultACL(acl, withAccessForCurrentUser: true)
        
        // 1
        PFFacebookUtils.initializeFacebook()
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

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

    //MARK: Facebook Integration
    
    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }

    

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

