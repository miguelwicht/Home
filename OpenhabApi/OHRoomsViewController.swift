//
//  OHRoomViewController.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 21/04/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import UIKit
import CoreLocation

class OHRoomsViewController: OHBaseViewController {
    
    var widgets: [OHWidget]?
    var roomSwitcherController: OHDropdownMenuTableViewController?
    var roomSwitchButton: OHDropdownMenuButton?
    var currentRoom: OHRoomViewController?
    
    var isWaitingForBeacons: Bool = true
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    convenience init(widgets: [OHWidget])
    {
        self.init(nibName: nil, bundle: nil)
        
        self.widgets = widgets
        
        initNotificationCenterNotifications()
    }
    
    override func loadView()
    {
        super.loadView()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        roomSwitchButton = OHDropdownMenuButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 90))
        self.view.addSubview(roomSwitchButton!)
        
        roomSwitchButton!.marginTop = 60
        roomSwitchButton!.setTitle("Living Room", forState: .Normal)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var dataManager = appDelegate.dataManager
        
        var navController = self.navigationController as! OHRootViewController
//        var beacon = OHBeacon(uuid: "D0D3FA86-CA76-45EC-9BD9-6AF4CFE974E5", major: 21355, minor: 51154, link: "000")
//        var beacon = OHBeacon(uuid: "D0D3FA86-CA76-45EC-9BD9-6AF4CBD6EA98", major: 21622, minor: 8451, link: "000")
//        var roomWidget = dataManager.beaconWidget![beacon]
//        
//        switchToRoom(roomWidget!)
        switchToRoom(self.widgets!.first!)
        
        roomSwitcherController = OHDropdownMenuTableViewController()
        
        if var roomSwitcherController = self.roomSwitcherController {
            roomSwitcherController.data = widgets!
            addChildViewController(roomSwitcherController)
            view.addSubview(roomSwitcherController.view)
            
            roomSwitcherController.view.marginTop = roomSwitchButton!.neededSpaceHeight
            //            roomSwitcherController.view.setHeight(200)
            
            
//            roomSwitcherController.view.backgroundColor = UIColor.redColor()
            roomSwitcherController.view.setHeight(self.view.frame.height - roomSwitchButton!.neededSpaceHeight)
//            roomSwitcherController.tableView.backgroundColor = UIColor.redColor()
//            roomSwitcherController.tableView.sizeToFit()
            roomSwitcherController.tableView.delegate = self
        }
        
        roomSwitchButton!.addTarget(self, action: "toggleDropdownMenu:", forControlEvents: UIControlEvents.TouchUpInside)
        toggleDropdownMenu(roomSwitchButton!)
    }
    
    func toggleDropdownMenu(control: OHDropdownMenuButton)
    {
       
        if self.roomSwitcherController!.view.hidden {
            self.roomSwitcherController!.view.hidden = false
        }
        else {
            self.roomSwitcherController!.view.hidden = true
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    func switchToRoom(room: OHWidget)
    {
        
        if var roomSwitcherController = self.roomSwitcherController {
            roomSwitcherController.view.hidden = true
        }
        
        self.roomSwitchButton!.setTitle(room.label?.uppercaseString, forState: .Normal)
        var offsetY = self.navigationController!.navigationBar.neededSpaceHeight + 90
        var height = self.view.frame.height - offsetY
        
        if var currentRoom = self.currentRoom {
            currentRoom.removeFromParentViewController()
            currentRoom.view.removeFromSuperview()
            self.currentRoom = nil
        }
        
        var roomVC: OHRoomViewController = OHRoomViewController(widget: room, frame: CGRectMake(0, offsetY, self.view.frame.width, height))
        
        currentRoom = roomVC
        self.addChildViewController(roomVC)
        
        self.view.insertSubview(roomVC.view, atIndex: 0)
//        roomVC.view.centerViewHorizontallyInSuperview()
    }
    
}

extension OHRoomsViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        roomSwitchButton?.setTitle(roomSwitcherController?.data[indexPath.row].label, forState: .Normal)
        switchToRoom(roomSwitcherController!.data[indexPath.row])
    }
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 30
//    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if cell.respondsToSelector("setSeparatorInset:") {
            cell.separatorInset = UIEdgeInsetsZero
        }
        
        if cell.respondsToSelector("setPreservesSuperviewLayoutMargins:") {
            cell.preservesSuperviewLayoutMargins = false
        }
        
        if cell.respondsToSelector("setLayoutMargins:") {
            cell.layoutMargins = UIEdgeInsetsZero
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
}

