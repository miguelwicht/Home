//
//  OHSettingsViewController.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 04/06/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import UIKit

class OHSettingsViewController: UIViewController {
    
    var urlTextField: UITextField?
    var saveButton: UIButton?
    let defaults = NSUserDefaults.standardUserDefaults()
    var dismissButton: UIButton?
    var sitemaps: [OHSitemap]?
    var sitemapChooserController: OHDropdownMenuTableViewController?
    var sitemapChooserButton: OHDropdownMenuButton?
    var loadSitemapsButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = UIColor.whiteColor()
        
//        sitemaps = [String](arrayLiteral:"ios_lab")
        sitemaps = [OHSitemap]()
        
        
        
        urlTextField = UITextField(frame: CGRect(x: 0, y: 0, width: view.frame.width - 30, height: 40))
        urlTextField!.borderStyle = UITextBorderStyle.Line
        urlTextField!.layer.borderColor = OHDefaults.defaultTextColor().CGColor
        urlTextField!.placeholder = "OpenHAB URL"
        urlTextField!.font = OHDefaults.defaultLightFontWithSize(17)
        urlTextField!.textColor = OHDefaults.defaultTextColor()
        urlTextField!.delegate = self
        view.addSubview(urlTextField!)
        
        if var url = defaults.objectForKey("SettingsOpenHABUrl") as? String {
            urlTextField!.text = url
        }
        
        loadSitemapsButton = UIButton.buttonWithType(UIButtonType.Custom) as? UIButton
        loadSitemapsButton!.setTitle("Load Sitemaps", forState: .Normal)
        loadSitemapsButton!.setTitleColor(OHDefaults.defaultTextColor(), forState: .Normal)
        loadSitemapsButton!.backgroundColor = OHDefaults.defaultCellBackgroundColor()
        loadSitemapsButton!.titleLabel?.font = OHDefaults.defaultFontWithSize(17)
        loadSitemapsButton?.addTarget(self, action: "loadSitemapsButtonPressed:", forControlEvents: .TouchUpInside)
        
        view.addSubview(loadSitemapsButton!)
        
        saveButton = UIButton.buttonWithType(UIButtonType.Custom) as? UIButton
        saveButton!.setTitle("Save", forState: .Normal)
        saveButton!.setTitleColor(OHDefaults.defaultTextColor(), forState: .Normal)
        saveButton!.backgroundColor = OHDefaults.defaultCellBackgroundColor()
        saveButton!.titleLabel?.font = OHDefaults.defaultFontWithSize(17)
        saveButton!.addTarget(self, action: "saveButtonPressed:", forControlEvents: .TouchUpInside)
        view.addSubview(saveButton!)
        
        
        dismissButton = UIButton.buttonWithType(UIButtonType.Custom) as? UIButton
        dismissButton!.setTitle("Dismiss", forState: .Normal)
        dismissButton!.setTitleColor(OHDefaults.defaultTextColor(), forState: .Normal)
        dismissButton!.backgroundColor = OHDefaults.defaultCellBackgroundColor()
        dismissButton!.titleLabel?.font = OHDefaults.defaultFontWithSize(17)
        dismissButton!.addTarget(self, action: "dismissButtonPressed:", forControlEvents: .TouchUpInside)
        view.addSubview(dismissButton!)
        
