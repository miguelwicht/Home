//
//  OHRestParser.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 22/04/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import Foundation

class OHRestParser {
    
    static func parseWidgets(widgets: [JSON]) -> [OHWidget] {
        var widgetObjects: [OHWidget] = [OHWidget]()
        
        for (_, element) in widgets.enumerate() {
            widgetObjects.append(OHWidget(widget: element.dictionaryValue))
        }
        
        return widgetObjects
    }
    
    static func getBeaconsForRoomsFromSitemap(sitemap: OHSitemap) -> [OHBeacon: OHWidget] {
        var beaconWidgets = [OHBeacon: OHWidget]()
        let homepage = sitemap.homepage!
        var widget: OHWidget?
        
        for (i, e) in (homepage.widgets!).enumerate() {
            widget = i == 0 ? e : widget
        }
        
        let widgets = widget!.widgets!
        
        for (index, element) in widgets.enumerate() {
            let beaconFrame = element.linkedPage!.widgets![0]
            var beaconFrameWidgets = beaconFrame.widgets!.first!.linkedPage!.widgets!
            let uuid = beaconFrameWidgets[0].item!.state
            let major = Int(beaconFrameWidgets[1].item!.state)
            let minor = Int(beaconFrameWidgets[2].item!.state)
            let link = beaconFrameWidgets[3].item!.state
            
            if major != nil {
                let beacon = OHBeacon(uuid: uuid, major: major!, minor: minor!, link: link)
                beaconWidgets[beacon] = element
            } else {
                let beacon = OHBeacon(uuid: uuid, major: 0, minor: index, link: link)
                beaconWidgets[beacon] = element
            }
        }
        
        return beaconWidgets
    }
    
    static func getMenuFromSitemap(sitemap: OHSitemap) -> [OHWidget]? {
        return sitemap.menuFromSitemap()?.widgets
    }
}