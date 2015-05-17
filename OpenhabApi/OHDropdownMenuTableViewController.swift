//
//  OHDropdownMenuTableViewController.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 16/05/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import UIKit

class OHDropdownMenuTableViewController: UIViewController {
    
    var data = [OHWidget]()
    
    var tableView: UITableView = UITableView()
    var topBorderView = UIView()
    
    override func loadView() {
        super.loadView()
        
        view.addSubview(tableView)
        
        var borderColor = UIColor(red: (169.0 / 255.0), green: (169.0 / 255.0), blue: (169.0 / 255.0), alpha: 1.0)
        
        topBorderView.backgroundColor = borderColor
        topBorderView.setWidth(self.view.frame.width)
        topBorderView.setHeight(1)
        view.addSubview(topBorderView)
        
//        tableView.sizeToFit()
        tableView.marginTop = topBorderView.neededSpaceHeight
        tableView.marginLeft = 0
        tableView.backgroundColor = UIColor.blueColor()
//        tableView.setHeight(300)
        tableView.setWidth(self.view.frame.width)
        tableView.setHeight(300)
        tableView.dataSource = self
        tableView.bounces = false
        var frame = tableView.frame
        
        tableView.separatorColor = borderColor
        tableView.separatorInset = UIEdgeInsetsZero
        
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(OHDropdownMenuTableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
    
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
//        tableView.tableFooterView?.frame = CGRectZero
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var frame = self.tableView.frame
        
        tableView.sizeToFit()
        
        frame = self.tableView.frame
        
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
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        var numberOfRows = data.count
        
        return numberOfRows
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! OHDropdownMenuTableViewCell
        
        // Configure the cell...
        
        cell.textLabel?.text = data[indexPath.row].label
        
        return cell
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
}
