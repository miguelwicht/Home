//
//  OHSectionView.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 22/04/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import UIKit

class OHSectionView: UIView {
    
    let scrollView: UIScrollView
    var headline: UILabel?
    
    var columns = 3
    var rows = 2
    
    init(widgets: [OHWidget], headline: String?)
    {
        self.scrollView = UIScrollView()
        super.init(frame: CGRectMake(0, 0, 320, 400))
        
        if var h = headline {
            self.headline = UILabel()
            self.headline!.text = h
            self.headline!.sizeToFit()
            self.addSubview(self.headline!)
        }
        
        self.scrollView.pagingEnabled = true
        
        for var i: Int = 0; i < widgets.count; ++i {
            var button = UIButton()
            button.setTitle(widgets[i].label, forState: .Normal)
            button.sizeToFit()
            button.frame.origin.x = CGFloat(120 * i)
            self.scrollView.addSubview(button)
        }
        
        
        self.scrollView.frame = CGRectMake(0, 0, self.frame.width, 215)
        self.scrollView.backgroundColor = UIColor.blueColor()
        self.addSubview(self.scrollView)
        
        self.backgroundColor = UIColor.purpleColor()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        self.sizeToFit()
        var scrollViewOffset: CGPoint = CGPointMake(0, 0)
        
        if var headline = self.headline {
            scrollViewOffset.y = headline.frame.origin.y + headline.frame.height
        }
        
        self.scrollView.frame.origin.y = scrollViewOffset.y
        
//        self.sizeToFit()
        
        println("LayoutSubviews")
    }
}
