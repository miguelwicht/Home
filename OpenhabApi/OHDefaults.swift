//
//  OHDefaults.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 04/06/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import UIKit

class OHDefaults {}

//MARK: Fonts
extension OHDefaults {
    static func defaultFontName() -> String {
        return "Muli"
    }
    
    static func defaultLightFontName() -> String {
        return "Muli-Light"
    }
    
    static func defaultFontSize() -> CGFloat {
        return CGFloat(17.0)
    }
    
    static func defaultFontWithSize(size: CGFloat) -> UIFont? {
        return UIFont(name: OHDefaults.defaultFontName(), size: size)
    }
    
    static func defaultLightFontWithSize(size: CGFloat) -> UIFont? {
        return UIFont(name: OHDefaults.defaultLightFontName(), size: size)
    }
}

//MARK: Colors
extension OHDefaults {
    
    static func defaultNavigationBarColor() -> UIColor {
        return UIColor.colorFromRGB(red: 248, green: 248, blue: 248, alpha: 1.0)
    }
    
    static func defaultTextColor() -> UIColor {
        return UIColor.colorFromRGB(red: 68, green: 68, blue: 68, alpha: 1.0)
    }
    
    static func defaultTextColorLight() -> UIColor {
        return UIColor.colorFromRGB(red: 133, green: 133, blue: 133, alpha: 1.0)
    }
}

extension OHDefaults {
//    static func rearMenuCellHighlightedColor() -> UIColor {
//        return UIColor.colorFromRGB(red: 52, green: 73, blue: 94, alpha: 1.0)
//    }
//    
//    static func rearMenuCellSelectedColor() -> UIColor {
//        return UIColor.colorFromRGB(red: 52, green: 73, blue: 94, alpha: 1.0)
//    }
    
    static func defaultCellBackgroundColor() -> UIColor {
        return UIColor.colorFromRGB(red: 236, green: 240, blue: 241, alpha: 1.0)
    }
    
    static func defaultCellBackgroundColorSelected() -> UIColor {
        return UIColor.colorFromRGB(red: 52, green: 73, blue: 94, alpha: 1.0)
    }
    
    static func defaultCellBackgroundColorHighlighted() -> UIColor {
        return UIColor.colorFromRGB(red: 52, green: 73, blue: 94, alpha: 1.0)
    }
}