extension OHRoomsViewController {
    
    func initNotificationCenterNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didRangeBeaconsNotificationHandler:", name: OHBeaconManagerDidRangeBeaconsNotification, object: nil)
    }
    
    func didRangeBeaconsNotificationHandler(notification: NSNotification?)
    {
        
        println(notification?.object)
        
        var beaconButton = self.navigationItem.rightBarButtonItem?.customView as! UIButton
        beaconButton.imageView!.stopAnimating()
        
        if isWaitingForBeacons {
        
            if var beaconOH = notification!.object as? OHBeacon {
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                var dataManager = appDelegate.dataManager
                
                var navController = self.navigationController as! OHRootViewController
//                var beacon = OHBeacon(uuid: beaconCL.proximityUUID.UUIDString, major: beaconCL.major.integerValue, minor: beaconCL.minor.integerValue, link: "000")
                var roomWidget = dataManager.beaconWidget![beaconOH]
                
                if var room = roomWidget {
                    println("room found: \(room)")
                    switchToRoom(room)
                }
                else {
                    println("room not found")
                }
            }
            
            
            if var beaconCL = notification!.object as? CLBeacon {
        
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                var dataManager = appDelegate.dataManager
            
                var navController = self.navigationController as! OHRootViewController
                var beacon = OHBeacon(uuid: beaconCL.proximityUUID.UUIDString, major: beaconCL.major.integerValue, minor: beaconCL.minor.integerValue, link: "000")
                var roomWidget = dataManager.beaconWidget![beacon]
                
                if var room = roomWidget {
                    println("room found")
                    switchToRoom(room)
                }
                else {
                    println("room not found")
                }
            }
        }
        else
        {
            println("not wating for beacons")
        }
    }
    
    func startDetectingRoom(button: UIButton){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var beaconManager = appDelegate.beaconManager
        
        beaconManager?.startRanging()
        button.imageView!.startAnimating()
    }
}

extension OHRoomsViewController {
    override func addRightNavigationBarItems() {
        var menuItemImage = UIImageView(image: UIImage(named: "menu"))
        
        var menuItemButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
//        menuItemButton.backgroundColor = UIColor.purpleColor()
        
        
        menuItemButton.setImage(UIImage(named: "beacon_state_3"), forState: UIControlState.Normal)
        var imageList = [UIImage]()
        
        for i in 0...3 {
            imageList.append(UIImage(named: "beacon_state_\(i)")!)
        }
        
        if var imageView = menuItemButton.imageView {
            imageView.animationImages = imageList
            imageView.animationDuration = 2.0
//            imageView.startAnimating()
        }
        
        
        menuItemButton.sizeToFit()
        
        println(menuItemButton.frame)
        
        var item = UIBarButtonItem(customView: menuItemButton as! UIView)
        self.navigationItem.rightBarButtonItem = item
        
        menuItemButton.setWidth(40)
        menuItemButton.setHeight(40)
        menuItemButton.imageView!.setWidth(40)
        menuItemButton.imageView!.setHeight(40)
        menuItemButton.imageView!.contentMode = UIViewContentMode.ScaleAspectFit
//        menuItemButton.imageView!.backgroundColor = UIColor.redColor()
        
//        menuItemButton.addTarget(self, action: "startDetecting")
        menuItemButton.addTarget(self, action: "startDetectingRoom:", forControlEvents: UIControlEvents.TouchUpInside)
    }
}