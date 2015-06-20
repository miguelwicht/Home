//
//  OHStatusBarView.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 05/06/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import UIKit

class OHStatusBarView: UIView {
    
    var normalColor = OHDefaults.defaultNavigationBarColor()
    var highlightedColor = OHDefaults.defaultNavigationBarColor()
    var highlightedStatusBarStyle: UIStatusBarStyle = UIStatusBarStyle.LightContent
    var normalStatusBarStyle: UIStatusBarStyle = UIStatusBarStyle.LightContent
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        backgroundColor = normalColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = normalColor
    }
    
    var highlighted : Bool = false {
        didSet {
            var interval: NSTimeInterval = 0.3
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            if (highlighted) {
                UIView.animateWithDuration(interval, animations: {
                    self.backgroundColor = self.highlightedColor
                    UIApplication.sharedApplication().statusBarStyle = self.highlightedStatusBarStyle
                })
            } else {
                UIView.animateWithDuration(interval, animations: {
                    self.backgroundColor = self.normalColor
                    UIApplication.sharedApplication().statusBarStyle = self.normalStatusBarStyle
                })
            }
        }
    }
}
