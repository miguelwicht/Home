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
    var showSectionImage = UIImage(named: "arrow_right")
    var hideSectionImage = UIImage(named: "arrow_down")
    var borderTop = UIView()
    var borderBottom = UIView()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configurateViews()
    }
    
    func configurateViews() {
        setTitleColor(OHDefaults.defaultTextColor(), forState: .Normal)
        setTitleColor(OHDefaults.defaultTextColor(), forState: .Highlighted)
        
        if let titleLabel = self.titleLabel {
            titleLabel.font = OHDefaults.defaultFontWithSize(18)
        }
        backgroundColor = OHDefaults.defaultMenuHeaderBackgroundColor()
        
        borderTop.backgroundColor = UIColor(red: (39.0 / 255.0), green: (39.0 / 255.0), blue: (39.0 / 255.0), alpha: 0.5)
        addSubview(borderTop)
        borderBottom.backgroundColor = UIColor(red: (39.0 / 255.0), green: (39.0 / 255.0), blue: (39.0 / 255.0), alpha: 0.5)
        addSubview(borderBottom)
        
        setImage(showSectionImage, forState: .Normal)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let titleLabel = self.titleLabel {
            titleLabel.marginLeft = 15
            titleLabel.sizeToFit()
            titleLabel.centerViewVerticallyInSuperview()
            imageView!.marginLeft = titleLabel.neededSpaceWidth + 10
            imageView!.centerViewVerticallyInSuperview()
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
    }
    
    var showSection: Bool = false {
        didSet {
            if showSection {
                setImage(hideSectionImage, forState: .Normal)
            } else {
                setImage(showSectionImage, forState: .Normal)
            }
        }
    }
}
