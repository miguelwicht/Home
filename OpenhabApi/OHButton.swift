//
//  OHButton.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 10/06/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import UIKit

class OHButton: UIButton {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initAppearance()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initAppearance()
    }
    
    func initAppearance()
    {
        OHButton.appearance().backgroundColor = OHDefaults.defaultNavigationBarColor()
        titleLabel!.font = OHDefaults.defaultFontWithSize(17)
        OHButton.appearance().setTitleColor(UIColor.whiteColor(), forState: .Normal)
    }
}
