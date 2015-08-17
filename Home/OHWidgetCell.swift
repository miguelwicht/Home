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

    required init?(coder aDecoder: NSCoder) {
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
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.addSubview(selectedIcon)
        
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true
        
        addLayoutContraints()
    }
    
    func addLayoutContraints(){
        
        var views = [String: AnyObject]()
        views["imageView"] = imageView
        views["label"] = label
        views["selectedIcon"] = selectedIcon
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        selectedIcon.translatesAutoresizingMaskIntoConstraints = false
        calculateTextHeight()
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[imageView]-(==5@999)-[label(==\(textHeight!)@1000)]|", options: [], metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[imageView]|", options: [], metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[label]|", options: [], metrics: nil, views: views))
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[selectedIcon]-(10)-|", options: NSLayoutFormatOptions(), metrics: nil, views: views))
        addConstraint(NSLayoutConstraint(item: selectedIcon, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: label, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: -2))
        addConstraint(NSLayoutConstraint(item: selectedIcon, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: label, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: -2))
    }
    
    func calculateTextHeight() {
        let dummyText: NSString = "LoremIpsumg"
        let font = OHDefaults.defaultLightFontWithSize(14)!
        let textSize: CGSize = dummyText.sizeWithAttributes([NSFontAttributeName:font])
        textHeight = textSize.height
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override var selected : Bool {
        didSet {
            selectedIcon.hidden = multiselectEnabled && selected ? false : true
        }
    }
}
