//
//  CLLocationManager+Extension.swift
//  Home
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 08/08/15.
//  Copyright © 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import CoreLocation

extension CLLocationManager {
    
    /// Starts ranging for beacons in mulitple regions.
    /// - parameter regions: The regions that should be ranged.
    func startRangingBeaconsInRegions(regions: [CLBeaconRegion]) {
        for (_, region) in regions.enumerate() {
            startRangingBeaconsInRegion(region)
        }
    }
    
    func stopRangingBeaconsInRegions(regions: [CLBeaconRegion]) {
        for (_, region) in regions.enumerate() {
            stopRangingBeaconsInRegion(region)
        }
    }
    
    func startMonitoringForRegions(regions: [CLBeaconRegion]) {
        for (_, region) in regions.enumerate() {
            startMonitoringForRegion(region)
        }
    }
    
    func stopMonitoringForRegions(regions: [CLBeaconRegion]) {
        for (_, region) in regions.enumerate() {
            stopMonitoringForRegion(region)
        }
    }
}