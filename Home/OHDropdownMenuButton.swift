//
//  OHDropdownMenuButton.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 16/05/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import UIKit

class OHDropdownMenuButton: UIButton {

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setImage(UIImage(named: "arrow_down"), forState: .Normal)
        var normalColor = UIColor(red: (68.0 / 255.0), green: (68.0 / 255.0), blue: (68.0 / 255.0), alpha: 1.0)
        self.tintColor = normalColor
        setTitleColor(normalColor, forState: .Normal)
        titleLabel?.font = OHDefaults.defaultFontWithSize(30)
        titleLabel?.lineBreakMode = NSLineBreakMode.ByTruncatingTail
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var spacerWidth: CGFloat = 10.0
        var buttonContentWidth = titleLabel!.frame.width + spacerWidth + imageView!.frame.width
        
        if buttonContentWidth > self.frame.width - 30 {
            self.titleLabel?.setWidth(self.frame.width - 30 - spacerWidth - imageView!.frame.width)
        }

        var imageViewSize = self.imageView?.frame
        var marginLeft = (frame.width - (imageViewSize!.width + self.titleLabel!.frame.width + spacerWidth)) / 2
        
        self.titleLabel!.marginLeft = marginLeft
        var pos = titleLabel!.neededSpaceWidth + spacerWidth
        
        imageView!.marginLeft = pos
        
        self.titleLabel!.centerViewVerticallyInSuperview()
        self.imageView!.centerViewVerticallyInSuperview()
    }
}
