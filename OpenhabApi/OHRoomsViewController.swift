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
    //MARK: - Properties
    var sitemap: OHSitemap?
    var rooms: [OHWidget]?
    var roomSwitcherController: OHDropdownMenuTableViewController?
    var currentRoom: OHRoomViewController?
    var isWaitingForBeacons: Bool = true
    var panGestureRecognizer: UIGestureRecognizer?
    
    var determineLocationButton: UIButton?
    
    //MARK: - Initializers
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(sitemap: OHSitemap) {
        self.init(nibName: nil, bundle: nil)
        
        self.sitemap = sitemap
        rooms = sitemap.roomsInSitemap()
        initNotificationCenterNotifications()
        addDropdownToNavigationBar()
    }
    
    override func loadView() {
        super.loadView()
        
        self.automaticallyAdjustsScrollViewInsets = true
        var dataManager = OHDataManager.sharedInstance
        
        if var sitemap = OHDataManager.sharedInstance.currentSitemap {
            rooms = sitemap.roomsInSitemap()
            switchToRoom(rooms!.first!)
            initRoomSwitcherController()
        }
        
        addObservers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if var revealViewController = revealViewController() {
            panGestureRecognizer = revealViewController.panGestureRecognizer()
            if let panGestureRecognizer = self.panGestureRecognizer {
                self.view.addGestureRecognizer(panGestureRecognizer)
            }
        }
    }
    
    func addObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "authorizationDidChangeHandler", name: OHBeaconManagerDidChangeAuthorizationNotification, object: nil)
    }
    
    func removeObservers() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func authorizationDidChangeHandler() {
        let authStatus = OHBeaconManager.getAuthorizationStatus()
        
        if  authStatus == CLAuthorizationStatus.AuthorizedAlways || authStatus == CLAuthorizationStatus.AuthorizedWhenInUse {
            determineLocationButton?.hidden = false
        } else {
            determineLocationButton?.hidden = true
        }
    }
    
    deinit {
        if let panGestureRecognizer = self.panGestureRecognizer {
            self.view.removeGestureRecognizer(panGestureRecognizer)
        }
        
        removeObservers()
    }
}

//MARK: - RoomSwitcher
extension OHRoomsViewController {
    
    func initRoomSwitcherController() {
        roomSwitcherController = OHDropdownMenuTableViewController()
        
        if var roomSwitcherController = self.roomSwitcherController {
            roomSwitcherController.data = rooms!
            addChildViewController(roomSwitcherController)
            view.addSubview(roomSwitcherController.view)
            
            roomSwitcherController.tableView.delegate = self
            
            var views = [String: AnyObject]()
            views["roomSwticher"] = roomSwitcherController.view
            
            self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(0)-[roomSwticher]-(0)-|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: views))
            self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[roomSwticher]-(0)-|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: views))
        }
        
        toggleDropdownMenu(self.navigationItem.titleView as! UIButton)
    }
    
    func toggleDropdownMenu(control: UIButton) {
        if var roomSwitcherController = self.roomSwitcherController {
            roomSwitcherController.view.hidden = !roomSwitcherController.view.hidden
        }
    }
    
    func switchToRoom(room: OHWidget) {
        if var roomSwitcherController = self.roomSwitcherController {
            roomSwitcherController.view.hidden = true
        }
        
        if var button = self.navigationItem.titleView as? UIButton {
            button.setTitle(room.label?.uppercaseString, forState: .Normal)
        }
        
        var offsetY = CGFloat(0)
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

//MARK: - UITableViewDelegate
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

//MARK: - Beacon Notification Handler
extension OHRoomsViewController {
    
    func initNotificationCenterNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didRangeBeaconsNotificationHandler:", name: OHBeaconManagerDidRangeBeaconsNotification, object: nil)
    }
    
    func didRangeBeaconsNotificationHandler(notification: NSNotification?) {
        var beaconButton = self.navigationItem.rightBarButtonItem?.customView as! UIButton
        beaconButton.imageView!.stopAnimating()
        
        if isWaitingForBeacons {
        
            if var beaconOH = notification!.object as? OHBeacon {
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                var navController = self.navigationController as! OHRootViewController
                var roomWidget = OHDataManager.sharedInstance.beaconWidget![beaconOH]
                
                if var room = roomWidget {
                    switchToRoom(room)
                } else {
                    println("room not found")
                }
            }
            
            if var beaconCL = notification!.object as? CLBeacon {
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                var navController = self.navigationController as! OHRootViewController
                var beacon = OHBeacon(uuid: beaconCL.proximityUUID.UUIDString, major: beaconCL.major.integerValue, minor: beaconCL.minor.integerValue, link: "000")
                var roomWidget = OHDataManager.sharedInstance.beaconWidget![beacon]
                
                if var room = roomWidget {
                    println("room found")
                    switchToRoom(room)
                } else {
                    println("room not found")
                }
            }
        } else {
            println("not wating for beacons")
        }
    }
    
    func startDetectingRoom(button: UIButton) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var beaconManager = appDelegate.beaconManager
        
        beaconManager?.startRanging()
        button.imageView!.startAnimating()
    }
}

//MARK: - Configurate NavigationBar
extension OHRoomsViewController {
    
    override func addRightNavigationBarItems() {
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
        
        determineLocationButton = menuItemButton
        
        authorizationDidChangeHandler()
    }
    
    func addDropdownToNavigationBar() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var button = UIButton.buttonWithType(.Custom) as! UIButton
        button.setWidth(appDelegate.window!.frame.width - 100)
        button.setTitle("Button", forState: .Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.titleLabel?.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        self.navigationItem.titleView = button
        self.navigationItem.titleView?.sizeToFit()
        button.addTarget(self, action: "toggleDropdownMenu:", forControlEvents: UIControlEvents.TouchUpInside)
    }
}
