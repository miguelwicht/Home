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
    
    convenience init(beacons:[OHBeacon])
    {
        self.init()
        createBeaconRegionsFromBeacons(beacons)
        initLocationManager()
        initNotifications()
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
    
    func initNotifications() {
        var application = UIApplication.sharedApplication()
        
        if(application.respondsToSelector("registerUserNotificationSettings:"))
        {
            application.registerUserNotificationSettings(
                UIUserNotificationSettings(
                    forTypes: UIUserNotificationType.Alert | UIUserNotificationType.Sound,
                    categories: nil
                )
            );
        }

    }
    
    func startRanging() {
        if var regions = beaconRegions {
            for (i, region) in enumerate(regions)
            {
                locationManager.startRangingBeaconsInRegion(region)
            }
        }
    }
    
//    func setupBeaconsForApplication(application: UIApplication)
//    {
//        let uuidString = "85FC11DD-4CCA-4B27-AFB3-876854BB5C3B"
//        let beaconIdentifier = "miguelwicht.com"
//        //let beaconUUID:NSUUID = NSUUID(UUIDString: "5FC11DD-4CCA-4B27-AFB3-876854BB5C3B");
//        
//        let beaconUUID:NSUUID = NSUUID(UUIDString: uuidString)!
//        let beaconRegion: CLBeaconRegion = CLBeaconRegion(proximityUUID: beaconUUID, identifier: beaconIdentifier)
//        
//        
//        NSLog("blub1")
//
//        if(locationManager.respondsToSelector("requestAlwaysAuthorization"))
//        {
//            NSLog("blub")
//            locationManager.requestAlwaysAuthorization()
//        }
//        locationManager.delegate = self
//        locationManager.pausesLocationUpdatesAutomatically = false
//        
//        locationManager.startMonitoringForRegion(beaconRegion)
//        locationManager.startRangingBeaconsInRegion(beaconRegion)
//        locationManager.startUpdatingLocation()
//        
////        var application = UIApplication.sharedApplication()
////        
////        if(application.respondsToSelector("registerUserNotificationSettings:"))
////        {
////            application.registerUserNotificationSettings(
////                UIUserNotificationSettings(
////                    forTypes: UIUserNotificationType.Alert | UIUserNotificationType.Sound,
////                    categories: nil
////                )
////            );
////        }
//    }
}

extension OHBeaconManager {
    
    func sendLocalNotificationWithMessage(message: String!) {
        let notification:UILocalNotification = UILocalNotification()
        notification.alertBody = message
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
}

extension OHBeaconManager: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!)
    {
//        let viewController:ViewController = window!.rootViewController as! ViewController
//        viewController.beacons = beacons as! [CLBeacon]!
        //        viewController.tableView.reloadData()
        
        NSLog("didRangeBeacons: \(beacons.count), region: \(region.proximityUUID.UUIDString)");
        var message:String = "";
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var dataManager = appDelegate.dataManager
        
        
        if var beacon = beacons.first as? CLBeacon {
                
//            beacon = beacon as! CLBeacon
//            as! CLBeacon
                var beaconOH = OHBeacon(uuid: beacon.proximityUUID.UUIDString, major: beacon.major.integerValue, minor: beacon.minor.integerValue, link: "")
                var room = dataManager.beaconWidget![beaconOH]
        
//        if(beacons.count > 0)
//        {
//            let nearestBeacon:CLBeacon = beacons[0] as! CLBeacon;
//            
//            
//            if(nearestBeacon.proximity == lastProximity || nearestBeacon.proximity == CLProximity.Unknown)
//            {
//                return;
//            }
//            lastProximity = nearestBeacon.proximity;
//            
//            switch nearestBeacon.proximity
//            {
//            case CLProximity.Far:
//                message = "You are far away from the beacon";
//                
//            case CLProximity.Near:
//                message = "You are near the beacon";
//                
//            case CLProximity.Immediate:
//                message = "You are in the immediate proximity of the beacon";
//                
//            case CLProximity.Unknown:
//                return
//            }
//        }
//        else
//        {
//            message = "No beacons found";
//        }
        
        println("\(message)")
        sendLocalNotificationWithMessage(message)
        
        locationManager.stopRangingBeaconsInRegion(region)
        // TODO: use wrapper object to send beacons and region
        

            NSNotificationCenter.defaultCenter().postNotificationName(OHBeaconManagerDidRangeBeaconsNotification, object: beacon)


        }
        
        locationManager.stopRangingBeaconsInRegion(region)
    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        manager.startRangingBeaconsInRegion(region as! CLBeaconRegion)
        manager.startUpdatingLocation()
        
        println("You entered a region: ")
        sendLocalNotificationWithMessage("You entered a region")
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        manager.stopRangingBeaconsInRegion(region as! CLBeaconRegion)
        manager.stopUpdatingLocation()
        
        NSLog("You exited the region")
        sendLocalNotificationWithMessage("You exited the region")
    }
    
}
