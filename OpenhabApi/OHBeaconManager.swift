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

class OHBeaconManager : NSObject {
    
    let locationManager = CLLocationManager()
    var beaconRegions: [CLBeaconRegion]?
    var lastProximity: CLProximity?

    required override init() {
        super.init()
    }
    
    convenience init(beacons:[OHBeacon]) {
        self.init()
        
        createBeaconRegionsFromBeacons(beacons)
        initLocationManager()
    }
    
    func createBeaconRegionsFromBeacons(beacons: [OHBeacon]) {
        
        var regions = [CLBeaconRegion]()
        let beaconIdentifier = "miguelwicht.com"
        
        for (index, beacon) in enumerate(beacons) {
            var beaconUUID = NSUUID(UUIDString: beacon.uuid)
            
            if var uuid = beaconUUID {
                var beaconRegion: CLBeaconRegion = CLBeaconRegion(proximityUUID: beaconUUID, identifier: beaconIdentifier)
                
                var regionAlreadyAdded = false
                
                for(i, element) in enumerate(regions)
                {
                    println(element.proximityUUID.UUIDString)
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
    
    func initLocationManager()
    {
        if(locationManager.respondsToSelector("requestAlwaysAuthorization"))
        {
            locationManager.requestAlwaysAuthorization()
        }
        locationManager.delegate = self
        locationManager.pausesLocationUpdatesAutomatically = false
        
        if var beaconRegions = self.beaconRegions {
        
            for (i, region) in enumerate(beaconRegions)
            {
                locationManager.startMonitoringForRegion(region)
                locationManager.startRangingBeaconsInRegion(region)
            }
        }

//        locationManager.startRangingBeaconsInRegion(region)
        locationManager.startUpdatingLocation()
    }
    
    func startRanging() {
        if var regions = beaconRegions {
            for (i, region) in enumerate(regions)
            {
                locationManager.startRangingBeaconsInRegion(region)
            }
        }
    }
    
}

extension OHBeaconManager: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!)
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var dataManager = appDelegate.dataManager
        
        if var beacon = beacons.first as? CLBeacon {
            
            var beaconOH = OHBeacon(uuid: beacon.proximityUUID.UUIDString, major: beacon.major.integerValue, minor: beacon.minor.integerValue, link: "")
            var room = dataManager.beaconWidget![beaconOH]
        
            locationManager.stopRangingBeaconsInRegion(region)
            // TODO: use wrapper object to send beacons and region
            NSNotificationCenter.defaultCenter().postNotificationName(OHBeaconManagerDidRangeBeaconsNotification, object: beacon)
        }
        
        locationManager.stopRangingBeaconsInRegion(region)
    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        manager.startRangingBeaconsInRegion(region as! CLBeaconRegion)
        manager.startUpdatingLocation()
        
        NSNotificationCenter.defaultCenter().postNotificationName(OHBeaconManagerDidEnterRegionNotification, object: region)
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        manager.stopRangingBeaconsInRegion(region as! CLBeaconRegion)
        manager.stopUpdatingLocation()
        
        NSNotificationCenter.defaultCenter().postNotificationName(OHBeaconManagerDidExitRegionNotification, object: region)
    }
    
}
