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
    
    var dismissKeyboardRecognizer: UITapGestureRecognizer?
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    var sitemapChooserHeight = 180 as CGFloat
    var sitemapChooserHeightConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        UIApplication.sharedApplication().keyWindow?.addSubview(loadingView)
        
        
        
//        view.window!.addSubview(loadingView)
        //        appDelegate.window?.screen.addSubview()
        
    }
    
    func addLoadingView()
    {
        if var window = view.window {
            window.addSubview(loadingView)
//            loadingView.hidden = true
            loadingView.frame = self.view.frame
        }
    }
    
    func removeLoadingView()
    {
        loadingView.removeFromSuperview()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView() {
        super.loadView()
        
        initScrollView()
        
        title = "Settings"
//        var navigationController = UINavigationController()
//        view.addSubview(navigationController.view)
        
//        var navigationbar = UINavigationBar(frame: <#CGRect#>))
//        view.addSubview(navigationbar)
        
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        view.backgroundColor = UIColor.whiteColor()
        
        urlTextField = UITextField(frame: CGRect(x: 0, y: 0, width: view.frame.width - 30, height: 40))
        urlTextField!.borderStyle = UITextBorderStyle.Line
        urlTextField!.layer.borderColor = OHDefaults.defaultTextColor().CGColor
        urlTextField!.placeholder = "OpenHAB URL"
        urlTextField!.font = OHDefaults.defaultLightFontWithSize(17)
        urlTextField!.textColor = OHDefaults.defaultTextColor()
        urlTextField!.delegate = self
        contentView.addSubview(urlTextField!)
        
        if var url = defaults.objectForKey("SettingsOpenHABUrl") as? String {
            urlTextField!.text = url
        }
        
        loadSitemapsButton.setTitle("Load Sitemaps", forState: .Normal)
        loadSitemapsButton.addTarget(self, action: "loadSitemapsButtonPressed:", forControlEvents: .TouchUpInside)
        contentView.addSubview(loadSitemapsButton)
        
        saveButton.setTitle("Save", forState: .Normal)
        saveButton.addTarget(self, action: "saveButtonPressed:", forControlEvents: .TouchUpInside)
        contentView.addSubview(saveButton)
        
        dismissButton.setTitle("Dismiss", forState: .Normal)
        dismissButton.addTarget(self, action: "dismissButtonPressed:", forControlEvents: .TouchUpInside)
        contentView.addSubview(dismissButton)
        
        initSitemapChooser()
        
        
        var views = [String: AnyObject]()
        views["urlTextField"] = urlTextField
        views["loadSitemapsButton"] = loadSitemapsButton
        views["sitemapChooser"] = sitemapChooserController!.view
        views["sitemapChooserButton"] = sitemapChooserButton!
        views["saveButton"] = saveButton
        views["dismissButton"] = dismissButton
        
//        views["navigationBar"] = navigationController.view
        
        urlTextField?.setTranslatesAutoresizingMaskIntoConstraints(false)
        loadSitemapsButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        sitemapChooserButton?.setTranslatesAutoresizingMaskIntoConstraints(false)
        sitemapChooserController?.view.setTranslatesAutoresizingMaskIntoConstraints(false)
        saveButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        dismissButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        
//        navigationController.view.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(15)-[urlTextField(40)]-(15)-[sitemapChooserButton]-[sitemapChooser]-(15)-[loadSitemapsButton]-(15)-[saveButton]-(15)-[dismissButton]", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: views))
//        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[navigationBar]|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(15)-[urlTextField]-(15)-|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(15)-[loadSitemapsButton]-(15)-|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(15)-[sitemapChooserButton]-(15)-|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: views))
        
//        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(0)-[saveButton]-(0)-|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(15)-[saveButton]-(15)-|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: views))
        
//        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(0)-[contentView]-(0)-|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(15)-[dismissButton]-(15)-|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: views))
        
        
        
        
        
        
        
        initObservers()
        
        
//        if var collectionViewController = collectionViewControllers.last {
        
            var scrollViewHeightConstraint = NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: dismissButton, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 15)
            
            view.addConstraint(scrollViewHeightConstraint)
//        }
        
//        dismissKeyboardRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
//        view.addGestureRecognizer(dismissKeyboardRecognizer!)
    }
    
    func initScrollView()
    {
        scrollView.delegate = self
        scrollView.frame = view.frame
        view.addSubview(scrollView)
        
        scrollView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        
        scrollView.addSubview(contentView)
        contentView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        addScrollViewConstraints()
        
        //
        //        scrollView.marginTop = 0
        //        scrollView.marginLeft = 0
    }
    
    func addScrollViewConstraints()
    {
        var views = [String: AnyObject]()
        views["scrollView"] = scrollView
        views["contentView"] = contentView
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(0)-[scrollView]-(0)-|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[scrollView]-(0)-|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: views))
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(0)-[contentView]-(0)-|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[contentView]-(0)-|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: views))
        
        self.view.addConstraint(NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0))
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
//        if var urlTextField = self.urlTextField {
//            urlTextField.marginTop = 100
//            urlTextField.marginLeft = 15
//        }
//        
//        loadSitemapsButton.sizeToFit()
//        loadSitemapsButton.setWidth(self.view.frame.width - 30)
//        loadSitemapsButton.setHeight(40)
//        loadSitemapsButton.marginTop = urlTextField!.neededSpaceHeight + 10
//        loadSitemapsButton.marginLeft = 15
        
