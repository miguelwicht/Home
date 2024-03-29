//
//  UIImage+Extension.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 08/06/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import UIKit

extension UIImage {
    
    class func imageWithColor(color:UIColor?) -> UIImage! {
        let rect = CGRectMake(0.0, 0.0, 1.0, 1.0);
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        let context = UIGraphicsGetCurrentContext();
        
        if let color = color {
            color.setFill()
        }
        else {
            UIColor.whiteColor().setFill()
        }
        
        CGContextFillRect(context, rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image;
    }
}
