//
//  OHDataManager.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 06/05/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import Foundation

class OHDataManager : NSObject {
    var sitemaps: [OHSitemap]?
    var beacons: [OHBeacon]?
    var beaconWidget: [OHBeacon: OHWidget]?
    var items = [String: OHItem]()
    
    func updateSitemaps(sitemaps: [OHSitemap])
    {
        
    }
    
    func updateItemsFromSitemaps()
    {
        if var sitemaps = self.sitemaps {
            
            for (index, sitemap) in enumerate(sitemaps)
            {
                if var homepage = sitemap.homepage {
                    var homepageItems = homepage.getItems()
                    
                    for (index, item) in homepageItems {
                        items[item.link] = item
                    }
                }
            }
        }
        
    }
}