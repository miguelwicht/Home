
//  OHDataManager.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 06/05/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import Foundation

class OHDataManager: NSObject {
    
    dynamic var sitemaps: [String: OHSitemap]?
//    {
//        didSet {
//            NSNotificationCenter.defaultCenter().postNotificationName("OHDataManagerDidSetSitemapsNotification", object: self, userInfo: ["sitemaps":sitemaps!])
//        }
//    }
    var beacons: [OHBeacon]?
    var beaconWidget: [OHBeacon: OHWidget]?
    var items = [String: OHItem]()
    
    dynamic var currentSitemap: OHSitemap?
    
    private let restManager: OHRestManager
    
    class var sharedInstance: OHDataManager
    {
        struct Singleton
        {
            static let instance = OHDataManager()
        }
        
        return Singleton.instance
    }
    
    override init()
    {
        restManager = OHRestManager(baseUrl:"http://192.168.0.251:8888")
        super.init()
        
        restManager.delegate = self
    }
    
    
    func loadLocalSitemaps()
    {
        if var path = S3FileManager.applicationDocumentsDirectory().path?.stringByAppendingPathComponent("sitemaps/") {
            
            if var localSitemaps = S3FileManager.filesAtPath(path) {
                if localSitemaps.count > 0 {
                    
                    sitemaps = [String: OHSitemap]()
                    
                    for(index, sitemapName) in enumerate(localSitemaps) {
                        //                    var sitemap: OHSitemap?
                        var sitemapPath = path.stringByAppendingPathComponent(sitemapName as! String)
                        var data = NSData(contentsOfFile: sitemapPath)
                        let json = JSON(data: data!)
                        var sitemap = OHSitemap(sitemap: json)
                        sitemaps![sitemap.name] = sitemap
                    }
                    
                    updateItemsFromSitemaps()
                }
            }
            
            
        }
    }
    
    func updateSitemapsFromServer()
    {
        restManager.getSitemaps()
    }
    
    func getContentForSitemap(sitemap: OHSitemap) {
        restManager.getSitemap(sitemap.name)
    }
    
    func updateSitemaps(sitemaps: [OHSitemap])
    {
        
    }
    
    func updateItemsFromSitemaps()
    {
        if var sitemaps = self.sitemaps {
            
            for (key, sitemap) in sitemaps {
                if var homepage = sitemap.homepage {
                    var homepageItems = homepage.getItems()
                    
                    for (index, item) in homepageItems {
                        items[item.link] = item
                    }
                }
            }
        }
        
    }
    
//    func initOrUpdateSitemapsAndBeacons(sitemaps:[OHSitemap]){
//    
//        if var sitemapsArray = self.sitemaps {
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
//    }
    
    
    func parseBeaconsFromSitemap(sitemap: OHSitemap)
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        beaconWidget = OHRestParser.getBeaconsForRoomsFromSitemap(sitemap)
        
        if appDelegate.beaconManager == nil {
            var beacons = [OHBeacon]()
        
            for(beacon, widget) in beaconWidget! {
                beacons.append(beacon)
            }
        
            self.beacons = beacons
            appDelegate.beaconManager = OHBeaconManager(beacons: self.beacons!)
        }
    }
    
    func saveData()
    {
        var path: NSString = S3FileManager.applicationDocumentsDirectory().path!.stringByAppendingPathComponent("sitemapsData") as NSString
        NSKeyedArchiver.archiveRootObject(sitemaps!, toFile: path as String)
    }
    
    func loadData()
    {
        var path: NSString = S3FileManager.applicationDocumentsDirectory().path!.stringByAppendingPathComponent("sitemapsData") as NSString
        if var sitemaps = NSKeyedUnarchiver.unarchiveObjectWithFile(path as String) as? [String: OHSitemap] {
            self.sitemaps = sitemaps
            
        } else {
            print("could not load data")
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

extension OHDataManager: OHRestManagerDelegate {
    
    func didGetSitemaps(sitemaps: [OHSitemap])
    {
        var sitemapsDict = [String: OHSitemap]()
        
        for (index, sitemap) in enumerate(sitemaps)
        {
            sitemapsDict[sitemap.name] = sitemap
        }
        
//        self.sitemaps! = sitemapsDict
        
        
        if var sitemapsUnwrapped = self.sitemaps {
            self.sitemaps! = sitemapsDict
        } else {
            self.sitemaps = sitemapsDict
        }
        
//        NSNotificationCenter.defaultCenter().postNotificationName("OHDataManagerDidSetSitemapsNotification", object: self, userInfo: ["sitemaps":sitemaps])
//        self.sitemaps! = sitemaps
//        self.setValue(sitemaps, forKeyPath: "sitemaps")
    }
    
    func didGetSitemap(sitemap: OHSitemap) {
        
        if var sitemapsUnwrapped = self.sitemaps {
            
            self.sitemaps![sitemap.name] = sitemap
            
        } else {
            self.sitemaps = [sitemap.name: sitemap]
        }
        saveData()
        loadData()
        updateItemsFromSitemaps()
        parseBeaconsFromSitemap(sitemap)
        
    }
}