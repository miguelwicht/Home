//
//  OHBaseViewController.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 14/05/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import UIKit

class OHBaseViewController: UIViewController {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    var loadingView = OHLoadingView()
    var notification: MDWNotificationController?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nil, bundle: nil)
        
        initNavigationBar()
        addRestObserver()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initNavigationBar()
        addRestObserver()
    }
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor.whiteColor()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension OHBaseViewController {
    
    func addLoadingView() {
        if var window = view.window {
            window.addSubview(loadingView)
            loadingView.frame = self.view.frame
        }
    }
    
    func removeLoadingView() {
        loadingView.removeFromSuperview()
    }
}

extension OHBaseViewController: UIScrollViewDelegate {
    
    func initScrollView() {
        scrollView.delegate = self
        scrollView.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.setTranslatesAutoresizingMaskIntoConstraints(false)
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
        
        addScrollViewConstraints()
    }
    
    func addScrollViewConstraints() {
        var views = [String: AnyObject]()
        views["scrollView"] = scrollView
        views["contentView"] = contentView
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(0)-[scrollView]-(0)-|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[scrollView]-(0)-|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(0)-[contentView]-(0)-|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[contentView]-(0)-|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: views))
        self.view.addConstraint(NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0))
    }
}

extension OHBaseViewController {
    
    func initNavigationBar() {
        addLeftNavigationBarItems()
        addRightNavigationBarItems()
    }
    
    func addLeftNavigationBarItems() {
        let revealController = self.revealViewController
        var menuItemButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        
        menuItemButton.setImage(UIImage(named: "menu")?.imageWithRenderingMode(.AlwaysTemplate), forState: UIControlState.Normal)
        menuItemButton.sizeToFit()
        
        var item = UIBarButtonItem(customView: menuItemButton as UIView)
        self.navigationItem.leftBarButtonItems = [item]
        
        menuItemButton.setWidth(40)
        menuItemButton.setHeight(40)
        menuItemButton.imageView!.setWidth(40)
        menuItemButton.imageView!.setHeight(40)
        menuItemButton.imageView!.contentMode = UIViewContentMode.ScaleAspectFit
        
        menuItemButton.addTarget(revealController(), action: "revealToggle:", forControlEvents: UIControlEvents.TouchUpInside)
        menuItemButton.addTarget(self, action: "toggleStatusBar", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func toggleStatusBar() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var statusBar = appDelegate.statusBarBackgroundView
        statusBar!.highlighted = statusBar!.highlighted ? false : true
    }
    
    func addRightNavigationBarItems() {}
}

extension OHBaseViewController {
    func showMessage(message: String?) {
        
        if var notification = self.notification {
            notification.removeNotification()
            self.notification = nil
        }
        
        if var visibleViewController = self.navigationController?.visibleViewController {
            if  visibleViewController == self {
                
                self.notification = MDWNotificationController()
                
                if var notification = self.notification {
                
                    addChildViewController(notification)
                    if var notificationMessage = message {
                        notification.setMessage(notificationMessage)
                    }
                    notification.type = MDWNotificationType.Error
                
                    notification.addNotificationToView(view)
                }
            }
        }
    }
    
    func restErrorHandler(notification: NSNotification)
    {
        let userInfo:Dictionary<String,String!> = notification.userInfo as! Dictionary<String,String!>
    
        if var error = userInfo["error"] {
            showMessage(error)
        } else {
            showMessage("An error occured. Please check your settings.")
        }
    }
    
    func addRestObserver() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "restErrorHandler:", name: OHRestManagerConnectionDidFailNotification, object: nil)
    }
}