//
//  OHWidgetCell.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 28/04/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import UIKit

class OHWidgetCell: UICollectionViewCell {
    
    let imageView: UIImageView = UIImageView()
    let label: UILabel = UILabel()
    var textHeight: CGFloat?
    var font: UIFont = UIFont(name: "HelveticaNeue-Light", size: 13)!
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        calculateTextHeight()
        initOutlets()
    }

    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        calculateTextHeight()
        initOutlets()
    }
    
    func initOutlets()
    {
        self.imageView.contentMode = UIViewContentMode.Center
        self.addSubview(self.imageView)
        
        self.label.font = self.font
        self.label.textAlignment = NSTextAlignment.Center
        self.label.adjustsFontSizeToFitWidth = true;
        self.addSubview(self.label)
//        self.backgroundColor = UIColor.purpleColor()
    }
    
    func calculateTextHeight()
    {
        var dummyText: NSString = "LoremIpsumg"
        var font: UIFont = UIFont(name: self.font.fontName, size: CGFloat(self.font.pointSize + 2))!
        var textSize: CGSize = dummyText.sizeWithAttributes([NSFontAttributeName:font])
        textHeight = textSize.height
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        imageView.frame = CGRectMake(0, 0, self.frame.width, self.frame.height - self.textHeight!)
        label.frame = CGRectMake(0, self.frame.height - self.textHeight!, self.frame.width, self.textHeight!)
    }
}
