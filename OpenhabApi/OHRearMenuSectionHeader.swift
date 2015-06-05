//
//  OHRearMenuSectionHeader.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 23/05/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import UIKit

class OHRearMenuSectionHeader: UIButton {
    
    var section: Int?
    var showSection: Bool = true
    var showSectionImage = UIImage(named: "arrow_right")
    var hideSectionImage = UIImage(named: "arrow_down")
    var borderTop = UIView()
    var borderBottom = UIView()
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configurateViews()
    }
    
    func configurateViews()
    {
        setTitleColor(UIColor(red: (68.0 / 255.0), green: (68.0 / 255.0), blue: (68.0 / 255.0), alpha: 1.0), forState: .Normal)
        setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
//        setImage(UIImage(named: "arrow_left"), forState: .Normal)
        
        if var titleLabel = self.titleLabel {
            titleLabel.font = OHDefaults.defaultFontWithSize(20)  //UIFont(name:  "Muli-Regular", size: 32)
        }
        self.backgroundColor = UIColor.colorFromRGB(red: 248, green: 248, blue: 248, alpha: 1.0)
//        self.addTarget(self, action: "toggle", forControlEvents: .TouchUpInside)
        
        borderTop.backgroundColor = UIColor(red: (39.0 / 255.0), green: (39.0 / 255.0), blue: (39.0 / 255.0), alpha: 0.5)
        addSubview(borderTop)
        borderBottom.backgroundColor = UIColor(red: (39.0 / 255.0), green: (39.0 / 255.0), blue: (39.0 / 255.0), alpha: 0.5)
        addSubview(borderBottom)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        if var titleLabel = self.titleLabel {
            titleLabel.marginLeft = 15
            titleLabel.sizeToFit()
            titleLabel.centerViewVerticallyInSuperview()
            imageView!.marginLeft = titleLabel.neededSpaceWidth + 10
            imageView!.centerViewVerticallyInSuperview()
        }
        
        if showSection {
            setImage(hideSectionImage, forState: .Normal)
//            borderBottom.hidden = false
        } else {
            setImage(showSectionImage, forState: .Normal)
//            borderBottom.hidden = true
        }
        
        borderTop.marginTop = 0
        borderTop.setHeight(0)
        borderTop.setWidth(self.frame.width)
        
        borderBottom.marginBottom = 0
        borderBottom.setHeight(1)
        borderBottom.setWidth(self.frame.width)
        
        
    }
    
    func toggle() {
        showSection = showSection ? false : true
        layoutSubviews()
    }
}
