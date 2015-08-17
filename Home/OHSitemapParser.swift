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

    public init(sitemap: JSON) {
        self.sitemap = OHSitemap(sitemap: sitemap)
    }
    
    func getWidgets() -> [OHWidget] {
        let widgets = self.sitemap.homepage!.widgets!
        return widgets
    }
    
    
    static func parseWidgets(widgets: [JSON]) -> [OHWidget] {
        var widgetObjects: [OHWidget] = [OHWidget]()
        
        for (_, element) in widgets.enumerate() {
            widgetObjects.append(OHWidget(widget: element.dictionaryValue))
        }
        
        return widgetObjects
    }
}

//MARK: Type parser
extension OHSitemapParser {
    
    func parseWidget(widget: [String: JSON]) -> OHWidget {
        return OHWidget(widget: widget)
    }
}