//
//  OHStartViewController.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 06/05/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import UIKit

class OHRootViewController: UINavigationController {
    
    var dataManager: OHDataManager?
    var restManager: OHRestManager?
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        initManagers()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?)
    {
        super.init(nibName: nil, bundle: nil)
        initManagers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension OHRootViewController {
    
    func initManagers()
    {
        dataManager = OHDataManager()
        restManager = OHRestManager(baseUrl: "http://192.168.0.251:8888")
        
        if var restManager = self.restManager {
            restManager.delegate = self
        }
        
        loadDefaultViewController()
    }
    
    func loadDefaultViewController()
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let sitemap = defaults.objectForKey("SettingsOpenHABSitemap") as? String {
            self.restManager?.getSitemap(sitemap)
            println("GetSitemap: \(sitemap)")
        } else {
            println("no sitemap")
        }
    }
    
    func pushViewControllerWithSitemap(sitemap: OHSitemap)
    {
        var homepage = sitemap.homepage!
        
        var widget: OHWidget?
        
        for (i, e) in enumerate(homepage.widgets!)
        {
            widget = e
        }
        
        var widgets = widget!.widgets
        
        var vc: OHRoomsViewController = OHRoomsViewController(widgets: widgets!)
        vc.title = sitemap.label
        
        self.pushViewController(vc, animated: true)
    }
}

//MARK: OHRestManagerDelegate
extension OHRootViewController: OHRestManagerDelegate
{
    func didGetItems(items: [JSON]) {
        println(items)
    }
    
    func didGetBeacons(beacons: [OHBeacon]) {
        self.dataManager!.beacons = beacons
    }
    
    func didGetSitemaps(sitemaps: [OHSitemap]) {
        for (i, e) in enumerate(sitemaps)
        {
            self.restManager!.getSitemap(e.name)
        }
    }
    
    func didGetSitemap(sitemap: OHSitemap)
    {
        self.dataManager!.sitemaps?.append(sitemap)
        pushViewControllerWithSitemap(sitemap)
    }
}
