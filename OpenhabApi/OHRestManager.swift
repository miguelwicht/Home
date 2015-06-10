//
//  OpenhabRestManager.swift
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 25/03/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import Foundation

//MARK: OHRestManagerDelegate
@objc protocol OHRestManagerDelegate {
    optional func didGetItems(items: [OHItem])
    optional func didGetBeacons(beacons: [OHBeacon])
    optional func didGetSitemaps(sitemaps:[OHSitemap])
    optional func didGetSitemap(sitemap: OHSitemap)
}

//MARK: OHRestManager
class OHRestManager : NSObject {

    var delegate: OHRestManagerDelegate?
    let baseUrl: String
    var acceptHeader: String = "application/json"
    
    init (baseUrl: String = "")
    {
        self.baseUrl = baseUrl
    }
}

//MARK: Items
extension OHRestManager {
    
    func getItems()
    {
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
    
//    func getSitemapList()
//    {
//        let urlPath = "\(baseUrl)/rest/sitemaps"
//        let request = NSMutableURLRequest(URL: NSURL(string: urlPath)!)
//        request.HTTPMethod = "GET"
//        request.setValue("application/json", forHTTPHeaderField: "Accept")
//        
//        let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
//            {
//                data, response, error in
//                
//                if error != nil {
//                    println("error=\(error)")
//                    return
//                }
//                
//                let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
//                
//                //println(responseString)
//                //let json = JSON(data: data).dictionaryValue
//                let json = JSON(data: data).arrayValue
//                var sitemaps: [OHSitemap] = [OHSitemap]()
//                
//                //for(index, element) in enumerate(json["sitemap"]!.arrayValue) {
//                for(index, element) in enumerate(json) {
//                    //                    println("\(index), \(element.dictionaryValue)")
//                    
//                    var elementDict = element.dictionaryValue
//                    var homepageDict = elementDict["homepage"]!.dictionaryValue
//                    
//                    var name: String = elementDict["name"] != nil ? elementDict["name"]!.stringValue : ""
//                    var link: String = elementDict["link"] != nil ? elementDict["link"]!.stringValue : ""
//                    var label: String = elementDict["label"] != nil ? elementDict["label"]!.stringValue : ""
//                    var leaf: String = homepageDict["leaf"] != nil ? homepageDict["leaf"]!.stringValue : ""
//                    var homepageLink: String = homepageDict["link"] != nil ? homepageDict["link"]!.stringValue : ""
//                    
//                    var sitemap: OHSitemap = OHSitemap(name: name, icon: "", label: label, link: link, leaf: leaf, homepageLink: homepageLink)
//                    
//                    //                    var sitemap = OHSitemap(sitemap: element)
//                    
//                    sitemaps.append(sitemap)
//                }
//                
//                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    self.delegate!.didGetSitemaps!(sitemaps)
//                })
//        }
//        task.resume()
//    }
    
    func getSitemaps()
    {
        let urlPath = "\(baseUrl)/rest/sitemaps"
        let request = NSMutableURLRequest(URL: NSURL(string: urlPath)!)
        request.HTTPMethod = "GET"
        request.setValue(self.acceptHeader, forHTTPHeaderField: "Accept")
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
            {
                data, response, error in
                
                if error != nil {
                    println("error=\(error)")
                    return
                }
                
                let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
                
                //println(responseString)
                //let json = JSON(data: data).dictionaryValue
                let json = JSON(data: data).arrayValue
                var sitemaps: [OHSitemap] = [OHSitemap]()
                
                //for(index, element) in enumerate(json["sitemap"]!.arrayValue) {
                for(index, element) in enumerate(json) {
                    
                    
//                    let sitemapJson = JSON(data: element.stringValue.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: false)!)
//                    let sitemap = OHSitemap(sitemap: sitemapJson)
//                    sitemaps.append(sitemap)
                    
//                    println("\(index), \(element.dictionaryValue)")
                    
                    var elementDict = element.dictionaryValue
                    var homepageDict = elementDict["homepage"]!.dictionaryValue
                    
                    var name: String = elementDict["name"] != nil ? elementDict["name"]!.stringValue : ""
                    var link: String = elementDict["link"] != nil ? elementDict["link"]!.stringValue : ""
                    var label: String = elementDict["label"] != nil ? elementDict["label"]!.stringValue : ""
                    var leaf: String = homepageDict["leaf"] != nil ? homepageDict["leaf"]!.stringValue : ""
                    var homepageLink: String = homepageDict["link"] != nil ? homepageDict["link"]!.stringValue : ""
                    
                    var sitemap: OHSitemap = OHSitemap(name: name, icon: "", label: label, link: link, leaf: leaf, homepageLink: homepageLink)
                
//                    var sitemap = OHSitemap(sitemap: element)
                    
                    sitemaps.append(sitemap)
                }
                
                
                
//                var fileManager = S3FileManager();
//                var localError: NSError?
//                var jsonData = responseString!.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: false)
//                var jsonDictionary: NSArray = NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers, error: &localError) as! NSArray
//                
//                for (i, el) in enumerate(jsonDictionary)
//                {
//                    var path: NSString = S3FileManager.applicationDocumentsDirectory().path!.stringByAppendingPathComponent("sitemaps/\(sitemaps[i].name).json") as NSString
//                    S3FileManager.saveDictionary(el as! [NSObject : AnyObject], toPath: path as NSString as String)
//                }
//                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.delegate!.didGetSitemaps!(sitemaps)
                })
        }
        task.resume()
    }
    
    func getSitemap(name: String)
    {
        let urlPath = "\(baseUrl)/rest/sitemaps/" + name
        let request = NSMutableURLRequest(URL: NSURL(string: urlPath)!)
        request.HTTPMethod = "GET"
        request.setValue(self.acceptHeader, forHTTPHeaderField: "Accept")
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                println("error=\(error)")
                return
            }
            
            //println("response = \(response)")
            
            let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
