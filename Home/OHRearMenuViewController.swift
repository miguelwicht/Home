//
//  OHRearMenuViewController.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 20/05/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import UIKit

class OHRearMenuViewController: UIViewController {
    
    var tableView: UITableView?
    var headerView: OHRearMenuHeaderView?
    var footerView: OHRearMenuFooterView?
    var sectionHeaders: [Int:OHRearMenuSectionHeader?] = [Int:OHRearMenuSectionHeader?]()
    
    var widgets: [OHWidget]?
    
    override func loadView() {
        super.loadView()
        
        tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Grouped)
        view.backgroundColor = UIColor(red: (236.0 / 255.0), green: (236.0 / 255.0), blue: (236.0 / 255.0), alpha: 1.0)
        
        if var tableView = self.tableView {
            view.addSubview(tableView)
            tableView.registerClass(OHRearMenuTableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
            tableView.frame = view.frame
            tableView.dataSource = self
            tableView.delegate = self
            tableView.backgroundColor = UIColor(red: (236.0 / 255.0), green: (236.0 / 255.0), blue: (236.0 / 255.0), alpha: 1.0)
            
            headerView = OHRearMenuHeaderView(frame: CGRect(x: 0, y: 20, width: tableView.frame.width, height: 44.5))
            headerView!.label.text = "Overview".uppercaseString
            view.addSubview(headerView!)
            
            footerView = OHRearMenuFooterView()
            view.addSubview(footerView!)
            
            tableView.setTranslatesAutoresizingMaskIntoConstraints(false)
            headerView?.setWidth(tableView.frame.width)
            
            var footerButton: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
            footerButton.setTranslatesAutoresizingMaskIntoConstraints(false)
            footerButton.setTitle("Settings".uppercaseString, forState: .Normal)
            footerButton.titleLabel?.font = OHDefaults.defaultFontWithSize(17)
            footerButton.setTitleColor(OHDefaults.defaultTextColor(), forState: .Normal)
            footerView!.addSubview(footerButton)
            footerButton.addTarget(self, action: "footerButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
            
            footerView?.setTranslatesAutoresizingMaskIntoConstraints(false)
            
            var views = [String: AnyObject]()
            views["footerView"] = footerView
            views["footerButton"] = footerButton
            views["tableView"] = tableView
            
            view.addConstraint(NSLayoutConstraint(item: footerView!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Height, multiplier: 0.0, constant:44.5))
            view.addConstraint(NSLayoutConstraint(item: footerView!, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant:0))
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[footerView]-(0)-|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: views))
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(0)-[footerButton]-(0)-|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: views))
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[footerButton]-(0)-|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: views))
            view.addConstraint(NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: footerView, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant:0))
            view.addConstraint(NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: headerView!, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant:0))
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[tableView]-(0)-|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: views))
        }
        
        updateMenu()
    }
    
    func footerButtonPressed(button: UIButton) {
        var settingsViewController = OHSettingsViewController()
        var navController = UINavigationController(rootViewController: settingsViewController)
        self.presentViewController(navController, animated: true, completion: nil)
    }
    
    func updateMenu() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if var sitemaps = OHDataManager.sharedInstance.sitemaps {
            var startIndex = sitemaps.startIndex
            var sitemap = sitemaps[startIndex].1
            
            if var currentSitemap = OHDataManager.sharedInstance.currentSitemap {
                sitemap = currentSitemap
            }
            
            widgets = OHRestParser.getMenuFromSitemap(sitemap)
        }
        
        tableView?.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func toggleSection(button: OHRearMenuSectionHeader) {
        button.toggle()
        tableView?.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView!.setWidth(view.frame.width)
        headerView!.setWidth(tableView!.frame.width)
    }
}

extension OHRearMenuViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if var widgets = self.widgets {
            if var sectionHeader = self.sectionHeaders[section] {
                return sectionHeader
            }
            else {
                var button = OHRearMenuSectionHeader()
                button.section = section
                button.showSection = false
                
                sectionHeaders[section] = button
                var widget = widgets[section]
                
                button.setTitle(widget.label!.uppercaseString, forState: .Normal)
                button.addTarget(self, action: "toggleSection:", forControlEvents: .TouchUpInside)
                button.borderTop.hidden = section == 0 ? true : false
            }
        }
        
        return sectionHeaders[section] != nil ? sectionHeaders[section]! : nil
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 63
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
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
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 52
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var item = widgets![indexPath.section].linkedPage!.widgets![indexPath.row]

        if var item = widgets![indexPath.section].linkedPage!.widgets![indexPath.row].item {
            if item.isLightFromTags() {
                pushLightsController(widgets![indexPath.section].linkedPage!.widgets![indexPath.row])
            } else if item.hasTag("OH_Scene") {
                item.sendCommand("ON")
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
            } else if item.hasTagWithPrefix("OH_Menu_Sitemap_") {
                if var sitemapName = item.getTagWithoutPrefix("OH_Menu_Sitemap_") {
                    if var sitemaps = OHDataManager.sharedInstance.sitemaps {
                        if var sitemap = sitemaps[sitemapName] {
                            OHDataManager.sharedInstance.currentSitemap = sitemap
                        }
                    }
                }
            }
        }
    }
    
    func pushLightsController(widget: OHWidget) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if var containerViewController = appDelegate.window?.rootViewController as? SWRevealViewController {
            if var rootViewController = containerViewController.frontViewController as? OHRootViewController {
                var vc = OHLightController()
                vc.title = widget.label
                
                if var bulbs = widget.linkedPage?.widgets {
                    vc.initWidget(bulbs)
                    var lights = [OHLight]()
                    
                    for (index, bulb) in enumerate(bulbs) {
                        var light = OHLight(widget: bulb)
                        lights.append(light)
                    }
                    
                    vc.initLights(lights)
                }
                
                rootViewController.pushViewController(vc, animated: true)
                rootViewController.revealViewController().revealToggle(self)
            }
        }
    }
}

extension OHRearMenuViewController: UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.widgets != nil ? self.widgets!.count : 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sectionHeader = sectionHeaders[section] {
            var button = sectionHeader
            var numberOfItems = widgets?[section].linkedPage?.widgets?.count != nil ? widgets![section].linkedPage!.widgets!.count : 0
            
            return button!.showSection ? numberOfItems : 0
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! OHRearMenuTableViewCell
        var numberOfItemsInSection = self.tableView(tableView, numberOfRowsInSection: indexPath.section)
        cell.lineView.hidden = numberOfItemsInSection == indexPath.row + 1 ? true : false
        
        var item = widgets![indexPath.section].linkedPage!.widgets![indexPath.row]
        cell.textLabel?.text = item.label
        
        if var iconName = item.item?.iconNameFromTags() {
            cell.imageView?.image = UIImage(named: iconName)?.imageWithRenderingMode(.AlwaysTemplate)
        }
        //TODO: reset image if there was no icon defined
        
        return cell
    }
}
