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
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initManagers()
    }
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nil, bundle: nil)
        initManagers()
    }
    
    func initManagers() {
        dataManager = OHDataManager()
        restManager = OHRestManager(baseUrl: "http://192.168.0.251:8888")
        
        if var restManager = self.restManager {
            restManager.delegate = self
        }
        
        loadDefaultViewController()
        
        println("initManagers")
    }
    
    func loadDefaultViewController() {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let sitemap = defaults.objectForKey("SettingsOpenHABSitemap") as? String {
            self.restManager?.getSitemap(sitemap)
            println("GetSitemap: \(sitemap)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.purpleColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func pushViewControllerWithSitemap(sitemap: OHSitemap)
    {
        var homepage = sitemap.homepage!
        
        var widget: OHWidget?
        
        for (i, e) in enumerate(homepage.widgets!)
        {
            widget = e
        }
        
        var widgets = widget!.widgets
        
        var vc: OHRoomViewController = OHRoomViewController(widgets: widgets!)
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
