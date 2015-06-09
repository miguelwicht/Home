//
//  OHBeacon.swift
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 13/04/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import Foundation

@objc public class OHBeacon {
    
    public let uuid: String
    public let major: Int
    public let minor: Int
    public let link: String
    public var proximity: Int?
    public var rssi: Int?
    
    public init(uuid: String, major: Int, minor: Int, link: String) {
        self.uuid = uuid
        self.major = major
        self.minor = minor
        self.link = link
    }
}

//MARK: OHBeacon: Printable
extension OHBeacon : Printable {

    public var description: String
    {
        var desc = ""
        desc += "OpenhabBeacon: {\n"
        desc += "\tuuid: \(uuid), \n"
        desc += "\tmajor: \(major), \n"
        desc += "\tminor: \(minor), \n"
        desc += "\tproximity: \(proximity)\n"
        desc += "\trssi: \(rssi)\n"
        desc += "\tlink: \(link) \n"
        desc += "}"
        
        return desc
    }
}

//MARK: OHBeacon: Hashable
extension OHBeacon: Hashable {
    public var hashValue: Int {
        get {
            return "\(self.uuid) - \(self.major) - \(self.minor)".hashValue
        }
    }
}

//MARK: OHBeacon: Equatable
public func ==(lhs: OHBeacon, rhs: OHBeacon) -> Bool {
    return lhs.hashValue == rhs.hashValue
}