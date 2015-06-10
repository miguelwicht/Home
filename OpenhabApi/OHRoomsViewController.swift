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
    //MARK: Properties
    var widgets: [OHWidget]?
    var roomSwitcherController: OHDropdownMenuTableViewController?
    var currentRoom: OHRoomViewController?
    var isWaitingForBeacons: Bool = true
    
    //MARK: Initializers
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
        addDropdownToNavigationBar()
    }
    
    override func loadView()
    {
        super.loadView()
        
        self.automaticallyAdjustsScrollViewInsets = false

        switchToRoom(self.widgets!.first!)
        initRoomSwitcherController()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
}

extension OHRoomsViewController {
    
    func initRoomSwitcherController()
    {
        roomSwitcherController = OHDropdownMenuTableViewController()
        
        if var roomSwitcherController = self.roomSwitcherController {
            roomSwitcherController.data = widgets!
            addChildViewController(roomSwitcherController)
            view.addSubview(roomSwitcherController.view)
            
            roomSwitcherController.view.marginTop = self.navigationController!.navigationBar.neededSpaceHeight
            roomSwitcherController.view.setHeight(CGFloat(self.view.frame.height - self.navigationController!.navigationBar.neededSpaceHeight))
            roomSwitcherController.tableView.delegate = self
        }
        
        toggleDropdownMenu(self.navigationItem.titleView as! UIButton)
    }
    
    func toggleDropdownMenu(control: UIButton)
    {
        if var roomSwitcherController = self.roomSwitcherController {
            roomSwitcherController.view.hidden = !roomSwitcherController.view.hidden
        }
    }
    
    func switchToRoom(room: OHWidget)
    {
        
        if var roomSwitcherController = self.roomSwitcherController {
            roomSwitcherController.view.hidden = true
        }
        
        if var button = self.navigationItem.titleView as? UIButton {
            button.setTitle(room.label?.uppercaseString, forState: .Normal)
        }
        var offsetY = self.navigationController!.navigationBar.neededSpaceHeight
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
    }
}

//MARK: UITableViewDelegate
extension OHRoomsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switchToRoom(roomSwitcherController!.data[indexPath.row] as! OHWidget)
    }
    
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
        return 145
    }
}

//MARK: Beacon Notification Handler
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
//                var dataManager = appDelegate.dataManager
                
                var navController = self.navigationController as! OHRootViewController
                var roomWidget = OHDataManager.sharedInstance.beaconWidget![beaconOH]
                
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
//                var dataManager = appDelegate.dataManager
            
                var navController = self.navigationController as! OHRootViewController
                var beacon = OHBeacon(uuid: beaconCL.proximityUUID.UUIDString, major: beaconCL.major.integerValue, minor: beaconCL.minor.integerValue, link: "000")
                var roomWidget = OHDataManager.sharedInstance.beaconWidget![beacon]
                
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
    
    func startDetectingRoom(button: UIButton)
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var beaconManager = appDelegate.beaconManager
        
        beaconManager?.startRanging()
        button.imageView!.startAnimating()
    }
}

//MARK: Configurate NavigationBar
extension OHRoomsViewController {
    
    override func addRightNavigationBarItems()
    {
        var menuItemButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        
        menuItemButton.setImage(UIImage(named: "beacon_state_3"), forState: UIControlState.Normal)
        var imageList = [UIImage]()
        
        for i in 0...3 {
            imageList.append(UIImage(named: "beacon_state_\(i)")!)
        }
        
        if var imageView = menuItemButton.imageView {
            imageView.animationImages = imageList
            imageView.animationDuration = 2.0
        }
        
        menuItemButton.sizeToFit()
        
        var item = UIBarButtonItem(customView: menuItemButton as UIView)
        self.navigationItem.rightBarButtonItem = item
        
        menuItemButton.setWidth(40)
        menuItemButton.setHeight(40)
        menuItemButton.imageView!.setWidth(40)
        menuItemButton.imageView!.setHeight(40)
        menuItemButton.imageView!.contentMode = UIViewContentMode.ScaleAspectFit
        menuItemButton.addTarget(self, action: "startDetectingRoom:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func addDropdownToNavigationBar()
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var button = UIButton.buttonWithType(.Custom) as! UIButton
        button.setWidth(appDelegate.window!.frame.width - 100)
        button.setTitle("Button", forState: .Normal)
        self.navigationItem.titleView = button
        self.navigationItem.titleView?.sizeToFit()
        button.addTarget(self, action: "toggleDropdownMenu:", forControlEvents: UIControlEvents.TouchUpInside)
    }
}
