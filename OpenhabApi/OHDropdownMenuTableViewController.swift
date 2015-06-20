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
        
        view.backgroundColor = OHDefaults.defaultTextColor()
        configureTableView()
        addLayoutConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension OHDropdownMenuTableViewController {
    
    func configureTableView() {
        tableView.registerClass(OHDropdownMenuTableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        
        view.addSubview(tableView)
        view.addSubview(topBorderView)
        
        tableView.backgroundColor = UIColor.clearColor()
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        tableView.dataSource = self
        tableView.bounces = true
        
        let borderColor = UIColor(red: (169.0 / 255.0), green: (169.0 / 255.0), blue: (169.0 / 255.0), alpha: 1.0)
        topBorderView.backgroundColor = borderColor
        tableView.separatorColor = borderColor
        tableView.separatorInset = UIEdgeInsetsZero
    }
    
    func addLayoutConstraints( ){
        topBorderView.setTranslatesAutoresizingMaskIntoConstraints(false)
        tableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        var views = [String: AnyObject]()
        views["tableView"] = tableView
        views["topBorderView"] = topBorderView
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(0)-[tableView]-(0)-|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[tableView]-(0)-|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[topBorderView]-(0)-|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: views))
        view.addConstraint(NSLayoutConstraint(item: topBorderView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: topBorderView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Height, multiplier: 0.0, constant: 0.5))
        view.addConstraint(NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0))
    }
}

//MARK: - Table view data source
extension OHDropdownMenuTableViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = data.count
        
        return numberOfRows
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! OHDropdownMenuTableViewCell
        
        var numberOfItems = self.tableView(tableView, numberOfRowsInSection: indexPath.section)
        
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
