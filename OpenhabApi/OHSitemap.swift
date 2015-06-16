//
//  OHSitemap.swift
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 14/04/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import Foundation

@objc public class OHSitemap: NSObject {
    
    let name: String
    var icon: String?
    let label: String
    let link: String
    var leaf: String?
    var homepageLink: String?
    
    var homepage: OHHomepage?
    
    required public init(coder aDecoder: NSCoder)
    {
        self.name = aDecoder.decodeObjectForKey("name") as! String
        self.icon = aDecoder.decodeObjectForKey("icon") as? String
        self.label = aDecoder.decodeObjectForKey("label") as! String
        self.link = aDecoder.decodeObjectForKey("link") as! String
        self.leaf = aDecoder.decodeObjectForKey("leaf") as? String
        self.homepageLink = aDecoder.decodeObjectForKey("homepageLink") as? String
        self.homepage = aDecoder.decodeObjectForKey("homepage") as? OHHomepage
    }
    
    func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(icon, forKey: "icon")
        aCoder.encodeObject(label, forKey: "label")
        aCoder.encodeObject(link, forKey: "link")
        aCoder.encodeObject(leaf, forKey: "leaf")
        aCoder.encodeObject(homepageLink, forKey: "homepageLink")
        aCoder.encodeObject(homepage, forKey: "homepage")
    }
    
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
    
    func roomsInSitemap() -> [OHWidget]?
    {
        var rooms: OHWidget?
        
        if var homepage = self.homepage {
            for (i, e) in enumerate(homepage.widgets!)
            {
                if e.label == "Rooms" {
                    rooms = e
                    break
                }
            }
        }
        
        return rooms?.widgets
    }
    
    func menuFromSitemap() -> OHWidget?
    {
        var menuWidget: OHWidget?
        
        if var homepage = self.homepage {
        
            for (i, e) in enumerate(homepage.widgets!)
            {
                if e.label == "Menu" {
                    menuWidget = e
                    break
                }
            }
        }
        
        return menuWidget
    }
}

//MARK: OHSitemap: Printable
extension OHSitemap : Printable {
    
    override public var description:String
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