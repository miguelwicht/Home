//
//  MDWSlider.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 02/06/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import UIKit

class MDWSlider: UIControl {
    
    var leftImageView: UIImageView?
    var rightImageView: UIImageView?
    var slider = UISlider()
//    var value = 0
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        addSubview(slider)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(slider)
        slider.tintColor = UIColor(red: CGFloat(52.0 / 255.0), green: CGFloat(73.0 / 255.0), blue: CGFloat(94.0 / 255.0), alpha: 1.0)
        slider.maximumTrackTintColor = UIColor(red: CGFloat(68.0 / 255.0), green: CGFloat(68.0 / 255.0), blue: CGFloat(68.0 / 255.0), alpha: 0.25)
        
        var leftImage = UIImage(named: "slider_left")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        leftImage = leftImage!.stretchableImageWithLeftCapWidth(3, topCapHeight: 0)
        var rightImage = UIImage(named: "slider_right")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        rightImage = rightImage!.resizableImageWithCapInsets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 3))
        slider.setMinimumTrackImage(leftImage, forState: .Normal)
        slider.setMaximumTrackImage(rightImage, forState: .Normal)
        
//        slider.addTarget(self, action: "valueChanged:", forControlEvents: UIControlEvents.ValueChanged)
    }
    
//    func valueChanged(slider: UISlider)
//    {
//        value = slider.value
//        
//        self.sendActionsForControlEvents(UIControlEvents.ValueChanged)
//    }
    
    func addLeftImage(image: UIImage)
    {
        if var leftImageView = self.leftImageView {
            leftImageView.image = image
        }
        else
        {
            leftImageView = UIImageView(image: image)
            addSubview(leftImageView!)
        }
    }
    
    func addRightImage(image: UIImage)
    {
        if var rightImageView = self.rightImageView {
            rightImageView.image = image
        }
        else
        {
            rightImageView = UIImageView(image: image)
            addSubview(rightImageView!)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var leftMargin = CGFloat(0)
        var rightMargin = CGFloat(0)
        
        if var leftImageView = self.leftImageView {
            leftImageView.marginLeft = 0
            leftImageView.sizeToFit()
            leftMargin = leftImageView.neededSpaceWidth
            
        }
        
        if var rightImageView = self.rightImageView {
            rightImageView.marginRight = 0
            rightImageView.sizeToFit()
            rightMargin = frame.width - rightImageView.frame.origin.x
        }
        
        slider.setWidth(frame.width - leftMargin - rightMargin)
        slider.centerViewHorizontallyInSuperview()
        slider.centerViewVerticallyInSuperview()
    }
    
}
