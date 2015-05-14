//
//  OHWidget.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 21/04/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import UIKit

public class OHWidget {
    
    var widgetId: String?
    var label: String?
    var icon: String?
    var type: String?
    var url: String?
    var period: String?
    var minValue: String?
    var maxValue: String?
    var step: String?
    var refresh: String?
    var height: String?
    var isLeaf: String?
    var iconColor: String?
    var labelColor: String?
    var valueColor: String?
    var service: String?
    
    var item: OHItem?
    var linkedPage: OHLinkedPage?
    var text: String? = ""
    var mappings: [String]? = [""]
    
//    var widgets: [JSON]?
    var widgets: [OHWidget]?
    
    public init(widget: [String: JSON])
    {
        self.widgetId = widget["widgetId"]?.stringValue
        self.type = widget["type"]?.stringValue
        self.label = widget["label"]?.stringValue
        self.icon = widget["icon"]?.stringValue
        
        // parse linkedPage to OHLinkedPage
        if var linkedPage = widget["linkedPage"]//?.dictionaryValue
        {
//            println(linkedPage)
//            self.linkedPage = OHLinkedPage(pageId: linkedPage["id"]!.stringValue, icon: linkedPage["icon"]!.stringValue, title: linkedPage["icon"]!.stringValue, link: linkedPage["link"]!.stringValue, widgets: linkedPage["widgets"]!.arrayValue)
            
            self.linkedPage = OHLinkedPage(linkedPage: linkedPage)
        }
        
        // parse widgets to OHWidget
        if var wid = widget["widgets"]?.arrayValue
        {
            self.widgets = OHRestParser.parseWidgets(wid)
        }
        
        if var item = widget["item"]
        {
            self.item = OHItem(item: item)
        }
    }
    
}

//MARK: OHBeacon: Printable
extension OHWidget : Printable {
    
    public var description: String {
        
        var desc: String = ""
        
        desc += "OHWidget: {\n"
        desc += "\titem: \(item) \n"
        desc += "\twidgetId: \(widgetId) \n"
        desc += "\tlabel: \(label) \n"
        desc += "\ticon: \(icon)"
        desc += "\ttype: \(type) \n"
        desc += "\tlinkedPage: \(linkedPage) \n"
        desc += "\twidgets: \(widgets) \n"
        desc += "}"

        return desc
    }
}