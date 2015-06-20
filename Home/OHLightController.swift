//
//  OHLightController.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 11/05/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import UIKit

class OHLightController: OHBaseViewController {
    
    //MARK: - Properties
    var widgets: [OHWidget]?
    var dimmer: MDWSlider?
    var colorWheel: ColorWheel?
    var saturationSlider: MDWSlider?
    let brightnessLabel = UILabel()
    
    var lights: [OHLight]? {
        didSet {
            if var lights = self.lights {
                for (index, light) in enumerate(lights) {
                    light.dimmer?.updateState()
                    light.color?.updateState()
                }
            }
        }
    }
    
    var selectedLights = [OHLight]()
    
    var collectionViewController: OHWidgetCollectionViewController?
    let reuseIdentifier = "lightControllerReuseIdentifier"
    
    //MARK: -
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = UIColor.whiteColor()
        
        initScrollView()
        createCollectionView([OHWidget](), rows: 1)
        initColorWheel()
        initDimmer()
        initBrightnessLabel()
        initSaturationSlider()
        
        addLayoutConstraints()
    }
}

//MARK: - Data initialization
extension OHLightController {
    
    func initWidget(widgets: [OHWidget]) {
        self.widgets = widgets
        
        if var colorWheel = self.colorWheel {
            colorWheel.moveHandleToColor(UIColor.yellowColor())
        }
    }
    
    func initLights(lights:[OHLight]?) {
        self.lights = lights
        self.collectionViewController?.collectionView?.reloadData()
    }
}

//MARK: - Subview initialization
extension OHLightController {
    
    func createCollectionView(widgets: [OHWidget], rows: Int) {
        var layout = OHWidgetCollectionViewLayout()
        layout.itemSize = CGSize(width: 40, height: 50)
        layout.minimumInteritemSpacing = 40
        layout.minimumLineSpacing = 25
        
        collectionViewController = OHWidgetCollectionViewController(collectionViewLayout: layout, widgets: widgets)
        collectionViewController!.collectionView!.delegate = self
        collectionViewController!.collectionView!.dataSource = self
        
        var height = CGFloat(CGFloat(rows) * (layout.itemSize.height + layout.minimumLineSpacing)) - layout.minimumLineSpacing
        height = rows == 1 ? layout.itemSize.height : height
        
        if var collectionViewController = self.collectionViewController {
            if var collectionView = collectionViewController.collectionView {
                collectionView.registerClass(OHWidgetCell.self, forCellWithReuseIdentifier: self.reuseIdentifier)
                collectionView.allowsMultipleSelection = true
            }
            
            collectionViewController.view.frame = CGRectMake(0, 0, self.view.frame.width - 30, height)
            self.addChildViewController(collectionViewController)
            contentView.addSubview(collectionViewController.view)
            
            collectionViewController.view.centerViewHorizontallyInSuperview()
            collectionViewController.view.centerViewVerticallyInSuperview()
        }
    }
    
    func initColorWheel() {
        colorWheel = ColorWheel(frame: CGRect(x: 45, y: 138, width: 237, height: 237))
        
        if var colorWheel = self.colorWheel {
            contentView.addSubview(colorWheel)
            colorWheel.moveHandleToColor(UIColor.blueColor())
            colorWheel.button?.addTarget(self, action: "switchLight:", forControlEvents: .TouchUpInside)
            colorWheel.addTarget(self, action: "colorValueChanged:", forControlEvents: .ValueChanged)
        }
    }
    
    func initBrightnessLabel() {
        brightnessLabel.text = "Brightness".uppercaseString
        brightnessLabel.font = OHDefaults.defaultFontWithSize(20)
        brightnessLabel.textAlignment = NSTextAlignment.Center
        contentView.addSubview(brightnessLabel)
    }
    
