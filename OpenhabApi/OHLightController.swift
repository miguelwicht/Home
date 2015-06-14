//
//  OHLightController.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 11/05/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import UIKit

class OHLightController: UIViewController {
    
    let scrollView = UIScrollView()
    var widgets: [OHWidget]?
    var dimmer: MDWSlider?
    var colorWheel: ColorWheel?
    var saturationSlider: MDWSlider?
    
    var lights: [OHLight]?
    var selectedLights = [OHLight]()
    
    var collectionViewController: OHWidgetCollectionViewController?
    let reuseIdentifier = "lightControllerReuseIdentifier"
    
    let brightnessLabel = UILabel()
    
    
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = UIColor.whiteColor()
        view.addSubview(self.scrollView)
        scrollView.frame = view.frame
        
        initColorWheel()
        initDimmer()
        initBrightnessLabel()
        initSaturationSlider()
    }
    
    func initColorWheel()
    {
        colorWheel = ColorWheel(frame: CGRect(x: 45, y: 138, width: 237, height: 237))
        
        if var colorWheel = self.colorWheel {
            scrollView.addSubview(colorWheel)
            
            colorWheel.centerViewHorizontallyInSuperview()
            colorWheel.centerViewVerticallyInSuperview()
            
            colorWheel.moveHandleToColor(UIColor.blueColor())
            
            colorWheel.button?.addTarget(self, action: "switchLight:", forControlEvents: .TouchUpInside)
            colorWheel.addTarget(self, action: "colorValueChanged:", forControlEvents: .ValueChanged)
        }
    }
    
    func initSaturationSlider(){
        saturationSlider = MDWSlider(frame: CGRect(x: 15, y: 0, width: self.scrollView.frame.width - 30, height: 40))
        
        if var saturationSlider = self.saturationSlider {
            scrollView.addSubview(saturationSlider)
            saturationSlider.centerViewHorizontallyInSuperview()
//            saturationSlider.marginBottom = 50
            saturationSlider.addLeftImage(UIImage(named: "sun_small")!)
            saturationSlider.addRightImage(UIImage(named: "sun_big")!)
            saturationSlider.slider.addTarget(self, action: "saturationSliderValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
        }
    }
    
    func saturationSliderValueChanged(slider: UISlider)
    {
        if var colorWheel = self.colorWheel {
            colorWheel.saturation = CGFloat(slider.value)
            println(colorWheel.saturation)
        }
        
//        for (index, light) in enumerate(selectedLights)
//        {
//            light.setDimmerValue(Int(slider.value * 100))
//        }
//        
//        var value = Int(slider.value * 100)

    }
    
    func initDimmer()
    {
        dimmer = MDWSlider(frame: CGRect(x: 15, y: 0, width: self.scrollView.frame.width - 30, height: 40))
        
        if var dimmer = self.dimmer {
            scrollView.addSubview(dimmer)
            dimmer.centerViewHorizontallyInSuperview()
            dimmer.marginBottom = 50
            dimmer.addLeftImage(UIImage(named: "sun_small")!)
            dimmer.addRightImage(UIImage(named: "sun_big")!)
            dimmer.slider.addTarget(self, action: "dimmerValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
        }
    }
    
    func initBrightnessLabel()
    {
        brightnessLabel.text = "Brightness".uppercaseString
        brightnessLabel.font = OHDefaults.defaultFontWithSize(20)
        scrollView.addSubview(brightnessLabel)
    }
    
    func colorValueChanged(colorWheel: ColorWheel)
    {
        var color = colorWheel.currentColor
        
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        
        var success = color?.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
//        println("success: \(success), hue: \(hue), saturation: \(saturation), brightness: \(brightness), alpha: \(alpha)")
        
        //BOOL success = [testColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
//        NSLog(@"success: %i hue: %0.2f, saturation: %0.2f, brightness: %0.2f, alpha: %0.2f", success, hue, saturation, brightness, alpha);
        
        hue *= 360
        saturation *= 100
        brightness *= 100
        
        
        var value = "\(Int(hue)),\(Int(saturation)),\(Int(brightness))"
//        println("\(value)")
        for (index, light) in enumerate(selectedLights)
        {
            light.setColorValue(value)
        }
    }
    
    func dimmerValueChanged(dimmer: UISlider)
    {
        if var colorWheel = self.colorWheel {
            colorWheel.brightness = CGFloat(dimmer.value)
            println(colorWheel.brightness)
        }
        
        for (index, light) in enumerate(selectedLights)
        {
//            light.setDimmerValue(Int(dimmer.value * 100))
        }
        
        var value = Int(dimmer.value * 100)
        if value != 0 {
            var button = colorWheel!.button as! PowerButton
            button.toggleState = true
        }
    }
    
    func switchLight(button: PowerButton)
    {
        for (index, light) in enumerate(selectedLights)
        {
            var state = button.toggleState ? "ON" : "OFF"
            light.setState(state)
        }
    }
    
    func initWidget(widgets: [OHWidget])
    {
        self.widgets = widgets
        
        if var colorWheel = self.colorWheel {
            colorWheel.moveHandleToColor(UIColor.yellowColor())
        }
    }
    
    func initLights(lights:[OHLight]?)
    {
        self.lights = lights
        
        createCollectionView([OHWidget](), rows: 1)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        var collectionViewControllerBottom = CGFloat(60)
        
        if var collectionViewController = self.collectionViewController {
            collectionViewController.view.marginTop = 20
            collectionViewControllerBottom = collectionViewController.view.neededSpaceHeight + 30
        }
        
        colorWheel?.marginTop = collectionViewControllerBottom
        
        brightnessLabel.sizeToFit()
        brightnessLabel.centerViewHorizontallyInSuperview()
        brightnessLabel.marginTop = colorWheel!.neededSpaceHeight + 30
        
        dimmer!.marginTop = brightnessLabel.neededSpaceHeight + 20
        
        if var dimmer = self.dimmer {
            saturationSlider!.marginTop = dimmer.neededSpaceHeight + 20
        }
    }
}

extension OHLightController {
    
    func createCollectionView(widgets: [OHWidget], rows: Int)
    {
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
            scrollView.addSubview(collectionViewController.view)
            
            collectionViewController.view.centerViewHorizontallyInSuperview()
            collectionViewController.view.centerViewVerticallyInSuperview()
        }
    }
}

extension OHLightController: UICollectionViewDelegate {

}

extension OHLightController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        var numberOfItems = 0
        
        if var lights =  self.lights {
            numberOfItems = lights.count
        }
        
        return numberOfItems
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(self.reuseIdentifier, forIndexPath: indexPath) as! OHWidgetCell
        cell.multiselectEnabled = true
        cell.layoutSubviews()
        
        cell.imageView.image = UIImage(named: "bulb")
//        cell.label.text = self.lights![indexPath.item].label
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        var cell = self.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! OHWidgetCell
        cell.imageView.backgroundColor = UIColor.purpleColor()
        cell.imageView.image = UIImage(named: "TV")
        
        if var lights = self.lights {
            var light = lights[indexPath.item]
            
            selectedLights.append(light)
        }
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath)
    {
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
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
}
