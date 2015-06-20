//
//  OHWidget.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 21/04/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import UIKit

public class OHWidget: NSObject {
    
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
    var widgets: [OHWidget]?
    
    required public init(coder aDecoder: NSCoder) {
        self.widgetId = aDecoder.decodeObjectForKey("widgetId") as? String
        self.label = aDecoder.decodeObjectForKey("label") as? String
        self.icon = aDecoder.decodeObjectForKey("icon") as? String
        self.type = aDecoder.decodeObjectForKey("type") as? String
        self.url = aDecoder.decodeObjectForKey("url") as? String
        self.period = aDecoder.decodeObjectForKey("period") as? String
        self.minValue = aDecoder.decodeObjectForKey("minValue") as? String
        self.maxValue = aDecoder.decodeObjectForKey("maxValue") as? String
        self.step = aDecoder.decodeObjectForKey("step") as? String
        self.refresh = aDecoder.decodeObjectForKey("refresh") as? String
        self.height = aDecoder.decodeObjectForKey("height") as? String
        self.isLeaf = aDecoder.decodeObjectForKey("isLeaf") as? String
        self.iconColor = aDecoder.decodeObjectForKey("iconColor") as? String
        self.labelColor = aDecoder.decodeObjectForKey("labelColor") as? String
        self.valueColor = aDecoder.decodeObjectForKey("valueColor") as? String
        self.service = aDecoder.decodeObjectForKey("service") as? String
        
        self.item = aDecoder.decodeObjectForKey("item") as? OHItem
        self.linkedPage = aDecoder.decodeObjectForKey("linkedPage") as? OHLinkedPage
        self.text = aDecoder.decodeObjectForKey("text") as? String
        self.mappings = aDecoder.decodeObjectForKey("mappings") as? [String]
        self.widgets = aDecoder.decodeObjectForKey("widgets") as? [OHWidget]
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(widgetId, forKey: "widgetId")
        aCoder.encodeObject(label, forKey: "label")
        aCoder.encodeObject(icon, forKey: "icon")
        aCoder.encodeObject(type, forKey: "type")
        aCoder.encodeObject(url, forKey: "url")
        aCoder.encodeObject(period, forKey: "period")
        aCoder.encodeObject(minValue, forKey: "minValue")
        aCoder.encodeObject(maxValue, forKey: "maxValue")
        aCoder.encodeObject(step, forKey: "step")
        aCoder.encodeObject(refresh, forKey: "refresh")
        aCoder.encodeObject(height, forKey: "height")
        aCoder.encodeObject(isLeaf, forKey: "isLeaf")
        aCoder.encodeObject(iconColor, forKey: "iconColor")
        aCoder.encodeObject(labelColor, forKey: "labelColor")
        aCoder.encodeObject(valueColor, forKey: "valueColor")
        aCoder.encodeObject(service, forKey: "service")
        
        aCoder.encodeObject(item, forKey: "item")
        aCoder.encodeObject(linkedPage, forKey: "linkedPage")
        aCoder.encodeObject(text, forKey: "text")
        aCoder.encodeObject(mappings, forKey: "mappings")
        aCoder.encodeObject(widgets, forKey: "widgets")
    }
    
    public init(widget: [String: JSON]) {
        self.widgetId = widget["widgetId"]?.stringValue
        self.type = widget["type"]?.stringValue
        self.label = widget["label"]?.stringValue
        self.icon = widget["icon"]?.stringValue
        
        // parse linkedPage to OHLinkedPage
        if var linkedPage = widget["linkedPage"] {
            self.linkedPage = OHLinkedPage(linkedPage: linkedPage)
        }
        
        // parse widgets to OHWidget
        if var wid = widget["widgets"]?.arrayValue {
            self.widgets = OHRestParser.parseWidgets(wid)
        }
        
        if var item = widget["item"] {
            self.item = OHItem(item: item)
        }
    }
    
    func getItems() -> [String: OHItem] {
        var items = [String: OHItem]()
        var widgets = getWidgetsRecursevly()
        items = extractItemsFromWidgets(widgets)
        
        return items
    }
    
    func extractItemsFromWidgets(widgets: [OHWidget]) -> [String: OHItem] {
        var items = [String: OHItem]()
        
        for (index, widget) in enumerate(widgets) {
            var widgetItem = widget.item
            
            if var item = widgetItem {
                items[item.link] = item
            }
        }
        
        return items
    }
    
    func getWidgetsRecursevly() -> [OHWidget] {
        var widgetList = [OHWidget]()
        
        if var widgets = self.widgets {
            for (index, widget) in enumerate(widgets) {
                widgetList.append(widget)
                var widgetsFromWidget = widget.getWidgetsRecursevly()
                
                for (i, w) in enumerate(widgetsFromWidget) {
                    widgetList.append(w)
                }
            }
        }
        
        if var linkedPage = self.linkedPage {
            if var widgets = linkedPage.widgets {
                for (index, widget) in enumerate(widgets) {
                    widgetList.append(widget)
                    var widgetsFromWidget = widget.getWidgetsRecursevly()
                    
                    for (i, w) in enumerate(widgetsFromWidget) {
                        widgetList.append(w)
                    }
                }
            }
        }
        
        return widgetList
    }
}

//MARK: - Printable
extension OHWidget : Printable {
    
    override public var description: String {
        var desc: String = ""
        desc += "OHWidget: {\n"
        desc += "\titem: \(item) \n"
        desc += "\twidgetId: \(widgetId)\n"
        desc += "\tlabel: \(label) \n"
        desc += "\ticon: \(icon) \n"
        desc += "\ttype: \(type) \n"
        desc += "\tlinkedPage: \(linkedPage)\n"
        desc += "\twidgets: \(widgets)\n"
        desc += "}"

        return desc
    }
}