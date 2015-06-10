//
//  OHRearMenuHeaderView.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 23/05/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import UIKit

class OHRearMenuHeaderView: UIView {
    
    let label = UILabel()
    let lineView = UIView()

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(label)
        
        self.addSubview(lineView)
        lineView.backgroundColor = UIColor(red: (142.0 / 255.0), green: (136.0 / 255.0), blue: (136.0 / 255.0), alpha: 1.0)
        label.textColor = OHDefaults.defaultTextColor()
        label.font = OHDefaults.defaultFontWithSize(22)
        self.backgroundColor = OHDefaults.defaultMenuHeaderBackgroundColor()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        label.sizeToFit()
        label.centerViewVerticallyInSuperview()
//        label.marginLeft = 15
        label.centerViewHorizontallyInSuperview()
        
        lineView.setHeight(0.5)
        lineView.setWidth(self.frame.width)
        lineView.marginBottom = 0.0
    }

}
