//
//  OHLinkedPage.swift
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 15/04/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import Foundation

@objc public class OHLinkedPage: NSObject {
    
    let pageId: String
    let icon: String
    let title: String
    let link: String
    var widgets: [OHWidget]?
    var linkedPage: OHLinkedPage?
    
    required public init(coder aDecoder: NSCoder) {
        self.pageId = aDecoder.decodeObjectForKey("pageId") as! String
        self.icon = aDecoder.decodeObjectForKey("icon") as! String
        self.title = aDecoder.decodeObjectForKey("title") as! String
        self.link = aDecoder.decodeObjectForKey("link") as! String
        self.widgets = aDecoder.decodeObjectForKey("widgets") as? [OHWidget]
        self.linkedPage = aDecoder.decodeObjectForKey("widgets") as? OHLinkedPage
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(pageId, forKey: "pageId")
        aCoder.encodeObject(icon, forKey: "icon")
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(link, forKey: "link")
        aCoder.encodeObject(widgets, forKey: "widgets")
        aCoder.encodeObject(linkedPage, forKey: "linkedPage")
    }
    
    init(pageId:String, icon:String, title:String, link:String, widgets: [JSON]?){
        self.pageId = pageId
        self.icon = icon
        self.title = title
        self.link = link
        
        if let wids = widgets {
            self.widgets = OHRestParser.parseWidgets(wids)
        }
    }
    
    init(linkedPage: JSON) {
        var linkedPageDict = linkedPage.dictionaryValue
        
        self.pageId = linkedPageDict["id"]!.stringValue
        self.icon = linkedPageDict["icon"]!.stringValue
        self.title = linkedPageDict["title"]!.stringValue
        self.link = linkedPageDict["icon"]!.stringValue
        
        if let subPage = linkedPageDict["linkedPage"] {
            self.linkedPage = OHLinkedPage(linkedPage: subPage)
        }
        
        if let wids = linkedPageDict["widgets"]?.arrayValue {
            self.widgets = OHRestParser.parseWidgets(wids)
        }
    }
}

//MARK: - Printable
//extension OHLinkedPage : CustomStringConvertible {
//    
//    override public var description:String {
//        let className = reflect(self).summary
//        var desc:String = ""
//        desc += "\(className):\n{\n"
//        desc += "\tpageId: \(self.pageId),\n"
//        desc += "\ttitle: \(self.title),\n"
//        desc += "\tlink: \(self.link),\n"
//        desc += "\ticon: \(self.icon)\n}"
//        desc += "\twidgets: \(self.widgets)\n"
//        desc += "\tlinkedPage: \(self.linkedPage)\n"
//        
//        return desc
//    }
//}
