//
//  OHDataManager.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 06/05/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import Foundation

class OHDataManager : NSObject {
    var sitemaps: [OHSitemap]?
    var beacons: [OHBeacon]?
    var beaconWidget: [OHBeacon: OHWidget]?
}