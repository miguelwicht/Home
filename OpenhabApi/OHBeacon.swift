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

    public var description: String {
        return "OpenhabBeacon: {\n" +
            "\tuuid: \(uuid), \n" +
            "\tmajor: \(major), \n" +
            "\tminor: \(minor), \n" +
            "\tlink: \(link) \n" +
        "}"
    }
}
