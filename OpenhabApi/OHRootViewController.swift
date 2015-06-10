//
//  OHStartViewController.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 06/05/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import UIKit

class OHRootViewController: UINavigationController {
    
    var restManager: OHRestManager?
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
//        initSettings()
        initManagers()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?)
    {
        super.init(nibName: nil, bundle: nil)
        
        initManagers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        
//        let defaults = NSUserDefaults.standardUserDefaults()
//        
//        if var sitemapName = defaults.objectForKey("SettingsOpenHABSitemap") as? String {
//            if var sitemap = getLocalSitemap(sitemapName) {
//                didGetSitemap(sitemap)
//            }
//        }
//        
//        if !loadLocalSitemap() {
//            loadDefaultViewController()
//        }
        
        var sitemaps = OHDataManager.sharedInstance.sitemaps!
        var startIndex = sitemaps.startIndex
//        didGetSitemap()
        
        if var menuViewController = revealViewController().rearViewController as? OHRearMenuViewController {
            menuViewController.updateMenu()
        }

        pushViewControllerWithSitemap(sitemaps[startIndex].1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
}

extension OHRootViewController {
    
    func initSettings()
    {
        var settingsVC = OHSettingsViewController()
        self.presentViewController(settingsVC, animated: true, completion: nil)
    }
    
    func initManagers()
    {
//        loadLocalSitemap()
//        dataManager = OHDataManager()
//        restManager = OHRestManager(baseUrl: "http://192.168.0.251:8888")
//        restManager = OHRestManager(baseUrl: "http://10.10.32.251:8888")
//        
//        if var restManager = self.restManager {
//            restManager.delegate = self
//        }
        
        
    }
    
    func loadDefaultViewController()
    {
        let defaults = NSUserDefaults.standardUserDefaults()

        if let sitemap = defaults.objectForKey("SettingsOpenHABSitemap") as? String {
            self.restManager?.getSitemap(sitemap)
        } else {
            println("no sitemap")
        }
    }
    
    func getLocalSitemap(name: String) -> OHSitemap?
    {
        var sitemapName = "\(name).json"
        var sitemap: OHSitemap?
        if var path = S3FileManager.applicationDocumentsDirectory().path?.stringByAppendingPathComponent("sitemaps/") {
            path = path.stringByAppendingPathComponent(sitemapName)
            
            if (NSFileManager.defaultManager().fileExistsAtPath(path))
            {
                var data = NSData(contentsOfFile: path)
                let json = JSON(data: data!)
                sitemap = OHSitemap(sitemap: json)
            }
        }
        
        return sitemap
    }
    
    func loadLocalSitemap() -> Bool
    {
        var sitemap: OHSitemap
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if var sitemapName = defaults.objectForKey("SettingsOpenHABSitemap") as? String {
            sitemapName = sitemapName + ".json"
            
            if var path = S3FileManager.applicationDocumentsDirectory().path?.stringByAppendingPathComponent("sitemaps/") {
                path = path.stringByAppendingPathComponent(sitemapName)
                
                if (NSFileManager.defaultManager().fileExistsAtPath(path))
                {
                    var data = NSData(contentsOfFile: path)
                    let json = JSON(data: data!)
                    sitemap = OHSitemap(sitemap: json)
                    return true
                }
            }
        }
        
        return false
    }
    
    func pushViewControllerWithSitemap(sitemap: OHSitemap)
    {
        var homepage = sitemap.homepage!
        var widget: OHWidget?
        
        for (i, e) in enumerate(homepage.widgets!)
        {
            if e.label == "Rooms" {
                widget = e
            }
        }
        
        var widgets = widget!.widgets
        
        var vc: OHRoomsViewController = OHRoomsViewController(widgets: widgets!)
        vc.title = sitemap.label
        
        self.pushViewController(vc, animated: true)
    }
}

////MARK: OHRestManagerDelegate
//extension OHRootViewController: OHRestManagerDelegate
//{
//    func didGetItems(items: [JSON]) {
////        println(items)
//    }
//    
//    func didGetBeacons(beacons: [OHBeacon]) {
////        dataManager.beacons = beacons
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
//        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        var dataManager = appDelegate.dataManager
//        
//        if var sitemaps = dataManager.sitemaps {
//            sitemaps.append(sitemap)
//        } else {
//            dataManager.sitemaps = [OHSitemap]()
//            dataManager.sitemaps?.append(sitemap)
//            
//            dataManager.updateItemsFromSitemaps()
//            
//            dataManager.beaconWidget = OHRestParser.getBeaconsForRoomsFromSitemap(sitemap)
//            
//            if appDelegate.beaconManager == nil {
//                var beacons = [OHBeacon]()
//                
//                for(beacon, widget) in dataManager.beaconWidget! {
//                    beacons.append(beacon)
//                }
//                
//                appDelegate.dataManager.beacons = beacons
//                appDelegate.beaconManager = OHBeaconManager(beacons: dataManager.beacons!)
//            }
//            
//        }
//
//        
//        if var menuViewController = revealViewController().rearViewController as? OHRearMenuViewController {
//            menuViewController.updateMenu()
//        }
//        
//        
//        pushViewControllerWithSitemap(sitemap)
//    }
//    
//    func saveSitemap(sitemap: OHSitemap)
//    {
//        var path = S3FileManager.applicationDocumentsDirectory().path?.stringByAppendingPathComponent("sitemaps/\(sitemap.name).json")
//        
//    }
//    
//}

extension OHRootViewController {
    
    func initBeacons(sitemap: OHSitemap) {
        
    }
}
