//
//  OHLightController.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 11/05/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import UIKit

class OHLightController: UIViewController {
    var widget: OHWidget?
    
    var dimmer: UISlider?
    var color: UISlider?
    
    override func loadView() {
        super.loadView()
        
        self.color = UISlider(frame: CGRectMake(0, 0, self.view.frame.width - CGFloat(20), 30))
        self.view.addSubview(self.color!)
        
        self.dimmer = UISlider(frame: CGRectMake(0, 0, self.view.frame.width - CGFloat(20), 30))
        self.view.addSubview(self.dimmer!)
        
        self.view.backgroundColor = UIColor.whiteColor()

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if var colorSlider = self.color {
            colorSlider.marginTop = 50
            colorSlider.centerViewHorizontallyInSuperview()
        }
        
        if var dimmerSlider = self.dimmer {
            dimmerSlider.marginTop = self.color!.neededSpaceHeight + 50
            dimmerSlider.centerViewHorizontallyInSuperview()
        }
    }
}
