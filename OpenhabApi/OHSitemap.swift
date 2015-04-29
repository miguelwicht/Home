//
//  OHSitemap.swift
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 14/04/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import Foundation

@objc public class OHSitemap {
    
    let name: String
    var icon: String?
    let label: String
    let link: String
    var leaf: String?
    var homepageLink: String?
    
    var homepage: OHHomepage?
    
    public init(name:String, icon:String, label:String, link:String, leaf:String, homepageLink:String){
        self.name = name
        self.icon = icon
        self.label = label
        self.link = link
        self.leaf = leaf
        self.homepageLink = homepageLink
    }
    
    public init(sitemap: JSON)
    {
        let map = sitemap.dictionaryValue
        self.name = map["name"]!.stringValue
        self.icon = map["icon"]?.stringValue
        self.label = map["label"]!.stringValue
        self.link = map["link"]!.stringValue
        self.leaf = map["leaf"]?.stringValue
        self.homepageLink = map["homepageLink"]?.stringValue
        
        if var hp = map["homepage"] {
            self.homepage = OHHomepage(homepage: hp)
        }
    }
}

//MARK: OHSitemap: Printable
extension OHSitemap : Printable {
    
    public var description:String
    {
        let className = reflect(self).summary
        var desc:String = ""
        desc += "\n\(className):\n{\n"
        desc += "\tname: \(self.name),\n"
        desc += "\tlabel: \(self.label),\n"
        desc += "\tlink: \(self.link),\n"
        desc += "\tleaf: \(self.leaf),\n"
        desc += "\thomepageLink: \(self.homepageLink)\n}"
        desc += "\thomepage: \(self.homepage)\n"
        
        return desc
    }
}