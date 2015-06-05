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
    
        
        urlTextField = UITextField(frame: CGRect(x: 0, y: 0, width: view.frame.width - 30, height: 30))
        urlTextField!.borderStyle = UITextBorderStyle.RoundedRect
        urlTextField!.placeholder = "OpenHAB URL"
        view.addSubview(urlTextField!)
        
        if var url = defaults.objectForKey("SettingsOpenHABUrl") as? String {
            urlTextField!.text = url
        }
        
        saveButton = UIButton.buttonWithType(UIButtonType.Custom) as? UIButton
        saveButton!.setTitle("Save", forState: .Normal)
        saveButton?.setTitleColor(UIColor.blackColor(), forState: .Normal)
        saveButton!.addTarget(self, action: "saveButtonPressed:", forControlEvents: .TouchUpInside)
        view.addSubview(saveButton!)
        
        
        dismissButton = UIButton.buttonWithType(UIButtonType.Custom) as? UIButton
        dismissButton!.setTitle("Save", forState: .Normal)
        dismissButton?.setTitleColor(UIColor.blackColor(), forState: .Normal)
        dismissButton!.addTarget(self, action: "dismissButtonPressed:", forControlEvents: .TouchUpInside)
        view.addSubview(dismissButton!)
    }
    
    func initSitemapChooser() {
    
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
        self.revealViewController().setFrontViewController(OHRootViewController.new(), animated: true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if var urlTextField = self.urlTextField {
            urlTextField.marginTop = 100
            urlTextField.marginLeft = 15
        }
        
        if var saveButton = self.saveButton {
            
            saveButton.sizeToFit()
            
            if var urlTextField = self.urlTextField {
                saveButton.marginTop = urlTextField.neededSpaceHeight + 30
            }
            else {
                saveButton.marginTop = 100
            }
            
            saveButton.marginLeft = 15
        }
        
        if var dismissButton = self.dismissButton {
            
            dismissButton.sizeToFit()
            
            if var saveButton = self.saveButton {
                dismissButton.marginTop = saveButton.neededSpaceHeight + 30
            }
            else {
                dismissButton.marginTop = 100
            }
            
            dismissButton.marginLeft = 15
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
