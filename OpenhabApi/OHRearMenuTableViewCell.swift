//
//  OHRearMenuTableViewCell.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 20/05/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import UIKit

class OHRearMenuTableViewCell: UITableViewCell {

    var lineView = UIView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        backgroundColor = OHDefaults.defaultCellBackgroundColor()
        preservesSuperviewLayoutMargins = true
        
        textLabel?.textColor = OHDefaults.defaultTextColor()
        textLabel?.font = OHDefaults.defaultFontWithSize(18)
        imageView?.image = UIImage(named: "bulb")?.imageWithRenderingMode(.AlwaysTemplate)
        imageView?.tintColor = OHDefaults.defaultTextColor()
        lineView.backgroundColor = UIColor(red: (194.0 / 255.0), green: (194.0 / 255.0), blue: (194.0 / 255.0), alpha: 1.0)
        addSubview(lineView)
        
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = OHDefaults.defaultCellBackgroundColorSelected()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func prepareViewsForSelectedState(){
        if self.selected || self.highlighted {
            imageView?.tintColor = UIColor.whiteColor()
            textLabel?.textColor = UIColor.whiteColor()
            tintColor = UIColor.whiteColor()
        } else {
            textLabel?.textColor = OHDefaults.defaultTextColor()
            imageView?.tintColor = OHDefaults.defaultTextColor()
            accessoryView?.tintColor = nil
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        if var imageView = self.imageView {
            imageView.setHeight(30)
            imageView.setWidth(30)
            imageView.centerViewVerticallyInSuperview()
            imageView.marginLeft = 15
            textLabel?.marginLeft = imageView.neededSpaceWidth + 10
        }
        
        lineView.setWidth(self.frame.width)
        lineView.setHeight(1)
        lineView.marginBottom = 0
        
        prepareViewsForSelectedState()
    }
}
