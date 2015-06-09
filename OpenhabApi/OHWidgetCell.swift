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
    var font: UIFont = UILabel.appearance().font!
    //UIFont(name: "Muli", size: 13)
    var multiselectEnabled = false
    var selectedIcon = UIImageView(image: UIImage(named: "selection"))
    
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
        self.addSubview(self.imageView)
        
//        self.label.font = self.font
//        self.label.font = UIFont(name: self.font.fontName, size: 12)
//        self.label.font = UIFont(name: "Muli-Light", size: 12)
        self.label.font = OHDefaults.defaultLightFontWithSize(12)
        self.label.textAlignment = NSTextAlignment.Center
        self.label.adjustsFontSizeToFitWidth = false
//        self.label.textColor = UIColor(red: (133.0 / 255.0), green: (133.0 / 255.0), blue: (133.0 / 255.0), alpha: 1.0)
        self.label.textColor = OHDefaults.defaultTextColorLight()
        label.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        self.addSubview(self.label)
        selectedIcon.hidden = true
        imageView.addSubview(selectedIcon)
        
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true
    }
    
    func calculateTextHeight()
    {
        var dummyText: NSString = "LoremIpsumg"
//        var font: UIFont = UIFont(name: self.label.font.fontName, size: CGFloat(self.label.font.pointSize + 2))!
        var font = OHDefaults.defaultLightFontWithSize(14)!
        var textSize: CGSize = dummyText.sizeWithAttributes([NSFontAttributeName:font])
        textHeight = textSize.height
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        imageView.frame = CGRectMake(0, 0, self.frame.width, self.frame.height - self.textHeight!)
        
        if imageView.frame.width >= imageView.image?.size.width {
            self.imageView.contentMode = UIViewContentMode.Center
        } else {
            self.imageView.contentMode = UIViewContentMode.ScaleAspectFit
        }
        
        if var labelText = label.text {
            if count(labelText) == 0 {
                println("length: \(count(labelText)); \(labelText)")
                imageView.centerViewVerticallyInSuperview()
            }
        }
        else {
            imageView.centerViewVerticallyInSuperview()
        }
        
        label.frame = CGRectMake(0, self.frame.height - self.textHeight!, self.frame.width, self.textHeight!)
        
        selectedIcon.sizeToFit()
        selectedIcon.marginRight = 0
        selectedIcon.marginBottom = 0
    }
    
    override var selected : Bool {
        didSet {
            if multiselectEnabled {
//                self.imageView.backgroundColor = selected ? UIColor.purpleColor() : UIColor.clearColor()
//                self.backgroundColor = selected ? UIColor.purpleColor() : UIColor.clearColor()
                selectedIcon.hidden = selected ? false : true
            } else {
                selectedIcon.hidden = true
//                self.imageView.backgroundColor = UIColor.clearColor()
//                self.backgroundColor = UIColor.clearColor()
            }
            
        }
    }
}