//        sitemapChooserButton!.marginTop = loadSitemapsButton.neededSpaceHeight + 10
//        sitemapChooserController!.view.marginTop = sitemapChooserButton!.neededSpaceHeight
//        sitemapChooserController!.view.setHeight(self.view.frame.height - sitemapChooserButton!.neededSpaceHeight)
        
        
        
        
            
//        saveButton.sizeToFit()
//        
//        if var sitemapChooserButton = self.sitemapChooserButton {
//            saveButton.marginTop = sitemapChooserButton.neededSpaceHeight + 30
//        }
//        else {
//            saveButton.marginTop = 100
//        }
//            
//        saveButton.marginLeft = 15
//        saveButton.setWidth(self.view.frame.width - 30)
//        saveButton.setHeight(40)
//            
//        dismissButton.sizeToFit()
//        dismissButton.marginTop = saveButton.neededSpaceHeight + 15
//            
//        dismissButton.marginLeft = 15
//        dismissButton.setWidth(self.view.frame.width - 30)
//        dismissButton.setHeight(40)
    }
    
    func toggleDropdownMenu(control: OHDropdownMenuButton)
    {
        if var sitemapChooserController = self.sitemapChooserController {
            sitemapChooserController.view.hidden = sitemapChooserController.view.hidden ? false : true
            sitemapChooserController.tableView.reloadData()
            
            var numberOfItems = sitemapChooserController.tableView(sitemapChooserController.tableView, numberOfRowsInSection: 0)
            sitemapChooserHeightConstraint?.constant = sitemapChooserController.view.hidden ? 0 : CGFloat(numberOfItems) * tableView(self.sitemapChooserController!.tableView, heightForRowAtIndexPath: NSIndexPath(forItem: 0, inSection: 0))
            
            
//            var height = CGFloat(sitemapChooserController.tableView.numberOfRowsInSection(0)) * self.tableView(sitemapChooserController.tableView, heightForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
            
//            sitemapChooserController.tableView.setHeight(height)
        }
    }
    
    deinit {
        removeObservers()
        
        if let dismissKeyboardRecognizer = self.dismissKeyboardRecognizer {
            view.removeGestureRecognizer(dismissKeyboardRecognizer)
        }
    }
    
    func dismissKeyboard()
    {
        view.endEditing(true)
    }
}

//MARK: SitemapChooser
extension OHSettingsViewController {
    
    func initSitemapChooser() {
        
//        sitemapChooserButton = OHDropdownMenuButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 90))
        sitemapChooserButton = OHDropdownMenuButton()
        if var sitemapChooserButton = self.sitemapChooserButton {
            contentView.addSubview(sitemapChooserButton)
            
            sitemapChooserButton.setTitle("Choose Sitemap", forState: .Normal)
            
            sitemapChooserController = OHDropdownMenuTableViewController()
            
            if var sitemapChooserController = self.sitemapChooserController {
                
                if var sitemapData = OHDataManager.sharedInstance.sitemaps {
                    sitemapChooserController.data = sitemapData.values.array
                }
                
                addChildViewController(sitemapChooserController)
                contentView.addSubview(sitemapChooserController.view)
                

                sitemapChooserController.tableView.delegate = self
                sitemapChooserController.tableView.alwaysBounceVertical = false
                
                sitemapChooserController.view.setTranslatesAutoresizingMaskIntoConstraints(false)
                
                var views = [String: AnyObject]()
                views["sitemapChooser"] = sitemapChooserController.view
                views["sitemapChooserButton"] = sitemapChooserButton
                
                sitemapChooserHeightConstraint = NSLayoutConstraint(item: sitemapChooserController.view, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Height, multiplier: 0.0, constant: 0)
                
                contentView.addConstraint(sitemapChooserHeightConstraint!)
                
                contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[sitemapChooser]-(0)-|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: views))
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
        dismissKeyboard()
        
        if var urlTextField = self.urlTextField {
            var url = urlTextField.text
            
            if var urlText = url {
                
                if !isEmpty(url) {
                    defaults.setObject(urlText, forKey: "SettingsOpenHABUrl")
                    defaults.synchronize()
                    OHDataManager.sharedInstance.updateBaseUrl(url)
                    OHDataManager.sharedInstance.downloadSitemaps()
                    addLoadingView()
                }
            }
        }
        
        
    }
    
    func saveButtonPressed(button: UIButton)
    {
        dismissKeyboard()
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
//            self.loadingView.hidden = true
            
            self.removeLoadingView()
        })
        
        didUpdateSitemapsObserver = NSNotificationCenter.defaultCenter().addObserverForName("OHDataManagerDidUpdateSitemapsNotification", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { notification in
            self.updateSitemapChooser()
//            self.loadingView.hidden = true
            self.removeLoadingView()
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
        
//        loadingView.hidden = false
        
        addLoadingView()
        
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
    
    func textFieldDidEndEditing(textField: UITextField) {
        if var urlText = self.urlTextField?.text {
            defaults.setObject(urlText, forKey: "SettingsOpenHABUrl")
            OHDataManager.sharedInstance.updateBaseUrl(urlText)
        }
    }
}
