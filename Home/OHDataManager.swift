
//  OHDataManager.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 06/05/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import Foundation

class OHDataManager: NSObject {
    
    var sitemaps: [String: OHSitemap]? {
        didSet {
            NSNotificationCenter.defaultCenter().postNotificationName("OHDataManagerDidUpdateSitemapsNotification", object: self, userInfo: nil)
        }
    }
    
    var currentSitemap: OHSitemap? {
        didSet {
            NSNotificationCenter.defaultCenter().postNotificationName("OHDataManagerCurrentSitemapDidChangeNotification", object: self, userInfo: nil)
            parseBeaconsFromSitemap(currentSitemap!)
        }
    }
    
    var beacons: [OHBeacon]?
    var beaconWidget: [OHBeacon: OHWidget]?
    var items = [String: OHItem]()
    
    private let restManager: OHRestManager
    
    class var sharedInstance: OHDataManager {
        struct Singleton {
            static let instance = OHDataManager()
        }
        
        return Singleton.instance
    }
    
    override init() {
        restManager = OHRestManager(baseUrl:"http://raspberrypi:8080")
//        restManager = OHRestManager(baseUrl:"http://192.168.0.251:8888")
        super.init()
        
        restManager.delegate = self
    }
    
    func downloadSitemaps() {
        restManager.getListOfSitemaps()
    }
    
    func updateItemsFromSitemaps() {
        if let sitemaps = self.sitemaps {
            for (_, sitemap) in sitemaps {
                if let homepage = sitemap.homepage {
                    let homepageItems = homepage.getItems()
                    
                    for (_, item) in homepageItems {
                        items[item.link] = item
                    }
                }
            }
        }
    }
    
    func parseBeaconsFromSitemap(sitemap: OHSitemap) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        beaconWidget = OHRestParser.getBeaconsForRoomsFromSitemap(sitemap)
        
        if appDelegate.beaconManager == nil {
            var beacons = [OHBeacon]()
        
            for(beacon, _) in beaconWidget! {
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
    
    func saveData() {
        //let path: NSString = S3FileManager.applicationDocumentsDirectory().path!.stringByAppendingPathComponent("sitemapsData")
        let path: NSString = (S3FileManager.applicationDocumentsDirectory().path! as NSString).stringByAppendingPathComponent("sitemapsData")
        if let sitemaps = self.sitemaps {
            NSKeyedArchiver.archiveRootObject(sitemaps, toFile: path as String)
        } else {
            print("No Sitemaps to save")
        }
        
        if let currentSitemap = self.currentSitemap {
            let currentSitemapPath: NSString = (S3FileManager.applicationDocumentsDirectory().path! as NSString).stringByAppendingPathComponent("currentSitemapData") as NSString
            NSKeyedArchiver.archiveRootObject(currentSitemap, toFile: currentSitemapPath as String)
        }
    }
    
    func saveCurrentSitemap() {
        if let currentSitemap = self.currentSitemap {
            let currentSitemapPath: NSString = (S3FileManager.applicationDocumentsDirectory().path! as NSString).stringByAppendingPathComponent("currentSitemapData") as NSString
            NSKeyedArchiver.archiveRootObject(currentSitemap, toFile: currentSitemapPath as String)
        }
    }
    
    func loadData() {
        if let sitemaps = loadSitemapsData() {
            self.sitemaps = sitemaps
        }
        
        if let currentSitemap = loadCurrentSitemapData() {
            self.currentSitemap = currentSitemap
        }
    }
    
    func loadSitemapsData() -> [String: OHSitemap]? {
        
        getItemsWithTags()
        
        var sitemaps: [String: OHSitemap]?
        
        let path: NSString = (S3FileManager.applicationDocumentsDirectory().path! as NSString).stringByAppendingPathComponent("sitemapsData") as NSString
        if let sitemapsFromDisc = NSKeyedUnarchiver.unarchiveObjectWithFile(path as String) as? [String: OHSitemap] {
            sitemaps = sitemapsFromDisc
        } else {
            print("could not load data", appendNewline: false)
        }
        
        return sitemaps
    }
    
    func loadCurrentSitemapData() -> OHSitemap? {
        var sitemap: OHSitemap?
        let path: NSString = (S3FileManager.applicationDocumentsDirectory().path! as NSString).stringByAppendingPathComponent("currentSitemapData") as NSString
        
        if let currentSitemapFromDisc = NSKeyedUnarchiver.unarchiveObjectWithFile(path as String) as? OHSitemap {
            sitemap = currentSitemapFromDisc
        } else {
            print("could not load current Sitemap data", appendNewline: false)
        }
        
        return sitemap
    }
}

extension OHDataManager {
    
    func updateBaseUrl(url: String) {
        restManager.baseUrl = url
    }
    
    func getItemsWithTags() {
        let tags = [String](arrayLiteral: "OH_Beacon")
        restManager.getItemsWithTags(tags)
    }
    
    func getBeaconsFromItems(items: [OHItem]) -> [OHBeacon]? {
        var beacons = [OHBeacon]()
        
        for (_, item) in items.enumerate() {
            if let beaconItem = item.getBeaconFromTags() {
                beacons.append(beaconItem);
            }
        }
        
//        var beaconsToReturn:[OHBeacon]?
//        
//        if beacons.count > 0 {
//            beaconsToReturn = beacons
//        }
        
        return beacons.count > 0 ? beacons : nil
    }
    
    func getBeacons() {
        restManager.getBeacons()
    }
}

extension OHDataManager: OHRestManagerDelegate {
    
    func didGetSitemaps(sitemaps: [OHSitemap]) {
        var sitemapsDict = [String: OHSitemap]()
        
        for (_, sitemap) in sitemaps.enumerate() {
            sitemapsDict[sitemap.name] = sitemap
        }
        
        self.sitemaps = sitemapsDict
        
        if self.currentSitemap == nil {
            // init current sitemap if non is set
            self.currentSitemap = self.sitemaps!.values.first
        } else {
            // update current sitemap if updated one exists
            if let sitemap = self.sitemaps![self.currentSitemap!.name] {
                self.currentSitemap = sitemap
            }
        }
        
        saveData()
    }
    
    func didGetListOfSitemaps(sitemaps: [OHSitemap]) {
        restManager.getMultipleSitemaps(sitemaps)
    }
    
    func didGetBeacons(beacons: [OHBeacon]) {
        self.beacons = beacons
    }
}
