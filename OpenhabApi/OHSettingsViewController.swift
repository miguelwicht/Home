//
//  OHSettingsViewController.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 04/06/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import UIKit

class OHSettingsViewController: UIViewController {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    var urlTextField: UITextField?
    let saveButton = OHButton.new()
    let loadSitemapsButton = OHButton.new()
    let dismissButton = OHButton.new()
    
    var sitemapChooserController: OHDropdownMenuTableViewController?
    var sitemapChooserButton: OHDropdownMenuButton?
    
    var loadingView = OHLoadingView()
    
    var didUpdateCurrentSitemapObserver: NSObjectProtocol!
    var didUpdateSitemapsObserver: NSObjectProtocol!
    
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
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        view.backgroundColor = UIColor.whiteColor()
        
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
        
        loadSitemapsButton.setTitle("Load Sitemaps", forState: .Normal)
        loadSitemapsButton.addTarget(self, action: "loadSitemapsButtonPressed:", forControlEvents: .TouchUpInside)
        view.addSubview(loadSitemapsButton)
        
        saveButton.setTitle("Save", forState: .Normal)
        saveButton.addTarget(self, action: "saveButtonPressed:", forControlEvents: .TouchUpInside)
        view.addSubview(saveButton)
        
        dismissButton.setTitle("Dismiss", forState: .Normal)
        dismissButton.addTarget(self, action: "dismissButtonPressed:", forControlEvents: .TouchUpInside)
        view.addSubview(dismissButton)
        
        self.view.addSubview(loadingView)
        self.loadingView.hidden = true
        loadingView.frame = self.view.frame
        
        initSitemapChooser()
        
        initObservers()
    }
    
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if var urlTextField = self.urlTextField {
            urlTextField.marginTop = 100
            urlTextField.marginLeft = 15
        }
        
        loadSitemapsButton.sizeToFit()
        loadSitemapsButton.setWidth(self.view.frame.width - 30)
        loadSitemapsButton.setHeight(40)
        loadSitemapsButton.marginTop = urlTextField!.neededSpaceHeight + 10
        loadSitemapsButton.marginLeft = 15
        
        sitemapChooserButton!.marginTop = loadSitemapsButton.neededSpaceHeight + 10
        sitemapChooserController!.view.marginTop = sitemapChooserButton!.neededSpaceHeight
        sitemapChooserController!.view.setHeight(self.view.frame.height - sitemapChooserButton!.neededSpaceHeight)
        
            
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
            
        dismissButton.sizeToFit()
        dismissButton.marginTop = saveButton.neededSpaceHeight + 15
            
        dismissButton.marginLeft = 15
        dismissButton.setWidth(self.view.frame.width - 30)
        dismissButton.setHeight(40)
    }
    
    func toggleDropdownMenu(control: OHDropdownMenuButton)
    {
        if var sitemapChooserController = self.sitemapChooserController {
            sitemapChooserController.view.hidden = sitemapChooserController.view.hidden ? false : true
            sitemapChooserController.tableView.reloadData()
            
            var height = CGFloat(sitemapChooserController.tableView.numberOfRowsInSection(0)) * self.tableView(sitemapChooserController.tableView, heightForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
            
            sitemapChooserController.tableView.setHeight(height)
        }
    }
    
    deinit {
        removeObservers()
    }
}

//MARK: SitemapChooser
extension OHSettingsViewController {
    
    func initSitemapChooser() {
        
        sitemapChooserButton = OHDropdownMenuButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 90))
        
        if var sitemapChooserButton = self.sitemapChooserButton {
            self.view.addSubview(sitemapChooserButton)
            
            sitemapChooserButton.marginTop = 200
            sitemapChooserButton.setTitle("Choose Sitemap", forState: .Normal)
            
            sitemapChooserController = OHDropdownMenuTableViewController()
            
            if var sitemapChooserController = self.sitemapChooserController {
                
                if var sitemapData = OHDataManager.sharedInstance.sitemaps {
                    sitemapChooserController.data = sitemapData.values.array
                }
                
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
    
    func updateSitemapChooser()
    {
        if var sitemaps = OHDataManager.sharedInstance.sitemaps {
            
            let sitemapValues = sitemaps.values.array
            
            if var sitemapChooserController = self.sitemapChooserController {
                self.sitemapChooserController!.data = sitemapValues
                self.sitemapChooserController!.tableView.reloadData()
            }
        }
    }
}

//MARK: Actions
extension OHSettingsViewController {
    
    func loadSitemapsButtonPressed(button: UIButton)
    {
        OHDataManager.sharedInstance.downloadSitemaps()
        
        loadingView.hidden = false
    }
    
    func saveButtonPressed(button: UIButton)
    {
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
}

//MARK: Observers
extension OHSettingsViewController {
    
    func initObservers()
    {
        didUpdateCurrentSitemapObserver = NSNotificationCenter.defaultCenter().addObserverForName("OHDataManagerCurrentSitemapDidChangeNotification", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { notification in
            self.updateSitemapChooser()
            self.loadingView.hidden = true
        })
        
        didUpdateSitemapsObserver = NSNotificationCenter.defaultCenter().addObserverForName("OHDataManagerDidUpdateSitemapsNotification", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { notification in
            self.updateSitemapChooser()
            self.loadingView.hidden = true
        })
    }
    
    func removeObservers()
    {
        let nc = NSNotificationCenter.defaultCenter()
        if didUpdateCurrentSitemapObserver != nil {
            nc.removeObserver(didUpdateCurrentSitemapObserver)
        }
        
        if didUpdateSitemapsObserver != nil {
            nc.removeObserver(didUpdateSitemapsObserver)
        }
    }
    
}

//MARK: TableViewDelegate
extension OHSettingsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        var sitemap = self.sitemapChooserController!.data[indexPath.item] as! OHSitemap
        
        loadingView.hidden = false
        
        OHDataManager.sharedInstance.currentSitemap = sitemap
        
        if var sitemapChooserButton = self.sitemapChooserButton {
            sitemapChooserButton.setTitle(sitemap.label, forState: .Normal)
        }
        
        toggleDropdownMenu(self.sitemapChooserButton!)
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

//MARK: UITextFieldDelegate
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