        initSitemapChooser()
    }
    
    func initSitemapChooser() {
        
        sitemapChooserButton = OHDropdownMenuButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 90))
        
        if var sitemapChooserButton = self.sitemapChooserButton {
            self.view.addSubview(sitemapChooserButton)
            
            sitemapChooserButton.marginTop = 200
            sitemapChooserButton.setTitle("Living Room", forState: .Normal)
            
            sitemapChooserController = OHDropdownMenuTableViewController()
            
            if var sitemapChooserController = self.sitemapChooserController {
                sitemapChooserController.data = sitemaps!
                addChildViewController(sitemapChooserController)
                view.addSubview(sitemapChooserController.view)
                
                sitemapChooserController.view.marginTop = sitemapChooserButton.neededSpaceHeight
                sitemapChooserController.view.setHeight(self.view.frame.height - sitemapChooserButton.neededSpaceHeight)
                sitemapChooserController.tableView.delegate = self
            }
            
            sitemapChooserButton.addTarget(self, action: "toggleDropdownMenu:", forControlEvents: UIControlEvents.TouchUpInside)
            toggleDropdownMenu(sitemapChooserButton)
        }
    }
    
    func loadSitemapsButtonPressed(button: UIButton)
    {
        getSitemapList()
//        var sitemap = defaults.objectForKey("SettingsOpenHABSitemap") as? String
//        var sitemaps = defaults.objectForKey("SettingsOpenHABSitemaps") as? [String]
//        
//        if var urlTextField = self.urlTextField {
//            var url = urlTextField.text
//            
//            if var urlText = url {
//                defaults.setObject(urlText, forKey: "SettingsOpenHABUrl")
//            }
//        }
//        
//        defaults.synchronize()
    }
    
    func getSitemapList()
    {
        let urlPath = "\(self.urlTextField!.text)/rest/sitemaps"
        let request = NSMutableURLRequest(URL: NSURL(string: urlPath)!)
        request.HTTPMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
            {
                data, response, error in
                
                if error != nil {
                    println("error=\(error)")
                    return
                }
                
                let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
                
                //println(responseString)
                //let json = JSON(data: data).dictionaryValue
                let json = JSON(data: data).arrayValue
                var sitemaps: [OHSitemap] = [OHSitemap]()
                
                //for(index, element) in enumerate(json["sitemap"]!.arrayValue) {
                for(index, element) in enumerate(json) {
                    //                    println("\(index), \(element.dictionaryValue)")
                    
                    var elementDict = element.dictionaryValue
                    var homepageDict = elementDict["homepage"]!.dictionaryValue
                    
                    var name: String = elementDict["name"] != nil ? elementDict["name"]!.stringValue : ""
                    var link: String = elementDict["link"] != nil ? elementDict["link"]!.stringValue : ""
                    var label: String = elementDict["label"] != nil ? elementDict["label"]!.stringValue : ""
                    var leaf: String = homepageDict["leaf"] != nil ? homepageDict["leaf"]!.stringValue : ""
                    var homepageLink: String = homepageDict["link"] != nil ? homepageDict["link"]!.stringValue : ""
                    
                    var sitemap: OHSitemap = OHSitemap(name: name, icon: "", label: label, link: link, leaf: leaf, homepageLink: homepageLink)
                    
                    //                    var sitemap = OHSitemap(sitemap: element)
                    
                    sitemaps.append(sitemap)
                }
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.updateSitemapsData(sitemaps)
                })
        }
        task.resume()
    }
    
    func updateSitemapsData(sitemaps: [OHSitemap])
    {
        self.sitemaps = sitemaps
        self.sitemapChooserController!.data = sitemaps
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            println(self.sitemapChooserController!.data)
            self.sitemapChooserController!.tableView.reloadData()
            
            var sitemapsArray =  [String]()
            
            for (index, sitemap) in enumerate(sitemaps)
            {
                sitemapsArray.append(sitemap.name)
            }
            
            if sitemapsArray.count > 0 {
                self.defaults.setObject(sitemapsArray, forKey: "SettingsOpenHABSitemaps")
                println(self.defaults.dictionaryRepresentation())
                self.defaults.synchronize()
            }
        })
        
        
        
        println(sitemaps)
    }
    
    func saveButtonPressed(button: UIButton)
    {
        var sitemap = defaults.objectForKey("SettingsOpenHABSitemap") as? String
        var sitemaps = defaults.objectForKey("SettingsOpenHABSitemaps") as? [String]
        
        if var urlTextField = self.urlTextField {
            var url = urlTextField.text
            
            if var urlText = url {
                defaults.setObject(urlText, forKey: "SettingsOpenHABUrl")
            }
        }
        
        defaults.synchronize()
    }
    
    func dismissButtonPressed(button: UIButton) {
        
        if var presentingViewController = self.presentingViewController {
            self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        }
        else {
            self.revealViewController().setFrontViewController(OHRootViewController.new(), animated: true)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if var urlTextField = self.urlTextField {
            urlTextField.marginTop = 100
            urlTextField.marginLeft = 15
        }
        
        loadSitemapsButton?.sizeToFit()
        loadSitemapsButton!.setWidth(self.view.frame.width - 30)
        loadSitemapsButton!.setHeight(40)
        loadSitemapsButton!.marginTop = urlTextField!.neededSpaceHeight + 10
        loadSitemapsButton!.marginLeft = 15
        
        sitemapChooserButton!.marginTop = loadSitemapsButton!.neededSpaceHeight + 10
        sitemapChooserController!.view.marginTop = sitemapChooserButton!.neededSpaceHeight
        sitemapChooserController!.view.setHeight(self.view.frame.height - sitemapChooserButton!.neededSpaceHeight)
        
        if var saveButton = self.saveButton {
            
            saveButton.sizeToFit()
            
            if var sitemapChooserButton = self.sitemapChooserButton {
                saveButton.marginTop = sitemapChooserButton.neededSpaceHeight + 30
            }
            else {
                saveButton.marginTop = 100
            }
            
            saveButton.marginLeft = 15
            saveButton.setWidth(self.view.frame.width - 30)
            saveButton.setHeight(40)
        }
        
        if var dismissButton = self.dismissButton {
            
            dismissButton.sizeToFit()
            
            if var saveButton = self.saveButton {
                dismissButton.marginTop = saveButton.neededSpaceHeight + 15
            }
            else {
                dismissButton.marginTop = 100
            }
            
            dismissButton.marginLeft = 15
            dismissButton.setWidth(self.view.frame.width - 30)
            dismissButton.setHeight(40)
        }
        
//        sitemapChooserButton?.marginTop = 200
    }
    
    func toggleDropdownMenu(control: OHDropdownMenuButton)
    {
        if var sitemapChooserController = self.sitemapChooserController {
            sitemapChooserController.view.hidden = sitemapChooserController.view.hidden ? false : true
            sitemapChooserController.tableView.reloadData()
//            sitemapChooserController.tableView.sizeToFit()
            
            var height = CGFloat(sitemapChooserController.tableView.numberOfRowsInSection(0)) * self.tableView(sitemapChooserController.tableView, heightForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
            
            sitemapChooserController.tableView.setHeight(height)
        }
    }
}

extension OHSettingsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        switchToRoom(roomSwitcherController!.data[indexPath.row] as! OHWidget)
//        var sitemap =
        //defaults.objectForKey("SettingsOpenHABSitemap") as? String
        
        if var sitemaps = self.sitemaps {
            var sitemap = sitemaps[indexPath.item]
            
            defaults.setObject(sitemap.name, forKey: "SettingsOpenHABSitemap")
            defaults.synchronize()
        }
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
        return 60
    }
}

extension OHSettingsViewController: UITextFieldDelegate {
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        
        return true
    }
}