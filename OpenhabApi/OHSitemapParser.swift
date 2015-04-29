//
//  OHSitemapParser.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 21/04/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import Foundation

public class OHSitemapParser {
    
    var sitemap: OHSitemap
    var widgets: [OHWidget]?

    public init(sitemap: JSON)
    {
//        self.sitemap = sitemap
        
        self.sitemap = OHSitemap(sitemap: sitemap)
    }
    
    func getWidgets() -> [OHWidget]
    {
//        let sitemapData: NSData = self.sitemap.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
//        var sitemap = JSON(data: sitemapData).dictionaryValue
//        var homepage = sitemap["homepage"]!.dictionaryValue
        
//        var widgets: [OHWidget] = OHSitemapParser.parseWidgets(homepage["widgets"]!.arrayValue)
        var widgets = self.sitemap.homepage!.widgets!
        return widgets
    }
    
    
    static func parseWidgets(widgets: [JSON]) -> [OHWidget]
    {
        var widgetObjects: [OHWidget] = [OHWidget]()
        
        for (index, element) in enumerate(widgets)
        {
            widgetObjects.append(OHWidget(widget: element.dictionaryValue))
        }
        
        return widgetObjects
    }
    
    
    
}

//MARK: Type parser
extension OHSitemapParser {
    
    func parseWidget(widget: [String: JSON]) -> OHWidget
    {
        return OHWidget(widget: widget)
    }
    
//    func parseFrame(frame: [String: JSON]) -> OHWidget
//    {
//        
//        var widget: Dictionary()
//        widget["widgetId"] = frame["widgetId"]
//        widget["type"] = frame["type"]
//        widget["label"] = frame["label"]
//        widget["icon"] = frame["icon"]
//        widget["linkedPage"] = frame["linkedPage"]
//        
//        return OHWidget(widget: frame)
//    }
//    
//    func parseGroup(group: [String: JSON]) -> OHWidget
//    {
//        return OHWidget(widget: group)
//    }
//    
//    func parseText(text: [String: JSON]) -> OHWidget
//    {
//        return OHWidget(widget: text)
//    }
//    
//    func parseSlider(slider: [String: JSON]) -> OHWidget
//    {
//        return OHWidget(widget: slider)
//    }
}