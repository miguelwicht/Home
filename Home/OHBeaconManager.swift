//
//  OHBeaconManager.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 18/05/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import UIKit
import CoreLocation

let OHBeaconManagerDidRangeBeaconsNotification = "com.miguelwicht.OHBeaconManagerDidRangeBeaconsNotification"
let OHBeaconManagerDidEnterRegionNotification = "com.miguelwicht.OHBeaconManagerDidEnterRegionNotification"
let OHBeaconManagerDidExitRegionNotification = "com.miguelwicht.OHBeaconManagerDidEnterRegionNotification"
let OHBeaconManagerDidChangeAuthorizationNotification = "com.miguelwicht.OHBeaconManagerDidChangeAuthorizationNotification"

class OHBeaconManager : NSObject {
    
    let locationManager = CLLocationManager()
    var beaconRegions: [CLBeaconRegion]?
    var lastProximity: CLProximity?
    
    var currentBeaconsInRange: [OHBeacon]?
    var regionsToRange: [CLBeaconRegion]?
    var rangedRegions: [CLBeaconRegion]?
    
    var rangingTimer: NSTimer?
    
    var authorizationStatus: CLAuthorizationStatus = CLLocationManager.authorizationStatus() {
        didSet {
            NSNotificationCenter.defaultCenter().postNotificationName(OHBeaconManagerDidChangeAuthorizationNotification, object: nil)
        }
    }

    required override init() {
        super.init()
    }
    
    convenience init(beacons:[OHBeacon]) {
        self.init()
        
        createBeaconRegionsFromBeacons(beacons)
        initLocationManager()
    }
    
    static func getAuthorizationStatus() -> CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    
    func createBeaconRegionsFromBeacons(beacons: [OHBeacon]) {
        
        var regions = [CLBeaconRegion]()
        // regionIdentifiers have to be different for every region!!!
//        let beaconIdentifier = "miguelwicht.com"
        
        for (_, beacon) in beacons.enumerate() {
            let beaconUUID = NSUUID(UUIDString: beacon.uuid)
            
            if let uuid = beaconUUID {
                let beaconRegion: CLBeaconRegion = CLBeaconRegion(proximityUUID: beaconUUID!, identifier: "\(uuid.UUIDString)")
                
                var regionAlreadyAdded = false
                
                for(_, element) in regions.enumerate() {
                    print(element.proximityUUID.UUIDString)
                    if element.proximityUUID.UUIDString == uuid.UUIDString {
                        regionAlreadyAdded = true
                    }
                }
                
                if regionAlreadyAdded == false {
                    regions.append(beaconRegion)
                }
            }
        }
        
        if regions.count > 0 {
            beaconRegions = regions
        }
    }
    
    func initLocationManager() {
        if(locationManager.respondsToSelector("requestAlwaysAuthorization")) {
            locationManager.requestAlwaysAuthorization()
        }
        
        locationManager.delegate = self
        locationManager.pausesLocationUpdatesAutomatically = false
        
        if let beaconRegions = self.beaconRegions {
            locationManager.startMonitoringForRegions(beaconRegions)
            
//            for (i, region) in enumerate(beaconRegions)
//            {
//                locationManager.startMonitoringForRegion(region)
//                locationManager.startRangingBeaconsInRegion(region)
//            }
        }

//        locationManager.startRangingBeaconsInRegion(region)
        locationManager.startUpdatingLocation()
    }
    
    func startRanging() {
        currentBeaconsInRange = [OHBeacon]()
        regionsToRange = self.beaconRegions
        rangedRegions = [CLBeaconRegion]()
        
        if let regions = beaconRegions {
            let interval = NSTimeInterval(5)
            startRangingBeaconsInRegions(regions, forTime: interval)
        }
    }
    
    func startRangingBeaconsInRegions(regions: [CLBeaconRegion], forTime time: NSTimeInterval) {
        print("startRangingBeacons")
        locationManager.startRangingBeaconsInRegions(regions)
        rangingTimer = NSTimer.scheduledTimerWithTimeInterval(time, target: self, selector: Selector("stopRangingBeaconsInRegionsHandler"), userInfo: nil, repeats: false)
    }
    
    func stopRangingBeaconsInRegionsHandler() {
        print("stopRangingBeacons")
        if let regionsToRange = self.regionsToRange {
            locationManager.stopRangingBeaconsInRegions(regionsToRange)
            getNearestRangedBeacon()
        }
    }
    
}

extension CLLocationManager {
    
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

extension OHBeaconManager {
    
    // adds Beacons as OHBeacons to array without adding them mulitple times
    func addBeaconsToList(beacons: [CLBeacon]) {
        for(_, element) in beacons.enumerate() {
            let beacon = OHBeacon(uuid: element.proximityUUID.UUIDString, major: element.major.integerValue, minor: element.minor.integerValue, link: "")
            beacon.proximity = element.proximity.rawValue
            beacon.rssi = element.rssi

            if var _ = self.currentBeaconsInRange {
                if (self.currentBeaconsInRange!).contains(beacon) {
                    let index = (self.currentBeaconsInRange!).indexOf(beacon)
                    
                    if index != nil {
                        if self.currentBeaconsInRange![index!].proximity != CLProximity.Unknown.rawValue {
                            self.currentBeaconsInRange![index!].proximity = beacon.proximity
                            self.currentBeaconsInRange![index!].rssi = beacon.rssi
                        }
                    }
                }
                else {
                    self.currentBeaconsInRange!.append(beacon)
                }
            }
        }
    }
    
    func getNearestRangedBeacon() {
        print("getNearestBeacon")
        var nearestBeacon: OHBeacon?
        
        if let currentBeaconsInRange = self.currentBeaconsInRange {
            for(_, element) in currentBeaconsInRange.enumerate() {
                if let beacon = nearestBeacon {
                    nearestBeacon = (beacon.rssi! >= element.rssi! && beacon.rssi! != 0) ? beacon : element
                }
                else {
                    nearestBeacon = element
                }
            }
            
            if nearestBeacon != nil {
                NSNotificationCenter.defaultCenter().postNotificationName(OHBeaconManagerDidRangeBeaconsNotification, object: nearestBeacon!)
            }
        }
    }
}

extension OHBeaconManager: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
//        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if let beacon = beacons.first {
            addBeaconsToList(beacons)
            
            let beaconOH = OHBeacon(uuid: beacon.proximityUUID.UUIDString, major: beacon.major.integerValue, minor: beacon.minor.integerValue, link: "")
            var room = OHDataManager.sharedInstance.beaconWidget![beaconOH]
        }
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
//        manager.startRangingBeaconsInRegion(region as! CLBeaconRegion)
        manager.startUpdatingLocation()
        
        NSNotificationCenter.defaultCenter().postNotificationName(OHBeaconManagerDidEnterRegionNotification, object: region)
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
//        manager.stopRangingBeaconsInRegion(region as! CLBeaconRegion)
        manager.stopUpdatingLocation()
        
        NSNotificationCenter.defaultCenter().postNotificationName(OHBeaconManagerDidExitRegionNotification, object: region)
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedAlways || status == CLAuthorizationStatus.AuthorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }
    
}
