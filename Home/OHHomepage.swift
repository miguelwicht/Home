//
//  OHHomepage.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 22/04/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import Foundation

public class OHHomepage: NSObject {
    let id: String
    let title: String
    let link: String
    let leaf: Bool
    
    var widgets: [OHWidget]?
    
    required public init(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObjectForKey("id") as! String
        self.title = aDecoder.decodeObjectForKey("title") as! String
        self.link = aDecoder.decodeObjectForKey("link") as! String
        self.leaf = aDecoder.decodeObjectForKey("leaf") as! Bool
        
        self.widgets = aDecoder.decodeObjectForKey("widgets") as? [OHWidget]
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(id, forKey: "id")
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(link, forKey: "link")
        aCoder.encodeObject(leaf, forKey: "leaf")
        
        aCoder.encodeObject(widgets, forKey: "widgets")
    }
    
    init(homepage: JSON) {
        let hp = homepage.dictionaryValue
        self.id = hp["id"]!.stringValue
        self.title = hp["title"]!.stringValue
        self.link = hp["link"]!.stringValue
        self.leaf = hp["leaf"]!.boolValue
        
        if let widgets = hp["widgets"]?.arrayValue {
          self.widgets = OHRestParser.parseWidgets(widgets)
        }
    }
    
    func getItems() -> [String: OHItem] {
        var items = [String: OHItem]()
        
        if let widgets = self.widgets {
            for (_, widget) in widgets.enumerate() {
                let widgetItems = widget.getItems()
                
                for (_, item) in widgetItems {
                    items[item.link] = item
                }
            }
            
        }
        
        return items
    }
}

//MARK: - Printable
//extension OHHomepage: CustomStringConvertible {
//    
//    override public var description: String {
//        let className = reflect(self).summary
//        var desc:String = ""
//        desc += "\n\(className):\n{\n"
//        desc += "\tid: \(self.id),\n"
//        desc += "\ttitle: \(self.title),\n"
//        desc += "\tlink: \(self.link),\n"
//        desc += "\tleaf: \(self.leaf),\n"
//        desc += "\twidgets: \(self.widgets)\n}"
//        
//        return desc
//    }
//}