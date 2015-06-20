//
//  OHDropdownMenuTableViewCell.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 16/05/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import UIKit

class OHDropdownMenuTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clearColor()
        preservesSuperviewLayoutMargins = false
        contentView.backgroundColor = OHDefaults.defaultCellBackgroundColor()
        textLabel?.font = OHDefaults.defaultFontWithSize(18)
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = OHDefaults.defaultCellBackgroundColorSelected()
    }

    func prepareViewsForSelectedState() {
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
        
        if var imageView = self.imageView {
            imageView.setHeight(40)
            imageView.setWidth(40)
            imageView.centerViewVerticallyInSuperview()
            self.textLabel?.marginLeft = imageView.neededSpaceWidth + 15
        }
        
        prepareViewsForSelectedState()
    }
}
