//
//  OHDropdownMenuTableViewCell.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 16/05/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import UIKit

class OHDropdownMenuTableViewCell: UITableViewCell {
    
    var roundedCorners: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clearColor()
        preservesSuperviewLayoutMargins = false
        
        contentView.backgroundColor = OHDefaults.defaultCellBackgroundColor()
        
        textLabel?.font = OHDefaults.defaultFontWithSize(18)
        
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = OHDefaults.defaultCellBackgroundColorSelected()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func prepareViewsForSelectedState()
    {
        if self.selected || self.highlighted {
            imageView?.tintColor = UIColor.whiteColor()
            textLabel?.textColor = UIColor.whiteColor()
            tintColor = UIColor.whiteColor()
        }
        else {
            textLabel?.textColor = OHDefaults.defaultTextColor()
            imageView?.tintColor = OHDefaults.defaultTextColor()
            accessoryView?.tintColor = nil
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if roundedCorners {
//            contentView.layer.cornerRadius = 15;
//            contentView.layer.masksToBounds = true;
            let maskLayer = CAShapeLayer()
            maskLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .BottomLeft | .BottomRight, cornerRadii: CGSize(width: 30.0, height: 30.0)).CGPath
            
            layer.mask = maskLayer;
        }
        else {
//            contentView.layer.cornerRadius = 0;
//            contentView.layer.masksToBounds = false;
            
            layer.mask = nil
        }
        
        if var imageView = self.imageView {
            imageView.setHeight(40)
            imageView.setWidth(40)
            imageView.centerViewVerticallyInSuperview()
            
            self.textLabel?.marginLeft = imageView.neededSpaceWidth + 15
        }
        
        prepareViewsForSelectedState()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
