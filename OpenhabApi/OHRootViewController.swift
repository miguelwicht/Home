//
//  OHStartViewController.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 06/05/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import UIKit

class OHRootViewController: UINavigationController {
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
//        initSettings()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?)
    {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        
        var sitemaps = OHDataManager.sharedInstance.sitemaps!
        var startIndex = sitemaps.startIndex
        
        if var menuViewController = revealViewController().rearViewController as? OHRearMenuViewController {
            menuViewController.updateMenu()
        }
        var sitemap = sitemaps[startIndex].1
        sitemap = OHDataManager.sharedInstance.currentSitemap!
        pushViewControllerWithSitemap(sitemap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
}

extension OHRootViewController {
    
    func initSettings()
    {
        var settingsVC = OHSettingsViewController()
        self.presentViewController(settingsVC, animated: true, completion: nil)
    }
    
    func pushViewControllerWithSitemap(sitemap: OHSitemap)
    {
        var vc: OHRoomsViewController = OHRoomsViewController(sitemap: sitemap)
        vc.title = sitemap.label
        
        self.pushViewController(vc, animated: true)
        
//        var roomsInSitemap = sitemap.roomsInSitemap()
//        
//        if var rooms = roomsInSitemap {
//            var vc: OHRoomsViewController = OHRoomsViewController(sitemap: sitemap)
//            vc.title = sitemap.label
//            
//            self.pushViewController(vc, animated: true)
//        }
    }
}

extension OHRootViewController {
    
    func initBeacons(sitemap: OHSitemap) {
        
    }
}
