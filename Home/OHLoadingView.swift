//
//  OHLoadingView.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 10/06/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import UIKit

class OHLoadingView: UIView {
    
    let activityIndicator = UIActivityIndicatorView()
    
    override internal init(frame: CGRect) {
        super.init(frame: frame)
        
        addSpinner()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        addSpinner()
    }

    
    func addSpinner() {
        self.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        self.backgroundColor = UIColor.colorFromRGB(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        activityIndicator.centerViewHorizontallyInSuperview()
        activityIndicator.centerViewVerticallyInSuperview()
    }
}
