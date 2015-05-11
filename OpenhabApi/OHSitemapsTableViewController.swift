//
//  OHSitemapsTableViewController.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 14/04/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import UIKit

class OHSitemapsTableViewController: UIViewController {
    
    @IBOutlet var tableView:UITableView!
    var restManager: OHRestManager?
    var sitemaps: [OHSitemap] = []
    
    required init(coder aDecoder: NSCoder)
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let url = defaults.objectForKey("SettingsOpenHABURL") as? String {
            self.restManager = OHRestManager(baseUrl: url)
            println("URL: \(url)")
        } else {
            println("no url")
        }
        
        super.init(coder: aDecoder)
        
        if var restManager = self.restManager {
            restManager.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        println("SitemapsController: viewDidLoad")
        restManager?.getSitemaps()
    }
}

//MARK: UITableViewDelegate
extension OHSitemapsTableViewController: UITableViewDelegate
{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("You selected cell #\(indexPath.row)!")
        //self.restManager.getSitemap(self.sitemaps[indexPath.row].name)
        
        println(self.sitemaps[indexPath.row])
        
        var homepage = self.sitemaps[indexPath.row].homepage!
        
        var widget: OHWidget?
        
        for (i, e) in enumerate(homepage.widgets!)
        {
            widget = e
        }
        
//        var widget: OHWidget = self.sitemaps[indexPath.row].homepage!.wi
        
        var widgets = widget!.widgets
        
        println("widgets to pass: \(widgets)")
        
        var vc: OHRoomViewController = OHRoomViewController(widgets: widgets!)
        self.presentViewController(vc, animated: true, completion: nil)
    }
}

//MARK: UITableViewDataSource
extension OHSitemapsTableViewController: UITableViewDataSource
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sitemaps.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        cell.textLabel?.text = self.sitemaps[indexPath.row].name
        
        return cell
    }
}

//MARK: OHRestManagerDelegate
extension OHSitemapsTableViewController: OHRestManagerDelegate
{
    func didGetItems(items: [JSON]) {
        println(items)
    }
    
    func didGetBeacons(beacons: [OHBeacon]) {
        println(beacons)
    }
    
    func didGetSitemaps(sitemaps: [OHSitemap]) {
        for (i, e) in enumerate(sitemaps)
        {
            self.restManager!.getSitemap(e.name)
        }
    }
    
    func didGetSitemap(sitemap: OHSitemap)
    {
        
        self.sitemaps.append(sitemap)
        
        self.tableView.reloadData()
//        println(sitemap)
//        let sitemapParser: OHSitemapParser = OHSitemapParser(sitemap: sitemap)
//        
//        var widgets: [OHWidget] = sitemapParser.getWidgets()
        
//        println(sitemap)
        
//        var widgets = sitemap.homepage!.widgets!
//        
//        var subWidgets: [OHWidget] = [OHWidget]()
        
//        for (index, element) in enumerate(widgets)
//        {
////            subWidgets = sitemapParser.parseWidgets(element.widgets!)
//            subWidgets = element.widgets!
//        }
        
//        println("\(subWidgets)")
        
//        for (i, e) in enumerate(subWidgets)
//        {
//            println("subwidget: \(e)")
//        }
        
//        var vc: OHRoomViewController = OHRoomViewController(widgets: subWidgets)
//        var vc: OHRoomViewController = OHRoomViewController(widgets: widgets)
//        self.presentViewController(vc, animated: true, completion: nil)
    }
}