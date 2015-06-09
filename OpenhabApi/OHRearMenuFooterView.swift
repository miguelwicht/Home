//
//  OHRearMenuFooterView.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 03/06/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import UIKit

class OHRearMenuFooterView: UIView {
    
    let label = UILabel()
    let lineView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(label)
        
        self.addSubview(lineView)
        lineView.backgroundColor = UIColor(red: (142.0 / 255.0), green: (136.0 / 255.0), blue: (136.0 / 255.0), alpha: 1.0)
        label.textColor = OHDefaults.defaultTextColor()
        label.font = OHDefaults.defaultFontWithSize(18)
        self.backgroundColor = UIColor.whiteColor()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        label.sizeToFit()
        label.centerViewVerticallyInSuperview()
        label.marginLeft = 15
        
        lineView.setHeight(0.5)
        lineView.setWidth(self.frame.width)
        lineView.marginTop = 0.0
    }
    
}
