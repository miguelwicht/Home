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
    
    var dimmer: MDWSlider?
    var colorWheel: ColorWheel?
    
    var lights: [OHLight]?
    var selectedLights = [OHLight]()
    
    var collectionViewController: OHWidgetCollectionViewController?
    var reuseIdentifier = "lightControllerReuseIdentifier"
    
    var brightnessLabel: UILabel?
    
    override func loadView() {
        super.loadView()
        
        colorWheel = ColorWheel(frame: CGRect(x: 45, y: 138, width: 237, height: 237))
        
        if var colorWheel = self.colorWheel {
            self.view.addSubview(colorWheel)
            
            colorWheel.centerViewHorizontallyInSuperview()
            colorWheel.centerViewVerticallyInSuperview()
            
            colorWheel.moveHandleToColor(UIColor.blueColor())
        }
        
//        self.dimmer = UISlider(frame: CGRectMake(0, 0, self.view.frame.width - CGFloat(20), 30))
//        self.view.addSubview(self.dimmer!)
//        dimmer!.marginTop = colorWheel!.neededSpaceHeight + 20
//        dimmer!.centerViewHorizontallyInSuperview()
//        dimmer!.addTarget(self, action: "dimmerValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        colorWheel?.button?.addTarget(self, action: "switchLight:", forControlEvents: .TouchUpInside)
        colorWheel?.addTarget(self, action: "colorValueChanged:", forControlEvents: .ValueChanged)
        
        dimmer = MDWSlider(frame: CGRect(x: 15, y: 0, width: self.view.frame.width - 30, height: 40))
        view.addSubview(dimmer!)
        dimmer!.centerViewHorizontallyInSuperview()
        dimmer!.marginBottom = 50
        dimmer!.addLeftImage(UIImage(named: "sun_small")!)
        dimmer!.addRightImage(UIImage(named: "sun_big")!)
        dimmer!.slider.addTarget(self, action: "dimmerValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
        
        brightnessLabel = UILabel()
        brightnessLabel?.text = "BRIGHTNESS"
        brightnessLabel!.font = UIFont(name: brightnessLabel!.font.familyName, size: 20)
        view.addSubview(brightnessLabel!)
    }
    
    func colorValueChanged(colorWheel: ColorWheel)
    {
        var color = colorWheel.currentColor
        var value = "10,13,10"
        
//        if var lights = self.selectedLights {
            for (index, light) in enumerate(selectedLights)
            {
                light.setColorValue(value)
            }
//        }
    }
    
    func dimmerValueChanged(dimmer: UISlider)
    {
//        if var lights = self.selectedLights {
            for (index, light) in enumerate(selectedLights)
            {
                light.setDimmerValue(Int(dimmer.value * 100))
            }
//        }
        var value = Int(dimmer.value * 100)
        if value != 0 {
            var button = colorWheel!.button as! PowerButton
            button.toggleState = true
        }
    }
    
    func switchLight(button: PowerButton)
    {
//        if var lights = self.lights {
            for (index, light) in enumerate(selectedLights)
            {
                var state = button.toggleState ? "ON" : "OFF"
                light.setState(state)
            }
//        }
    }
    
    func setWidget(widget: OHWidget)
    {
        self.widget = widget
        
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
            collectionViewController.view.marginTop = 80
            collectionViewControllerBottom = collectionViewController.view.neededSpaceHeight + 30
        }
        
        colorWheel?.marginTop = collectionViewControllerBottom
        
        brightnessLabel?.sizeToFit()
        brightnessLabel?.centerViewHorizontallyInSuperview()
        brightnessLabel?.marginTop = colorWheel!.neededSpaceHeight + 30
        
        dimmer!.marginTop = brightnessLabel!.neededSpaceHeight + 20
    }
}

extension OHLightController {
    
    func createCollectionView(widgets: [OHWidget], rows: Int)
    {
        
        
        var layout = OHWidgetCollectionViewLayout()
        layout.itemSize = CGSize(width: 40, height: 50)
        layout.minimumInteritemSpacing = 40
        collectionViewController = OHWidgetCollectionViewController(collectionViewLayout: layout, widgets: widgets)
        collectionViewController!.collectionView!.delegate = self
        collectionViewController!.collectionView!.dataSource = self
        // TODO: add function to calculate row height
        var height = CGFloat(CGFloat(rows) * (layout.itemSize.height + layout.minimumLineSpacing))
        //        height = CGFloat(rows * 120)
        
        if var collectionViewController = self.collectionViewController {
            if var collectionView = collectionViewController.collectionView {
                collectionView.registerClass(OHWidgetCell.self, forCellWithReuseIdentifier: self.reuseIdentifier)
                collectionView.allowsMultipleSelection = true
            }
            
            collectionViewController.view.frame = CGRectMake(0, 0, self.view.frame.width - 30, height)
            
            self.addChildViewController(collectionViewController)
            self.view.addSubview(collectionViewController.view)
            
            collectionViewController.view.centerViewHorizontallyInSuperview()
            collectionViewController.view.centerViewVerticallyInSuperview()
        }
        
        
        
        
        
        //        println("collectionViewFrame: \(collectionViewController.view.frame)")
        //        println("scrollView: \(self.scrollView!.frame), bounds: \(self.scrollView!.bounds)")
        
//        self.collectionViewControllers.append(collectionViewController)
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
//        var imageName: String = self.widgets![indexPath.item].icon!
//        
//        if self.widgets![indexPath.item].icon! == "none" {
//            if var item = self.widgets![indexPath.item].item {
//                if var tags = item.tags {
//                    
//                    for (index, tag) in enumerate(tags)
//                    {
//                        
//                        if tag.rangeOfString("OH_Light") != nil {
//                            imageName = "bulb"
//                            break
//                        }
//                    }
//                }
//            }
//        }
        
        cell.imageView.image = UIImage(named: "bulb")
//        cell.label.text = self.lights![indexPath.item].label
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        //        var cell = collectionView(collectionView, cellForItemAtIndexPath: indexPath)
        var cell = self.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! OHWidgetCell
        cell.imageView.backgroundColor = UIColor.purpleColor()
        cell.imageView.image = UIImage(named: "TV")
        
        if var lights = self.lights {
            var light = lights[indexPath.item]
            
            selectedLights.append(light)
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
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
}
