//
//  OHBaseViewController.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 14/05/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import UIKit

class OHBaseViewController: UIViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?)
    {
        super.init(nibName: nil, bundle: nil)
        
        initNavigationBar()
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        initNavigationBar()
    }
    
    override func loadView()
    {
        super.loadView()
        
        self.view.backgroundColor = UIColor.whiteColor()
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension OHBaseViewController {
    
    func initNavigationBar()
    {
        addLeftNavigationBarItems()
        addRightNavigationBarItems()
    }
    
    func addLeftNavigationBarItems()
    {
//        var menuItemImage = UIImageView(image: UIImage(named: "menu"))
//        var item = UIBarButtonItem(customView: menuItemImage)
//        self.navigationItem.leftBarButtonItem = item
//        
//        let revealController = self.revealViewController
//        item.target = revealController()
//        item.action = "revealToggle:"
        
        
        
        let revealController = self.revealViewController
        var menuItemButton = UIButton.buttonWithType(UIButtonType.Custom)
        
        menuItemButton.setImage(UIImage(named: "menu"), forState: UIControlState.Normal)
        menuItemButton.sizeToFit()
        
        println(menuItemButton.frame)
        
        var item = UIBarButtonItem(customView: menuItemButton as! UIView)
        self.navigationItem.leftBarButtonItem = item
        
        //        menuItemButton.addTarget(self, action: "startDetecting")
        menuItemButton.addTarget(revealController(), action: "revealToggle:", forControlEvents: UIControlEvents.TouchUpInside)
        menuItemButton.addTarget(self, action: "toggleStatusBar", forControlEvents: UIControlEvents.TouchUpInside)
//        [revealController panGestureRecognizer];
//        [revealController tapGestureRecognizer];
        
//        UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
//            style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
//        
//        self.navigationItem.leftBarButtonItem = revealButtonItem;

    }
    
    func toggleStatusBar()
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var statusBar = appDelegate.statusBarBackgroundView
        statusBar!.highlighted = statusBar!.highlighted ? false : true
    }
    
    func addRightNavigationBarItems()
    {
    
    }
}