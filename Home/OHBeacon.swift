//
//  OHBeacon.swift
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 13/04/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import Foundation

@objc public class OHBeacon: NSObject {
    
    public let uuid: String
    public let major: Int
    public let minor: Int
    public let link: String
    public var proximity: Int?
    public var rssi: Int?
    
    required public init(coder aDecoder: NSCoder) {
        self.uuid = aDecoder.decodeObjectForKey("uuid") as! String
        self.major = aDecoder.decodeObjectForKey("major") as! Int
        self.minor = aDecoder.decodeObjectForKey("minor") as! Int
        self.link = aDecoder.decodeObjectForKey("link") as! String
        self.proximity = aDecoder.decodeObjectForKey("roximity") as? Int
        self.rssi = aDecoder.decodeObjectForKey("rssi") as? Int
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(uuid, forKey: "uuid")
        aCoder.encodeObject(major, forKey: "major")
        aCoder.encodeObject(minor, forKey: "minor")
        aCoder.encodeObject(link, forKey: "link")
        aCoder.encodeObject(proximity, forKey: "proximity")
        aCoder.encodeObject(rssi, forKey: "rssi")
    }
    
    public init(uuid: String, major: Int, minor: Int, link: String) {
        self.uuid = uuid
        self.major = major
        self.minor = minor
        self.link = link
    }
    
    override public var hashValue: Int {
        get {
            return "\(self.uuid) - \(self.major) - \(self.minor)".hashValue
        }
    }
}

//MARK: - Printable
//extension OHBeacon : CustomStringConvertible {
//
//    override public var description: String {
//        var desc = ""
//        desc += "OpenhabBeacon: {\n"
//        desc += "\tuuid: \(uuid), \n"
//        desc += "\tmajor: \(major), \n"
//        desc += "\tminor: \(minor), \n"
//        desc += "\tproximity: \(proximity)\n"
//        desc += "\trssi: \(rssi)\n"
//        desc += "\tlink: \(link) \n"
//        desc += "}"
//        
//        return desc
//    }
//}

//MARK: - Equatable
public func ==(lhs: OHBeacon, rhs: OHBeacon) -> Bool {
    return lhs.hashValue == rhs.hashValue
}