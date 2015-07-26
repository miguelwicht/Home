//
//  OHStartViewController.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 06/05/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import UIKit

class OHRootViewController: UINavigationController {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        
        var sitemaps = OHDataManager.sharedInstance.sitemaps!
        let startIndex = sitemaps.startIndex
        
        if let menuViewController = revealViewController().rearViewController as? OHRearMenuViewController {
            menuViewController.updateMenu()
        }
        
        var sitemap = sitemaps[startIndex].1
        sitemap = OHDataManager.sharedInstance.currentSitemap!
        pushViewControllerWithSitemap(sitemap)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "sitemapDidChangeHandler", name: "OHDataManagerCurrentSitemapDidChangeNotification", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

extension OHRootViewController {
    
    func sitemapDidChangeHandler() {
        if let currentSitemap = OHDataManager.sharedInstance.currentSitemap {
            self.popToRootViewControllerAnimated(false)
            self.pushViewControllerWithSitemap(currentSitemap)
            
            if let menuViewController = revealViewController().rearViewController as? OHRearMenuViewController {
                menuViewController.updateMenu()
            }
            
            revealViewController().revealToggle(self)
        }
    }
    
    func initSettings() {
        let settingsVC = OHSettingsViewController()
        self.presentViewController(settingsVC, animated: true, completion: nil)
    }
    
    func pushViewControllerWithSitemap(sitemap: OHSitemap) {
        let vc: OHRoomsViewController = OHRoomsViewController(sitemap: sitemap)
        vc.title = sitemap.label
        self.pushViewController(vc, animated: false)
    }
}

extension OHRootViewController {
    
    func initBeacons(sitemap: OHSitemap) {
        
    }
}
