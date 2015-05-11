//
//  ViewSetter.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 06/05/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import UIKit

enum Gravity {
    case Top
    case Right
    case Bottom
    case Left
}

extension UIView {
    
    var marginTop: CGFloat {
        get {
            return self.frame.origin.y
        }
        set(margin) {
            self.frame.origin.y = margin
        }
    }
    
    var marginRight: CGFloat {
        get {
            return self.superview!.frame.width - self.frame.origin.x - self.frame.width
        }
        set(margin) {
            self.frame.origin.x = self.superview!.frame.width - self.frame.width - margin
        }
    }
    
    var marginBottom: CGFloat {
        get {
            return self.frame.origin.y + self.frame.height
        }
        set(margin) {
            self.frame.origin.y = self.superview!.frame.height - self.frame.height - margin
        }
    }
    
    var marginLeft: CGFloat {
        get {
            return self.frame.origin.x
        }
        
        set(margin) {
            self.frame.origin.x = margin
        }
    }
    
    var neededSpaceHeight: CGFloat {
        get {
            return self.frame.origin.y + self.frame.height
        }
    }
    
    var neededSpaceWidth: CGFloat {
        get {
            return self.frame.origin.y + self.frame.width
        }
    }
    
    func centerViewHorizontallyInSuperview() {
        self.marginLeft = CGFloat((self.superview!.frame.width - self.frame.width) / CGFloat(2))
    }
    
    func centerViewVerticallyInSuperview() {
        self.marginTop = CGFloat((self.superview!.frame.height - self.frame.height) / CGFloat(2))
    }
    
}
