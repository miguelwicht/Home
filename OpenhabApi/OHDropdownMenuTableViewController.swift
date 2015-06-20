//
//  OHDropdownMenuTableViewController.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 16/05/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import UIKit

class OHDropdownMenuTableViewController: UIViewController {
    
    var data = [AnyObject]()
    
    var tableView: UITableView = UITableView()
    var topBorderView = UIView()
    
    override func loadView() {
        super.loadView()
        
        tableView.registerClass(OHDropdownMenuTableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        topBorderView.setTranslatesAutoresizingMaskIntoConstraints(false)
        tableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        view.addSubview(tableView)
        
        var borderColor = UIColor(red: (169.0 / 255.0), green: (169.0 / 255.0), blue: (169.0 / 255.0), alpha: 1.0)
        topBorderView.backgroundColor = borderColor
        tableView.backgroundColor = UIColor.clearColor()
        
        view.addSubview(topBorderView)
        
        var views = [String: AnyObject]()
        views["tableView"] = tableView
        views["topBorderView"] = topBorderView
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(0)-[tableView]-(0)-|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[tableView]-(0)-|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: views))
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[topBorderView]-(0)-|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: views))
        view.addConstraint(NSLayoutConstraint(item: topBorderView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: topBorderView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Height, multiplier: 0.0, constant: 0.5))
        
        view.addConstraint(NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0))
        
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        tableView.dataSource = self
        tableView.bounces = true
        
        tableView.separatorColor = borderColor
        tableView.separatorInset = UIEdgeInsetsZero
        
        view.backgroundColor = OHDefaults.defaultTextColor()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension OHDropdownMenuTableViewController: UITableViewDataSource {
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = data.count
        
        return numberOfRows
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! OHDropdownMenuTableViewCell
        cell.roundedCorners = false
        
        var numberOfItems = self.tableView(tableView, numberOfRowsInSection: indexPath.section)
        
        // Configure the cell...
        
        if var data = self.data as? [OHWidget] {
            cell.textLabel?.text = data[indexPath.row].label?.uppercaseString
            
            if var icon = data[indexPath.row].icon {
                
                if icon != "none" {
                    // TODO: check if file exists
                    cell.imageView?.image = UIImage(named: icon)?.imageWithRenderingMode(.AlwaysTemplate)
                }
                else {
                    cell.imageView?.image = nil
                }
                
            }
            
            
        }
        else if var data = self.data as? [OHSitemap] {
            cell.textLabel?.text = data[indexPath.row].label
        }
        
        
        return cell
    }
}
