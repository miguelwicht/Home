//
//  AppDelegate.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 13/04/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var dataManager: OHDataManager?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        loadUserDefaults()
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        self.window?.rootViewController = OHRootViewController.new()
        self.window?.makeKeyAndVisible()
        
        return true
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

extension AppDelegate {
    
    func loadUserDefaults() {
//        let userDefaults = NSUserDefaults.standardUserDefaults()
//        
//        let defaults = NSUserDefaults.standardUserDefaults()
//        let settingsBundle = NSBundle.mainBundle().pathForResource("Root", ofType: "plist")
//        let settings = NSDictionary(contentsOfFile: settingsBundle!)
//        
//        println(settings)
        
//        let preferences = settings?.objectForKey("PreferenceSpecifiers") as! NSArray
//        
//        let defaultsToRegister = NSMutableDictionary(capacity: preferences.count)
//        
//        defaults.registerDefaults(defaultsToRegister as [NSObject : AnyObject])
//        
//        defaults.synchronize()
//        
//        println(defaults)
    }
    
//    func loadViewControllerForSitemap(sitemap: String) {
//        self.restManager!.getSitemap(sitemap)
//    }
//    
//    func initRestManager() {
//        let defaults = NSUserDefaults.standardUserDefaults()
//        
//        if let url = defaults.objectForKey("SettingsOpenHABURL") as? String {
//            self.restManager = OHRestManager(baseUrl: url)
//            println("URL: \(url)")
//        } else {
//            println("no url")
//        }
//        
//        if var restManager = self.restManager {
//            restManager.delegate = self
//        }
//    }
}

//extension AppDelegate: OHRestManagerDelegate {
//    
//    func didGetItems(items: [JSON]) {
//        println(items)
//    }
//    
//    func didGetBeacons(beacons: [OHBeacon]) {
//        println(beacons)
//    }
//    
//    func didGetSitemaps(sitemaps: [OHSitemap]) {
//        for (i, e) in enumerate(sitemaps)
//        {
//            self.restManager!.getSitemap(e.name)
//        }
//    }
//    
//    func didGetSitemap(sitemap: OHSitemap)
//    {
//        var homepage = sitemap.homepage!
//        
//        var widget: OHWidget?
//        
//        for (i, e) in enumerate(homepage.widgets!)
//        {
//            widget = e
//        }
//        
//        //        var widget: OHWidget = self.sitemaps[indexPath.row].homepage!.wi
//        
//        var widgets = widget!.widgets
//        
//        println("widgets to pass: \(widgets)")
//        
//        var vc: OHRoomViewController = OHRoomViewController(widgets: widgets!)
////        self.presentViewController(vc, animated: true, completion: nil)
//        self
//    }
//}

