//
//  OHBeacon.swift
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 13/04/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import Foundation

@objc public class OHBeacon {
    
    public let uuid: String
    public let major: NSInteger
    public let minor: NSInteger
    public let link: String
    
    public init(uuid: String, major: NSInteger, minor: NSInteger, link: String){
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