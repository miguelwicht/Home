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
//            tableView.separatorColor = UIColor.clearColor()
//            tableView.separatorInset = UIEdgeInsetsZero
            
            tableView.backgroundColor = UIColor(red: (236.0 / 255.0), green: (236.0 / 255.0), blue: (236.0 / 255.0), alpha: 1.0)
            
            headerView = OHRearMenuHeaderView(frame: CGRect(x: 0, y: 20, width: tableView.frame.width, height: 44.5))
            headerView!.label.text = "Overview".uppercaseString
            view.addSubview(headerView!)
            
            footerView = OHRearMenuFooterView(frame: CGRect(x: 0, y: 20, width: tableView.frame.width, height: 44.5))
            view.addSubview(footerView!)
            footerView?.marginBottom = 0
            
            tableView.setHeight(tableView.frame.height - headerView!.neededSpaceHeight - footerView!.frame.height)
            tableView.marginTop = headerView!.neededSpaceHeight
            
            headerView?.setWidth(tableView.frame.width)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func toggleSection(button: OHRearMenuSectionHeader)
    {
        button.toggle()
        tableView?.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView!.setWidth(view.frame.width)
        headerView!.setWidth(tableView!.frame.width)
        println("tableView: \(tableView!.frame)")
    }
}

extension OHRearMenuViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if var sectionHeader = self.sectionHeaders[section] {
            return sectionHeader
        }
        else {
            var button = OHRearMenuSectionHeader()
            button.section = section
            button.showSection = true
            sectionHeaders[section] = button
//            button.setTitle("Header \(section)".uppercaseString, forState: .Normal)
            
            
            if section == 0 {
                button.setTitle("Rooms".uppercaseString, forState: .Normal)
            } else if section == 1 {
                button.setTitle("Items".uppercaseString, forState: .Normal)
            } else {
                button.setTitle("Sitemaps".uppercaseString, forState: .Normal)
            }
            
            
            
            
            button.addTarget(self, action: "toggleSection:", forControlEvents: .TouchUpInside)
            button.borderTop.hidden = section == 0 ? true : false
        }
        
        return sectionHeaders[section]!
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
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 52
    }
    
}

extension OHRearMenuViewController: UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        var numberOfRows = 5
        
        
        if (sectionHeaders[section] != nil) {
            
            var button = sectionHeaders[section]!
            
            numberOfRows = button!.showSection ? 5 : 0
        }
        
        return numberOfRows
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! OHRearMenuTableViewCell
        
        var numberOfItemsInSection = self.tableView(tableView, numberOfRowsInSection: indexPath.section)
        
        cell.lineView.hidden = numberOfItemsInSection == indexPath.row + 1 ? true : false
        
        // Configure the cell...
        
        cell.textLabel?.text = "Cellname:  adsas \(indexPath.item)"
//        cell.backgroundColor = UIColor(red: (236.0 / 255.0), green: (236.0 / 255.0), blue: (236.0 / 255.0), alpha: 1.0)
        
        return cell
    }
    
    
}