//            println("responseString = \(responseString)")
            
            var fileManager = S3FileManager();
            var localError: NSError?
            var jsonData = responseString!.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: false)
            var jsonDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers, error: &localError) as! NSDictionary
            
            var path: NSString = S3FileManager.applicationDocumentsDirectory().path!.stringByAppendingPathComponent("sitemaps/\(name).json") as NSString
            S3FileManager.saveDictionary(jsonDictionary as [NSObject : AnyObject], toPath: path as NSString as String)
            
            let json = JSON(data: data)
            
            let sitemap = OHSitemap(sitemap: json)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                self.delegate!.didGetSitemap!(responseString! as String)
                self.delegate!.didGetSitemap!(sitemap)
            })
        }
        task.resume()
    }
}

//MARK: Beacons
extension OHRestManager {
    
    func getBeacons()
    {
        let urlPath = "\(baseUrl)/rest/sitemaps/beacons"
        let request = NSMutableURLRequest(URL: NSURL(string: urlPath)!)
        request.HTTPMethod = "GET"
        request.setValue(self.acceptHeader, forHTTPHeaderField: "Accept")

        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                println("error=\(error)")
                return
            }
            
            //println("response = \(response)")
            
            let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
            // println("responseString = \(responseString)")
            
            let json = JSON(data: data).dictionaryValue
            //println(json)
            //            for (index, element) in enumerate(json) {
            //                println("Item \(index): \(element)")
            //            }
            
            //println(json["homepage"]!["widget"])
            
            let beaconElements = json["homepage"]!["widget"].arrayValue
            var openhabBeacons = [OHBeacon]()
            
            //println(beaconElements)
            
            for (index, element) in enumerate(beaconElements)
            {
                var uuid: String?
                var major: NSInteger?
                var minor: NSInteger?
                var link: String?
                
                //println(element["widget"])
                
                for(widgetIndex, widgetElement) in enumerate(element["widget"].arrayValue)
                {
                    var item = widgetElement["item"]
                    
                    if (widgetElement["type"] == "Text")
                    {
                        
                        if (item["name"].stringValue.rangeOfString("Beacon_UUID") != nil)
                        {
                            uuid = item["state"].stringValue
                            //link = item["link"].stringValue
                        }
                        else if(item["name"].stringValue.rangeOfString("Beacon_Major") != nil)
                        {
                            major = item["state"].intValue
                        }
                        else if(item["name"].stringValue.rangeOfString("Beacon_Minor") != nil)
                        {
                            minor = item["state"].intValue
                        }
                    }
                    else if (widgetElement["type"] == "Group")
                    {
                        link = item["link"].stringValue
                    }
                    
                }
                
                //println("\(uuid!), \(major!), \(minor!), \(link!)")
                
                var beacon = OHBeacon(uuid: uuid!, major: major!, minor: minor!, link: link!)
                openhabBeacons.append(beacon)
            }
            
            //println("\(openhabBeacons)")
            
            let beacons: [String:String]
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.delegate!.didGetBeacons!(openhabBeacons)
            })
            
        }
        task.resume()
    }
}