//
//  UIColor+Extension.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 08/06/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import UIKit

extension UIColor {
    
    class func colorFromRGB(red red: Int, green: Int, blue: Int) -> UIColor {
        return UIColor.colorFromRGB(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    class func colorFromRGB(red red: Int, green: Int, blue: Int, alpha: CGFloat) -> UIColor {
        return UIColor(red: (CGFloat(red) / 255.0), green: (CGFloat(green) / 255.0), blue: (CGFloat(blue) / 255.0), alpha: alpha)
    }
    
}
