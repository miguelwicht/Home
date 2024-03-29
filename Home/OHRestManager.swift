//
//  OpenhabRestManager.swift
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 25/03/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import Foundation

let OHRestManagerConnectionDidFailNotification = "OHRestManagerConnectionDidFailNotification"

//MARK: OHRestManagerDelegate
@objc protocol OHRestManagerDelegate {
    optional func didGetItems(items: [OHItem])
    optional func didGetBeacons(beacons: [OHBeacon])
    optional func didGetSitemaps(sitemaps:[OHSitemap])
    optional func didGetSitemap(sitemap: OHSitemap)
    optional func didGetSitemapUrls(urls: [OHSitemap])
    optional func didGetListOfSitemaps(sitemaps: [OHSitemap])
    optional func didGetItemsWithTags(tags: [OHItem])
}

//MARK: OHRestManager
class OHRestManager : NSObject {

    var delegate: OHRestManagerDelegate?
    var baseUrl: String
    var acceptHeader: String = "application/json"
    var sitemaps = [OHSitemap]()
    
    init (baseUrl: String = "") {
        self.baseUrl = baseUrl
    }
}

//MARK: Items
extension OHRestManager {
    
    func getItems() {
        let urlPath = "\(baseUrl)/rest/items"
        let request = NSMutableURLRequest(URL: NSURL(string: urlPath)!)
        request.HTTPMethod = "GET"
        request.setValue(self.acceptHeader, forHTTPHeaderField: "Accept")

        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            let json = JSON(data: data!).dictionaryValue
        }
        task.resume()
    }
    
    func getItemsWithTags(tags: [String])
    {
        let tagString = ",".join(tags)
        
        let urlPath = "\(baseUrl)/rest/items?tags=\(tagString)&recursive=false"
        print(urlPath)
        let request = NSMutableURLRequest(URL: NSURL(string: urlPath)!)
        request.HTTPMethod = "GET"
        request.setValue(self.acceptHeader, forHTTPHeaderField: "Accept")
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            let json = JSON(data: data!).arrayValue
            
            var items = [OHItem]()
            for (_, item) in json.enumerate() {
                items.append(OHItem(item: item))
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.delegate?.didGetItemsWithTags?(items)
            })
        }
        task.resume()
    }
    
    func getBeacons() {
        let urlPath = "\(baseUrl)/rest/items?tags=OH_Beacon&recursive=false"
        print(urlPath)
        let request = NSMutableURLRequest(URL: NSURL(string: urlPath)!)
        request.HTTPMethod = "GET"
        request.setValue(self.acceptHeader, forHTTPHeaderField: "Accept")
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            let json = JSON(data: data!).arrayValue
            
            var items = [OHItem]()
            for (_, item) in json.enumerate() {
                items.append(OHItem(item: item))
            }
            
            var beacons = [OHBeacon]()
            
            for (_, item) in items.enumerate() {
                if let beaconItem = item.getBeaconFromTags() {
                    beacons.append(beaconItem);
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.delegate?.didGetBeacons?(beacons)
            })
        }
        task.resume()
    }
}

//MARK: Sitemaps
extension OHRestManager {
    
    func getListOfSitemaps() {
        let urlPath = "\(baseUrl)/rest/sitemaps"
        let request = NSMutableURLRequest(URL: NSURL(string: urlPath)!)
        request.HTTPMethod = "GET"
        request.setValue(self.acceptHeader, forHTTPHeaderField: "Accept")
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
                
            if error != nil {
                print("error=\(error)")
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    NSNotificationCenter.defaultCenter().postNotificationName("OHRestManagerCouldNotLoadData", object:self, userInfo: 
                    let userInfo: [String: String] = ["error": error!.localizedDescription]
                    NSNotificationCenter.defaultCenter().postNotificationName(OHRestManagerConnectionDidFailNotification, object: self, userInfo: userInfo)
                })
                return
            }
            
            let json = JSON(data: data!).arrayValue
            var sitemaps: [OHSitemap] = [OHSitemap]()
            
            for(_, element) in json.enumerate() {
                var elementDict = element.dictionaryValue
                var homepageDict = elementDict["homepage"]!.dictionaryValue
                let name: String = elementDict["name"] != nil ? elementDict["name"]!.stringValue : ""
                let link: String = elementDict["link"] != nil ? elementDict["link"]!.stringValue : ""
                let label: String = elementDict["label"] != nil ? elementDict["label"]!.stringValue : ""
                let leaf: String = homepageDict["leaf"] != nil ? homepageDict["leaf"]!.stringValue : ""
                let homepageLink: String = homepageDict["link"] != nil ? homepageDict["link"]!.stringValue : ""
                let sitemap: OHSitemap = OHSitemap(name: name, icon: "", label: label, link: link, leaf: leaf, homepageLink: homepageLink)
                if sitemap.name != "_default" {
                    sitemaps.append(sitemap)
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.delegate?.didGetListOfSitemaps?(sitemaps)
            })
        }
        task.resume()
    }
    
    func getSitemapInBackground(url: String) {
        let semaphore: dispatch_semaphore_t = dispatch_semaphore_create(0);
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "GET"
        request.setValue(self.acceptHeader, forHTTPHeaderField: "Accept")
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
        
            let json = JSON(data: data!)
            let sitemap = OHSitemap(sitemap: json)
            self.sitemaps.append(sitemap)
            
            dispatch_semaphore_signal(semaphore);
        }
        task.resume()
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    }

    func getMultipleSitemaps(sitemaps: [OHSitemap]) {
        self.sitemaps = [OHSitemap]()
        let group: dispatch_group_t = dispatch_group_create()
        
        for (_, sitemap) in sitemaps.enumerate() {
            dispatch_group_enter(group)
        
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                self.getSitemapInBackground(sitemap.link)
            
                dispatch_group_leave(group)
            })
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue()) { () -> Void in
            //var sitemaps = self.sitemaps
            self.delegate?.didGetSitemaps?(self.sitemaps)
            self.sitemaps = [OHSitemap]()
        }
    }
}
