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
        
        println(self.widgets!.count)
        
        println(self.widgets!.first?.label)
        
        switchToRoom(self.widgets!.first!)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    func switchToRoom(room: OHWidget)
    {
        var offsetY = self.navigationController!.navigationBar.neededSpaceHeight + 60
        var height = self.view.frame.height - offsetY
        
        var roomVC: OHRoomViewController = OHRoomViewController(widget: room, frame: CGRectMake(0, offsetY, self.view.frame.width, height))
        self.addChildViewController(roomVC)
        
        self.view.addSubview(roomVC.view)
    }
    
}