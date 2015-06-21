//
//  OpenhabRestManager.swift
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 25/03/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import Foundation
import SwiftyJSON

//MARK: OHRestManagerDelegate
@objc protocol OHRestManagerDelegate {
    optional func didGetItems(items: [OHItem])
    optional func didGetBeacons(beacons: [OHBeacon])
    optional func didGetSitemaps(sitemaps:[OHSitemap])
    optional func didGetSitemap(sitemap: OHSitemap)
    optional func didGetSitemapUrls(urls: [OHSitemap])
    optional func didGetListOfSitemaps(sitemaps: [OHSitemap])
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
                println("error=\(error)")
                return
            }
            
            let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
            let json = JSON(data: data).dictionaryValue
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
                println("error=\(error)")
                return
            }
            
            let json = JSON(data: data).arrayValue
            var sitemaps: [OHSitemap] = [OHSitemap]()
            
            for(index, element) in enumerate(json) {
                var elementDict = element.dictionaryValue
                var homepageDict = elementDict["homepage"]!.dictionaryValue
                var name: String = elementDict["name"] != nil ? elementDict["name"]!.stringValue : ""
                var link: String = elementDict["link"] != nil ? elementDict["link"]!.stringValue : ""
                var label: String = elementDict["label"] != nil ? elementDict["label"]!.stringValue : ""
                var leaf: String = homepageDict["leaf"] != nil ? homepageDict["leaf"]!.stringValue : ""
                var homepageLink: String = homepageDict["link"] != nil ? homepageDict["link"]!.stringValue : ""
                var sitemap: OHSitemap = OHSitemap(name: name, icon: "", label: label, link: link, leaf: leaf, homepageLink: homepageLink)
                
                sitemaps.append(sitemap)
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.delegate?.didGetListOfSitemaps?(sitemaps)
            })
        }
        task.resume()
    }
    
    func getSitemapInBackground(url: String) {
        var semaphore: dispatch_semaphore_t = dispatch_semaphore_create(0);
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "GET"
        request.setValue(self.acceptHeader, forHTTPHeaderField: "Accept")
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                println("error=\(error)")
                return
            }
        
            let json = JSON(data: data)
            let sitemap = OHSitemap(sitemap: json)
            self.sitemaps.append(sitemap)
            
            dispatch_semaphore_signal(semaphore);
        }
        task.resume()
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    }

    func getMultipleSitemaps(sitemaps: [OHSitemap]) {
        self.sitemaps = [OHSitemap]()
        var group: dispatch_group_t = dispatch_group_create()
        
        for (index, sitemap) in enumerate(sitemaps) {
            dispatch_group_enter(group)
        
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                self.getSitemapInBackground(sitemap.link)
            
                dispatch_group_leave(group)
            })
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue()) { () -> Void in
            var sitemaps = self.sitemaps
            self.delegate?.didGetSitemaps?(self.sitemaps)
            self.sitemaps = [OHSitemap]()
        }
    }
}
