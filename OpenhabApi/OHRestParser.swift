//
//  OHRestParser.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 22/04/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import Foundation

class OHRestParser {
    
    static func parseWidgets(widgets: [JSON]) -> [OHWidget]
    {
        var widgetObjects: [OHWidget] = [OHWidget]()
        
        for (index, element) in enumerate(widgets)
        {
            widgetObjects.append(OHWidget(widget: element.dictionaryValue))
        }
        
        return widgetObjects
    }
    
    static func getBeaconsForRoomsFromSitemap(sitemap: OHSitemap) -> [OHBeacon: OHWidget]
    {
        var beaconWidgets = [OHBeacon: OHWidget]()
        
        
        
        var homepage = sitemap.homepage!
        
        var widget: OHWidget?
        
        for (i, e) in enumerate(homepage.widgets!)
        {
            widget = i == 0 ? e : widget
        }
        
        var widgets = widget!.widgets!
        
        for (index, element) in enumerate(widgets)
        {
            var beaconFrame = element.linkedPage!.widgets![0]
            var beaconFrameWidgets = beaconFrame.widgets!.first!.linkedPage!.widgets!
            
//            println(beaconWidgets)
            
            var uuid = beaconFrameWidgets[0].item!.state
            var major = beaconFrameWidgets[1].item!.state.toInt()
            var minor = beaconFrameWidgets[2].item!.state.toInt()
            var link = beaconFrameWidgets[3].item!.state
            
            if major != nil {
            
                var beacon = OHBeacon(uuid: uuid, major: major!, minor: minor!, link: link)
                beaconWidgets[beacon] = element
            } else {
                
                var beacon = OHBeacon(uuid: uuid, major: 0, minor: index, link: link)
                beaconWidgets[beacon] = element
            }
            
        }
        
        
        
//        var beacon = OHBeacon(uuid: "123123", major: 1, minor: 1, link: "asdasdasd")
//        var widget = sitemap.homepage!.widgets!.first
        
//        beaconWidgets[beacon] = widget
        
        return beaconWidgets
    }
    
    static func getMenuFromSitemap(sitemap: OHSitemap) -> [OHWidget]?
    {
        return sitemap.menuFromSitemap()?.widgets
    }
}