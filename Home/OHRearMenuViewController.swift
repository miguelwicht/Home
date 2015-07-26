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
        
        if let tableView = self.tableView {
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
            
            tableView.translatesAutoresizingMaskIntoConstraints = false
            headerView?.setWidth(tableView.frame.width)
            
            let footerButton: UIButton = UIButton(type: UIButtonType.Custom)
            footerButton.translatesAutoresizingMaskIntoConstraints = false
            footerButton.setTitle("Settings".uppercaseString, forState: .Normal)
            footerButton.titleLabel?.font = OHDefaults.defaultFontWithSize(17)
            footerButton.setTitleColor(OHDefaults.defaultTextColor(), forState: .Normal)
            footerView!.addSubview(footerButton)
            footerButton.addTarget(self, action: "footerButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
            
            footerView?.translatesAutoresizingMaskIntoConstraints = false
            
            var views = [String: AnyObject]()
            views["footerView"] = footerView
            views["footerButton"] = footerButton
            views["tableView"] = tableView
            
            view.addConstraint(NSLayoutConstraint(item: footerView!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Height, multiplier: 0.0, constant:44.5))
            view.addConstraint(NSLayoutConstraint(item: footerView!, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant:0))
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[footerView]-(0)-|", options: NSLayoutFormatOptions(), metrics: nil, views: views))
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(0)-[footerButton]-(0)-|", options: NSLayoutFormatOptions(), metrics: nil, views: views))
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[footerButton]-(0)-|", options: NSLayoutFormatOptions(), metrics: nil, views: views))
            view.addConstraint(NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: footerView, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant:0))
            view.addConstraint(NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: headerView!, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant:0))
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[tableView]-(0)-|", options: NSLayoutFormatOptions(), metrics: nil, views: views))
        }
        
        updateMenu()
    }
    
    func footerButtonPressed(button: UIButton) {
        let settingsViewController = OHSettingsViewController()
        let navController = UINavigationController(rootViewController: settingsViewController)
        self.presentViewController(navController, animated: true, completion: nil)
    }
    
    func updateMenu() {
        if var sitemaps = OHDataManager.sharedInstance.sitemaps {
            let startIndex = sitemaps.startIndex
            var sitemap = sitemaps[startIndex].1
            
            if let currentSitemap = OHDataManager.sharedInstance.currentSitemap {
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
            if let sectionHeader = self.sectionHeaders[section] {
                return sectionHeader
            }
            else {
                let button = OHRearMenuSectionHeader()
                button.section = section
                button.showSection = false
                
                sectionHeaders[section] = button
                let widget = widgets[section]
                
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
        if let item = widgets![indexPath.section].linkedPage!.widgets![indexPath.row].item {
            if item.isLightFromTags() {
                pushLightsController(widgets![indexPath.section].linkedPage!.widgets![indexPath.row])
            } else if item.hasTag("OH_Scene") {
                item.sendCommand("ON")
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
            } else if item.hasTagWithPrefix("OH_Menu_Sitemap_") {
                if let sitemapName = item.getTagWithoutPrefix("OH_Menu_Sitemap_") {
                    if var sitemaps = OHDataManager.sharedInstance.sitemaps {
                        if let sitemap = sitemaps[sitemapName] {
                            OHDataManager.sharedInstance.currentSitemap = sitemap
                        }
                    }
                }
            }
        }
    }
    
    func pushLightsController(widget: OHWidget) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if let containerViewController = appDelegate.window?.rootViewController as? SWRevealViewController {
            if let rootViewController = containerViewController.frontViewController as? OHRootViewController {
                let vc = OHLightController()
                vc.title = widget.label
                
                if let bulbs = widget.linkedPage?.widgets {
                    vc.initWidget(bulbs)
                    var lights = [OHLight]()
                    
                    for (index, bulb) in bulbs.enumerate() {
                        let light = OHLight(widget: bulb)
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
            let button = sectionHeader
            let numberOfItems = widgets?[section].linkedPage?.widgets?.count != nil ? widgets![section].linkedPage!.widgets!.count : 0
            
            return button!.showSection ? numberOfItems : 0
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! OHRearMenuTableViewCell
        let numberOfItemsInSection = self.tableView(tableView, numberOfRowsInSection: indexPath.section)
        cell.lineView.hidden = numberOfItemsInSection == indexPath.row + 1 ? true : false
        
        let item = widgets![indexPath.section].linkedPage!.widgets![indexPath.row]
        cell.textLabel?.text = item.label
        
        if let iconName = item.item?.iconNameFromTags() {
            cell.imageView?.image = UIImage(named: iconName)?.imageWithRenderingMode(.AlwaysTemplate)
        }
        //TODO: reset image if there was no icon defined
        
        return cell
    }
}
