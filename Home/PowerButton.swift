//
//  PowerButton.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 02/06/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import UIKit

class PowerButton: ButtonWithCustomBackgroundSize {
    
    var iconView: UIImageView = UIImageView()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        iconView.image = UIImage(named: "power")
        iconView.sizeToFit()
        addSubview(iconView)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        iconView.image = UIImage(named: "power")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        iconView.sizeToFit()
        addSubview(iconView)
        
        toggleState = toggleState ? true : false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconView.centerViewVerticallyInSuperview()
        iconView.centerViewHorizontallyInSuperview()
    }
    
    func buttonPressed(button: PowerButton) {
        button.toggleState = button.toggleState ? false : true
    }
    
    var toggleState : Bool = false {
        didSet {
            if toggleState {
                iconView.tintColor = UIColor(red: (39.0 / 255.0), green: (174.0 / 255.0), blue: (96.0 / 255.0), alpha: 1.0)
            }
            else {
                iconView.tintColor = UIColor.blackColor()
            }
        }
    }
}
