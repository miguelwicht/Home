//
//  OHLinkedPage.swift
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 15/04/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import Foundation

@objc public class OHLinkedPage {
    
    let pageId: String
    let icon: String
    let title: String
    let link: String
    var widgets: [OHWidget]?
    var linkedPage: OHLinkedPage?
    
    init(pageId:String, icon:String, title:String, link:String, widgets: [JSON]?){
        self.pageId = pageId
        self.icon = icon
        self.title = title
        self.link = link
        
        
        if var wids = widgets {
            self.widgets = OHRestParser.parseWidgets(wids)
        }
        
    }
    
    init(linkedPage: JSON)
    {
        let linkedPageDict = linkedPage.dictionaryValue
        
        self.pageId = linkedPageDict["pageId"]!.stringValue
        self.icon = linkedPageDict["icon"]!.stringValue
        self.title = linkedPageDict["title"]!.stringValue
        self.link = linkedPageDict["icon"]!.stringValue
        //self.widgets = linkedPageDict["widgets"]?.arrayValue
        
        if var subPage = linkedPageDict["linkedPage"] {
            self.linkedPage = OHLinkedPage(linkedPage: subPage)
        }
        
        if var wids = linkedPageDict["widgets"]?.arrayValue {
            self.widgets = OHRestParser.parseWidgets(wids)
        }
    }
}

//MARK: OHSitemap: Printable
extension OHLinkedPage : Printable {
    
    public var description:String
    {
            let className = reflect(self).summary
            var desc:String = ""
            desc += "\(className):\n{\n"
            desc += "\tpageId: \(self.pageId),\n"
            desc += "\ttitle: \(self.title),\n"
            desc += "\tlink: \(self.link),\n"
            desc += "\ticon: \(self.icon)\n}"
            desc += "\twidgets: \(self.widgets)\n"
            desc += "\tlinkedPage: \(self.linkedPage)\n"
        
            return desc
    }
}