    func initDimmer() {
        dimmer = MDWSlider(frame: CGRect(x: 0, y: 0, width: 0, height: 40))
        
        if var dimmer = self.dimmer {
            contentView.addSubview(dimmer)
            dimmer.centerViewHorizontallyInSuperview()
            dimmer.marginBottom = 50
            dimmer.addLeftImage(UIImage(named: "sun_small")!)
            dimmer.addRightImage(UIImage(named: "sun_big")!)
            dimmer.slider.addTarget(self, action: "dimmerValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
        }
    }
    
    func initSaturationSlider() {
        saturationSlider = MDWSlider(frame: CGRect(x: 0, y: 0, width: 0, height: 40))
        
        if var saturationSlider = self.saturationSlider {
            contentView.addSubview(saturationSlider)
            saturationSlider.addLeftImage(UIImage(named: "sun_small")!)
            saturationSlider.addRightImage(UIImage(named: "sun_big")!)
            saturationSlider.slider.addTarget(self, action: "saturationSliderValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
        }
    }
    
    func addLayoutConstraints() {
        var views = [String: AnyObject]()
        views["collectionView"]     = collectionViewController!.view
        views["colorWheel"]         = colorWheel
        views["brightnessLabel"]    = brightnessLabel
        views["dimmer"]             = dimmer
        views["saturationSlider"]   = saturationSlider
        
        colorWheel!.setTranslatesAutoresizingMaskIntoConstraints(false)
        brightnessLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        dimmer!.setTranslatesAutoresizingMaskIntoConstraints(false)
        saturationSlider!.setTranslatesAutoresizingMaskIntoConstraints(false)
        collectionViewController?.view.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        // Height and vertical constraints
        var collectionView = collectionViewController!.view
        var collectionViewHeight = collectionViewController!.view.frame.height
        contentView.addConstraint(NSLayoutConstraint(item: collectionView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Height, multiplier: 0.0, constant: collectionViewHeight))
        contentView.addConstraint(NSLayoutConstraint(item: dimmer!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Height, multiplier: 0.0, constant: 40))
        contentView.addConstraint(NSLayoutConstraint(item: saturationSlider!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Height, multiplier: 0.0, constant: 40))
        contentView.addConstraint(NSLayoutConstraint(item: colorWheel!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Height, multiplier: 0.0, constant: colorWheel!.frame.height))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(15)-[collectionView]-(15)-[colorWheel]-(15)-[brightnessLabel]-(15)-[dimmer]-(15)-[saturationSlider]", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: views))
        
        // Width and horizontal constraints
        contentView.addConstraint(NSLayoutConstraint(item: colorWheel!, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: colorWheel!, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Width, multiplier: 0.0, constant: colorWheel!.frame.width))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(15)-[brightnessLabel]-(15)-|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(15)-[dimmer]-(15)-|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(15)-[saturationSlider]-(15)-|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[collectionView]|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: views))
        
        // ScrollView height
        var scrollViewHeightConstraint = NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: saturationSlider, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 15)
        view.addConstraint(scrollViewHeightConstraint)
    }
}

//MARK: - EventHandler
extension OHLightController {
    
    func saturationSliderValueChanged(slider: UISlider) {
        if var colorWheel = self.colorWheel {
            colorWheel.saturation = CGFloat(slider.value)
            println(colorWheel.saturation)
        }
    }
    
    func colorValueChanged(colorWheel: ColorWheel) {
        var color = colorWheel.currentColor
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        var success = color?.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        hue *= 360
        saturation *= 100
        brightness *= 100
        
        var value = "\(Int(hue)),\(Int(saturation)),\(Int(brightness))"
        
        for (index, light) in enumerate(selectedLights) {
            light.setColorValue(value)
        }
    }
    
    func dimmerValueChanged(dimmer: UISlider) {
        if var colorWheel = self.colorWheel {
            colorWheel.brightness = CGFloat(dimmer.value)
            println(colorWheel.brightness)
        }
        
        for (index, light) in enumerate(selectedLights) {
            light.setDimmerValue(Int(dimmer.value * 100))
        }
        
        var value = Int(dimmer.value * 100)
        if value != 0 {
            var button = colorWheel!.button as! PowerButton
            button.toggleState = true
        }
    }
    
    func switchLight(button: PowerButton) {
        for (index, light) in enumerate(selectedLights) {
            var state = button.toggleState ? "ON" : "OFF"
            light.setState(state)
        }
    }
}

//MARK: - UICollectionViewDataSource
extension OHLightController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var numberOfItems = 0
        
        if var lights =  self.lights {
            numberOfItems = lights.count
        }
        
        return numberOfItems
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(self.reuseIdentifier, forIndexPath: indexPath) as! OHWidgetCell
        cell.multiselectEnabled = true
        cell.layoutSubviews()
        
        cell.imageView.image = UIImage(named: "bulb")
//        cell.label.text = self.lights![indexPath.item].label
        cell.label.text = "blub"
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var cell = self.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! OHWidgetCell
        cell.imageView.backgroundColor = UIColor.purpleColor()
        cell.imageView.image = UIImage(named: "TV")
        
        if var lights = self.lights {
            var light = lights[indexPath.item]
            selectedLights.append(light)
            
            if var dimmer = light.dimmer {
                var value: Float = (dimmer.state as NSString).floatValue
                self.dimmer?.slider.setValue(value / 100, animated: true)
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        if var lights = self.lights {
            var light = lights[indexPath.item]
            
            var selectedLightsArray = selectedLights as NSArray
            var index = selectedLightsArray.indexOfObject(light)
            
            selectedLights.removeAtIndex(index)
        }
    }
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func collectionView(collectionView: UICollectionView, shouldDeselectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
}

//MARK: - UICollectionViewDelegate
extension OHLightController: UICollectionViewDelegate {}

//MARK: - OHBaseViewController overwrites
extension OHLightController {
    
    override func addLeftNavigationBarItems(){}
    override func addRightNavigationBarItems(){}
}
