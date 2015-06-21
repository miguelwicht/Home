//
//  OHRestParser.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 22/04/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import Foundation
import SwiftyJSON

class OHRestParser {
    
    static func parseWidgets(widgets: [JSON]) -> [OHWidget] {
        var widgetObjects: [OHWidget] = [OHWidget]()
        
        for (index, element) in enumerate(widgets) {
            widgetObjects.append(OHWidget(widget: element.dictionaryValue))
        }
        
        return widgetObjects
    }
    
    static func getBeaconsForRoomsFromSitemap(sitemap: OHSitemap) -> [OHBeacon: OHWidget] {
        var beaconWidgets = [OHBeacon: OHWidget]()
        var homepage = sitemap.homepage!
        var widget: OHWidget?
        
        for (i, e) in enumerate(homepage.widgets!) {
            widget = i == 0 ? e : widget
        }
        
        var widgets = widget!.widgets!
        
        for (index, element) in enumerate(widgets) {
            var beaconFrame = element.linkedPage!.widgets![0]
            var beaconFrameWidgets = beaconFrame.widgets!.first!.linkedPage!.widgets!
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
        
        return beaconWidgets
    }
    
    static func getMenuFromSitemap(sitemap: OHSitemap) -> [OHWidget]? {
        return sitemap.menuFromSitemap()?.widgets
    }
}