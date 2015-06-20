
//  OHDataManager.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 06/05/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import Foundation

class OHDataManager: NSObject {
    
    var sitemaps: [String: OHSitemap]?
    {
        didSet {
            NSNotificationCenter.defaultCenter().postNotificationName("OHDataManagerDidUpdateSitemapsNotification", object: self, userInfo: nil)
        }
    }
    
    var currentSitemap: OHSitemap? {
        didSet {
            NSNotificationCenter.defaultCenter().postNotificationName("OHDataManagerCurrentSitemapDidChangeNotification", object: self, userInfo: nil)
//            saveCurrentSitemap()
            parseBeaconsFromSitemap(currentSitemap!)
        }
    }
    
    var beacons: [OHBeacon]?
    var beaconWidget: [OHBeacon: OHWidget]?
    var items = [String: OHItem]()
    
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
        restManager = OHRestManager(baseUrl:"http://10.10.32.251:8888")
//        restManager = OHRestManager(baseUrl:"http://192.168.0.251:8888")
        super.init()
        
        restManager.delegate = self
    }
    
    func downloadSitemaps()
    {
        restManager.getListOfSitemaps()
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
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

//Mark: Persistence
extension OHDataManager {
    
    func saveData()
    {
        var path: NSString = S3FileManager.applicationDocumentsDirectory().path!.stringByAppendingPathComponent("sitemapsData") as NSString
        
        if var sitemaps = self.sitemaps {
            NSKeyedArchiver.archiveRootObject(sitemaps, toFile: path as String)
        } else {
            println("No Sitemaps to save")
        }
        
        if var currentSitemap = self.currentSitemap
        {
            var currentSitemapPath: NSString = S3FileManager.applicationDocumentsDirectory().path!.stringByAppendingPathComponent("currentSitemapData") as NSString
            NSKeyedArchiver.archiveRootObject(currentSitemap, toFile: currentSitemapPath as String)
        }
    }
    
    func saveCurrentSitemap(){
        if var currentSitemap = self.currentSitemap
        {
            var currentSitemapPath: NSString = S3FileManager.applicationDocumentsDirectory().path!.stringByAppendingPathComponent("currentSitemapData") as NSString
            NSKeyedArchiver.archiveRootObject(currentSitemap, toFile: currentSitemapPath as String)
        }
    }
    
    func loadData()
    {
        if var sitemaps = loadSitemapsData() {
            self.sitemaps = sitemaps
        }
        
        if var currentSitemap = loadCurrentSitemapData()
        {
            self.currentSitemap = currentSitemap
        }
    }
    
    func loadSitemapsData() -> [String: OHSitemap]?
    {
        var sitemaps: [String: OHSitemap]?
        
        var path: NSString = S3FileManager.applicationDocumentsDirectory().path!.stringByAppendingPathComponent("sitemapsData") as NSString
        if var sitemapsFromDisc = NSKeyedUnarchiver.unarchiveObjectWithFile(path as String) as? [String: OHSitemap] {
            sitemaps = sitemapsFromDisc
        } else {
            print("could not load data")
        }
        
        return sitemaps
    }
    
    func loadCurrentSitemapData() -> OHSitemap?
    {
        var sitemap: OHSitemap?
        
        var path: NSString = S3FileManager.applicationDocumentsDirectory().path!.stringByAppendingPathComponent("currentSitemapData") as NSString
        
        if var currentSitemapFromDisc = NSKeyedUnarchiver.unarchiveObjectWithFile(path as String) as? OHSitemap {
            sitemap = currentSitemapFromDisc
            
        } else {
            print("could not load current Sitemap data")
        }
        
        return sitemap
    }
}

extension OHDataManager {
    
    func updateBaseUrl(url: String) {
        restManager.baseUrl = url
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
        
        self.sitemaps = sitemapsDict
        
        saveData()
    }
    
    func didGetListOfSitemaps(sitemaps: [OHSitemap]) {
        restManager.getMultipleSitemaps(sitemaps)
    }

}