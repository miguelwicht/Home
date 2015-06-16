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
//    var dataManager = OHDataManager()
//    var restManager = OHRestManager()
    var beaconManager: OHBeaconManager?
    var statusBarBackgroundView: OHStatusBarView?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        registerDefaults()
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        setupAppearance()
        loadData()
//        dataManager.loadLocalSitemaps()
        
        prepareViewController()
        
//        var settingsVC = OHSettingsViewController()
//        
//        
//        self.window?.rootViewController = settingsVC
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func loadData()
    {
        OHDataManager.sharedInstance.loadData()
    }
    
    func prepareViewController()
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        var frontViewController: UIViewController?
        
//        if var sitemaps = OHDataManager.sharedInstance.sitemaps {
//            if sitemaps.count > 0 {
//                frontViewController = OHRootViewController.new()
//            }
//        }
        
        if var sitemap = OHDataManager.sharedInstance.currentSitemap {
            if sitemap.roomsInSitemap() == nil {
                frontViewController = OHSettingsViewController.new()
            } else {
                frontViewController = OHRootViewController.new()
            }
        }
        
        if frontViewController == nil {
            frontViewController = OHSettingsViewController.new()
        }
        
        
        var rearViewController = OHRearMenuViewController.new()
        var containerViewController = SWRevealViewController(rearViewController: rearViewController, frontViewController: frontViewController)
        containerViewController.rearViewRevealOverdraw = 0
        containerViewController.rearViewRevealWidth = self.window!.frame.width - CGFloat(60)
        rearViewController.view.setWidth(containerViewController.rearViewRevealWidth)
        
        self.window?.rootViewController = containerViewController
        
        if var statusBarBackgroundView = self.statusBarBackgroundView {
            containerViewController.view.addSubview(statusBarBackgroundView)
        }
    }
    
    func setupAppearance()
    {
//        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        statusBarBackgroundView = OHStatusBarView(frame: CGRect(x: 0, y: 0, width: self.window!.frame.width, height: 20))
//        statusBarBackgroundView!.backgroundColor = OHDefaults.defaultNavigationBarColor()
        
        var font = UIFont(name: "Muli", size: UIFont.systemFontSize())
        UILabel.appearance().font = font
        
        UINavigationBar.appearance().barTintColor = OHDefaults.defaultNavigationBarColor()
        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().tintColor = UIColor(red: (51.0 / 255.0), green: (51.0 / 255.0), blue: (51.0 / 255.0), alpha: 1.0)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [ NSFontAttributeName: UIFont(name: font!.fontName, size: 17.0)!, NSForegroundColorAttributeName: UIColor.whiteColor() ]
        
        UIButton.appearance().setTitleColor(OHDefaults.defaultTextColor(), forState: .Normal)
    }
    
    func registerDefaults()
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let path = NSBundle.mainBundle().pathForResource("Defaults", ofType: "plist") {
            if let defaultsDict = NSDictionary(contentsOfFile: path) as? Dictionary<String, AnyObject> {
                // use swift dictionary as normal
                defaults.registerDefaults(defaultsDict)
                defaults.synchronize()
            }
        }
        
        
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        OHDataManager.sharedInstance.saveData()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        beaconManager?.startRanging()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        OHDataManager.sharedInstance.saveData()
    }


}
