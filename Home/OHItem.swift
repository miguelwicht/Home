//
//  OHItem.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 15/04/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import UIKit

public class OHItem: NSObject {
    
    let type: String
    let name: String
    var state: String
    let link: String
    var tags: [String]?
    
    required public init(coder aDecoder: NSCoder) {
        self.type = aDecoder.decodeObjectForKey("type") as! String
        self.name = aDecoder.decodeObjectForKey("name") as! String
        self.state = aDecoder.decodeObjectForKey("state") as! String
        self.link = aDecoder.decodeObjectForKey("link") as! String
        self.tags = aDecoder.decodeObjectForKey("tags") as? [String]
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(type, forKey: "type")
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(state, forKey: "state")
        aCoder.encodeObject(link, forKey: "link")
        aCoder.encodeObject(tags, forKey: "tags")
    }
    
    public init(type: String, name: String, state: String, link: String) {
        self.type = type
        self.name = name
        self.state = state
        self.link = link
    }
    
    public init(item: JSON) {
        var i = item.dictionaryValue
        
        self.type = i["type"]!.stringValue
        self.name = i["name"]!.stringValue
        self.state = i["state"]!.stringValue
        self.link = i["link"]!.stringValue
        
        super.init()
        
        if var tags = i["tags"]?.arrayValue {
            if tags.count > 0 {
                self.addTags(tags)
            }
        }
    }
    
    func addTags(tags: [JSON]) {
        self.tags = [String]()
        
        for(_, tag) in tags.enumerate() {
            self.tags?.append(tag.stringValue)
        }
    }
    
    public func stateAsInt() -> Int {
        return Int(state)!
    }
    
    public func stateAsFloat() -> Float {
        let numberFormatter = NSNumberFormatter()
        
        return numberFormatter.numberFromString(state)!.floatValue
    }
    
    public func stateAsUIColor() -> UIColor {
        let fallbackColor = UIColor(hue: 0.0, saturation: 0.0, brightness: 0.0, alpha: 1.0)
        let values: [String] = self.state.componentsSeparatedByString(",")
        
        if (values.count == 3) {
            let numberFormatter = NSNumberFormatter()
            let hue: CGFloat = CGFloat(numberFormatter.numberFromString(values[0])!.floatValue)
            let saturation: CGFloat = CGFloat(numberFormatter.numberFromString(values[1])!.floatValue)
            let brightness: CGFloat = CGFloat(numberFormatter.numberFromString(values[2])!.floatValue)
            
            return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
        }
        
        return fallbackColor
    }
    
    public func sendCommand(command: String) {
        let urlPath = self.link
        let request = NSMutableURLRequest(URL: NSURL(string: urlPath)!)
        request.HTTPMethod = "POST"
        request.setValue("text/plain; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let postString = "\(command)"
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print(responseString)
            
            self.updateState()
        }
        task.resume()
    }
    
    public func updateState() {
        let urlPath = self.link
        let request = NSMutableURLRequest(URL: NSURL(string: urlPath)!)
        request.HTTPMethod = "GET"
        request.setValue("text/plain; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print(responseString)
            
            let json = JSON(data: data!)
            let item = OHItem(item: json)
            self.state = item.state
        }
        task.resume()
    }
}

//MARK: OHSitemap: Printable
//extension OHItem : CustomStringConvertible {
//    
//    override public var description:String {
//        let className = reflect(self).summary
//        var desc:String = ""
//        desc += "\n\(className):\n{\n"
//        desc += "\tname: \(self.type),\n"
//        desc += "\tlabel: \(self.name),\n"
//        desc += "\tstate: \(self.state),\n"
//        desc += "\tlink: \(self.link),\n"
//        desc += "\ttags: \(self.tags),\n"
//        
//        return desc
//    }
//}

//MARK: Tag helpers
extension OHItem {
    
    func iconNameFromTags() -> String? {
        var name: String?
        
        if let tags = self.tags {
            for (_, tag) in tags.enumerate() {
                if tag.rangeOfString("OH_Icon_") != nil {
                    name = tag.stringByReplacingOccurrencesOfString("OH_Icon_", withString: "")
                    break
                }
            }
        }
        
        return name
    }
    
    func numberOfRowsFromTags() -> Int? {
        var numberOfRows: Int?
    
        if let tags = self.tags {
            for (_, tag) in tags.enumerate() {
                if tag.rangeOfString("OH_Outlet_Rows_") != nil {
                    let tagString = tag.stringByReplacingOccurrencesOfString("OH_Outlet_Rows_", withString: "")
                    numberOfRows = Int(tagString)!
                    break
                }
            }
        }
        
        return numberOfRows
    }
    
    func isLightFromTags() -> Bool {
        var isLight = false
        
        if let tags = self.tags {
            for (_, tag) in tags.enumerate() {
                if tag.rangeOfString("OH_Light") != nil {
                    isLight = true
                    break
                }
            }
        }
        
        return isLight
    }
    
    func hasTag(tag: String) -> Bool {
        var hasTag = false
        
        if let tags = self.tags {
            hasTag = tags.contains(tag)
        }
        
        return hasTag
    }
    
    func hasTagWithPrefix(prefix: String) -> Bool {
        var hasTag = false
        
        if let tags = self.tags {
            for (_, tag) in tags.enumerate() {
                if tag.rangeOfString(prefix) != nil {
                    hasTag = true
                    break
                }
            }
        }
        
        return hasTag
    }
    
    func getTagWithoutPrefix(prefix: String) -> String? {
        var tagWithoutPrefix: String?
        
        if let tags = self.tags {
            for (_, tag) in tags.enumerate() {
                if tag.rangeOfString(prefix) != nil {
                    tagWithoutPrefix = tag.stringByReplacingOccurrencesOfString(prefix, withString: "")
                    break
                }
            }
        }
        
        return tagWithoutPrefix
    }
    
    func getBeaconFromTags() -> OHBeacon? {
        
        var uuidOpt: String?
        var majorOpt: Int?
        var minorOpt: Int?
        let link: String = self.link
        
        if self.hasTag("OH_Beacon") {
            if let tags = self.tags {
                for (_, tag) in tags.enumerate() {
                    if tag.rangeOfString("OH_Beacon_UUID_") != nil {
                        uuidOpt = tag.stringByReplacingOccurrencesOfString("OH_Beacon_UUID_", withString: "")
                    } else if tag.rangeOfString("OH_Beacon_Major_") != nil {
                        majorOpt = Int(tag.stringByReplacingOccurrencesOfString("OH_Beacon_Major_", withString: ""))
                    } else if tag.rangeOfString("OH_Beacon_Minor_") != nil {
                        minorOpt = Int(tag.stringByReplacingOccurrencesOfString("OH_Beacon_Minor_", withString: ""))
                    }
                }
            }
        }
        
        guard let uuid = uuidOpt, let major = majorOpt, let minor = minorOpt else {
                return nil
        }
        
        return OHBeacon(uuid: uuid, major: major, minor: minor, link: link)
    }
}
