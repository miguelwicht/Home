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
        // Initialization code
        
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor(red: (236.0 / 255.0), green: (236.0 / 255.0), blue: (236.0 / 255.0), alpha: 1.0)
//        backgroundColor = UIColor.blueColor()
        preservesSuperviewLayoutMargins = false
        
//        var myCustomSelectionColorView = UIView(frame: self.frame)
//        myCustomSelectionColorView.backgroundColor = UIColor.greenColor()
//        self.selectedBackgroundView = myCustomSelectionColorView
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
