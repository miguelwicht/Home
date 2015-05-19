//
//  OHRoomViewController.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 21/04/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import UIKit

class OHRoomsViewController: OHBaseViewController {
    
    var widgets: [OHWidget]?
    var roomSwitcherController: OHDropdownMenuTableViewController?
    var roomSwitchButton: OHDropdownMenuButton?
    var currentRoom: OHRoomViewController?
    
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
        var beacon = OHBeacon(uuid: "85FC11DD-4CCA-4B27-AFB3-876854BB5C3B", major: 0, minor: 0, link: "000")
        var roomWidget = dataManager.beaconWidget![beacon]
        
        switchToRoom(roomWidget!)
//        switchToRoom(self.widgets!.last!)
        
        roomSwitcherController = OHDropdownMenuTableViewController()
        
        if var roomSwitcherController = self.roomSwitcherController {
            roomSwitcherController.data = widgets!
            addChildViewController(roomSwitcherController)
            view.addSubview(roomSwitcherController.view)
            
            roomSwitcherController.view.marginTop = roomSwitchButton!.neededSpaceHeight
            //            roomSwitcherController.view.setHeight(200)
            
            
//            roomSwitcherController.view.backgroundColor = UIColor.redColor()
            roomSwitcherController.view.setHeight(self.view.frame.height - roomSwitchButton!.neededSpaceHeight)
            roomSwitcherController.tableView.backgroundColor = UIColor.redColor()
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
        
        self.roomSwitchButton!.setTitle(room.label, forState: .Normal)
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
}