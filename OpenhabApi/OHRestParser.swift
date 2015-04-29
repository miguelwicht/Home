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
}