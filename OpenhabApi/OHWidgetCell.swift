//
//  OHWidgetCell.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 28/04/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import UIKit

class OHWidgetCell: UICollectionViewCell {
    
    var imageView: UIImageView?
    var label: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initOutlets()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initOutlets()
    }
    
    func initOutlets() {
        self.imageView = UIImageView()
        self.label = UILabel()
        
        self.addSubview(self.imageView!)
        self.addSubview(self.label!)
    }
    
    override func prepareForReuse()
    {
        super.prepareForReuse()
        
//        self.initOutlets()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        println("layoutSubviews")
        
        if var imageView = self.imageView {
            imageView.frame = CGRectMake(0, 0, self.frame.width, self.frame.height - 40)
//            imageView.backgroundColor = UIColor.blueColor()
            imageView.contentMode = UIViewContentMode.ScaleAspectFit
//            imageView.sizeToFit()
        }
        
        if var label = self.label {
            label.frame = CGRectMake(0, self.frame.height - 40, self.frame.width, 40)
//            label.backgroundColor = UIColor.brownColor()
            label.textAlignment = NSTextAlignment.Center
        }
    }
}
