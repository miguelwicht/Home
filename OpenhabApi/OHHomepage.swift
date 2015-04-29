//
//  OHHomepage.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 22/04/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import Foundation

public class OHHomepage {
    let id: String
    let title: String
    let link: String
    let leaf: Bool
    
    var widgets: [OHWidget]?
    
    init(homepage: JSON)
    {
        let hp = homepage.dictionaryValue
        self.id = hp["id"]!.stringValue
        self.title = hp["title"]!.stringValue
        self.link = hp["link"]!.stringValue
        self.leaf = hp["leaf"]!.boolValue
        
        if var widgets = hp["widgets"]?.arrayValue {
          self.widgets = OHRestParser.parseWidgets(widgets)
        }
    }
}

extension OHHomepage: Printable {
    
    public var description: String
    {
        let className = reflect(self).summary
        var desc:String = ""
        desc += "\n\(className):\n{\n"
        desc += "\tid: \(self.id),\n"
        desc += "\ttitle: \(self.title),\n"
        desc += "\tlink: \(self.link),\n"
        desc += "\tleaf: \(self.leaf),\n"
        desc += "\twidgets: \(self.widgets)\n}"
        
        return desc
    }
}