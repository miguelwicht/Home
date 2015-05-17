//
//  ButtonWithCustomBackgroundSize.swift
//  graphicsTests
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 21/04/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import UIKit

class ButtonWithCustomBackgroundSize: UIButton {
    
    override func backgroundRectForBounds(bounds: CGRect) -> CGRect {
        let result: CGRect = super.backgroundRectForBounds(bounds)
        let backgroundRect = CGRectInset(result, -40, -40)
        
        return backgroundRect
    }
}
