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
    var multiselectEnabled = false
    var selectedIcon = UIImageView(image: UIImage(named: "selection"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        calculateTextHeight()
        initOutlets()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        calculateTextHeight()
        initOutlets()
    }
    
    func initOutlets() {
        addSubview(self.imageView)
        
        label.font = OHDefaults.defaultLightFontWithSize(12)
        label.textAlignment = NSTextAlignment.Center
        label.adjustsFontSizeToFitWidth = false
        label.textColor = OHDefaults.defaultTextColorLight()
        label.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        addSubview(label)
        
        selectedIcon.hidden = true
        imageView.addSubview(selectedIcon)
        
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true
    }
    
    func calculateTextHeight() {
        var dummyText: NSString = "LoremIpsumg"
        var font = OHDefaults.defaultLightFontWithSize(14)!
        var textSize: CGSize = dummyText.sizeWithAttributes([NSFontAttributeName:font])
        textHeight = textSize.height
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = CGRectMake(0, 0, self.frame.width, self.frame.height - self.textHeight!)
        
        if imageView.frame.width >= imageView.image?.size.width {
            self.imageView.contentMode = UIViewContentMode.Center
        } else {
            self.imageView.contentMode = UIViewContentMode.ScaleAspectFit
        }
        
        if var labelText = label.text {
            if count(labelText) == 0 {
                imageView.centerViewVerticallyInSuperview()
            }
        } else {
            imageView.centerViewVerticallyInSuperview()
        }
        
        label.frame = CGRectMake(0, self.frame.height - self.textHeight!, self.frame.width, self.textHeight!)
        
        selectedIcon.sizeToFit()
        selectedIcon.marginRight = 0
        selectedIcon.marginBottom = 0
    }
    
    override var selected : Bool {
        didSet {
            selectedIcon.hidden = multiselectEnabled && selected ? false : true
        }
    }
}
