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
        
//        self.backgroundColor = UIColor(red: (236.0 / 255.0), green: (236.0 / 255.0), blue: (236.0 / 255.0), alpha: 1..0)
        
//        self.imageView?.image = UIImage(named: "arrow_down")
        self.setImage(UIImage(named: "arrow_down"), forState: .Normal)
        
        
        var normalColor = UIColor(red: (68.0 / 255.0), green: (68.0 / 255.0), blue: (68.0 / 255.0), alpha: 1.0)
        self.tintColor = normalColor
        
        setTitleColor(normalColor, forState: .Normal)
        titleLabel?.font = UIFont(name: titleLabel!.font.fontName, size: 30)
        
        println(self.imageView?.frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.imageView?.sizeToFit()
        self.titleLabel?.sizeToFit()
        var spacerWidth: CGFloat = 10.0
//        imageView?.backgroundColor = UIColor.redColor()
//        titleLabel?.backgroundColor = UIColor.greenColor()
        var imageViewSize = self.imageView?.frame
        var marginLeft = (frame.width - (imageViewSize!.width + self.titleLabel!.frame.width + spacerWidth)) / 2
        
        self.titleLabel!.marginLeft = marginLeft
        var pos = titleLabel!.neededSpaceWidth + spacerWidth
        
        imageView!.marginLeft = pos
        
        self.titleLabel!.centerViewVerticallyInSuperview()
        self.imageView!.centerViewVerticallyInSuperview()
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
}
