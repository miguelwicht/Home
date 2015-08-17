//
//  OHButton.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 10/06/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import UIKit

class OHButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initAppearance()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initAppearance()
    }
    
    func initAppearance() {
        OHButton.appearance().setBackgroundImage(UIImage.imageWithColor(OHDefaults.defaultNavigationBarColor()), forState: UIControlState.Normal)
        OHButton.appearance().setBackgroundImage(UIImage.imageWithColor(OHDefaults.defaultCellBackgroundColor()), forState: UIControlState.Highlighted)
        OHButton.appearance().setBackgroundImage(UIImage.imageWithColor(OHDefaults.defaultCellBackgroundColor()), forState: UIControlState.Selected)
        
        titleLabel!.font = OHDefaults.defaultFontWithSize(21)
        OHButton.appearance().setTitleColor(UIColor.whiteColor(), forState: .Normal)
        OHButton.appearance().setTitleColor(OHDefaults.defaultTextColor(), forState: .Highlighted)
        OHButton.appearance().setTitleColor(OHDefaults.defaultTextColor(), forState: .Selected)
        
        contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}
