//
//  OHWidgetCollectionViewController.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 28/04/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import UIKit

class OHWidgetCollectionViewController: UICollectionViewController {
    
    var widgets: [OHWidget]?
    var layout: UICollectionViewFlowLayout?
    var numberOfItemsPerSection: Int = 6 // Deprecated
    var reuseIdentifier: String = "reuseIdentifier"
    var leftArrowButton = UIButton(frame: CGRectMake(0, 0, 20, 20))
    var rightArrowButton = UIButton(frame: CGRectMake(0, 0, 20, 20))
    var parentVC: UIViewController?
    
    var selectedWidgets = [OHWidget]()
    
    var pageControl: UIPageControl? {
        didSet {
            pageControl!.addTarget(self, action: "pageControlValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
            
            pageControl!.numberOfPages = self.numberOfPages
            pageControl!.hidesForSinglePage = true
        }
    }
    
    var numberOfPages: Int {
        get {
            var pageWidth = collectionView!.frame.size.width
            var numberOfPages = Int(collectionView!.contentSize.width / pageWidth)
            
            return numberOfPages
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.view.setHeight(pageControl.neededSpaceHeight)
        
        
//        var viewIsCollectionView = collectionView! == view ? true : false
        
        
    }
    
    required init(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(collectionViewLayout layout: UICollectionViewLayout)
    {
//        self.widgets = [OHWidget]()
        self.layout = layout as? UICollectionViewFlowLayout
        super.init(collectionViewLayout: layout)

        collectionView!.registerClass(OHWidgetCell.self, forCellWithReuseIdentifier: self.reuseIdentifier)
        configurateCollectionView()
//        collectionView?.allowsMultipleSelection = true
        
        
    }
    
    convenience init(collectionViewLayout layout: UICollectionViewLayout, widgets: [OHWidget]) {
        
        self.init(collectionViewLayout: layout)
        self.setDataForWidgets(widgets)
    }

    override func loadView()
    {
        super.loadView()
        
        self.collectionView!.reloadData()

//        leftArrowButton.setImage(UIImage(named: "arrow_left"), forState: .Normal)
//        leftArrowButton.imageView?.contentMode = UIViewContentMode.Center
//        self.view.addSubview(leftArrowButton)
//        
//        rightArrowButton.setImage(UIImage(named: "arrow_right"), forState: .Normal)
//        rightArrowButton.imageView?.contentMode = UIViewContentMode.Center
//        self.view.addSubview(rightArrowButton)
        
        self.view.backgroundColor = UIColor.purpleColor()
    }
    
    override func viewWillLayoutSubviews()
    {
        super.viewWillLayoutSubviews()
        
//        self.leftArrowButton.marginTop = (self.view.frame.height / 2) - (self.leftArrowButton.frame.height / 2)
//        self.rightArrowButton.marginTop = (self.view.frame.height / 2) - (self.leftArrowButton.frame.height / 2)
//        self.rightArrowButton.marginLeft = self.view.frame.width - self.rightArrowButton.frame.width
        
//        println("CollectionViewController.ViewWillLayoutSubViews: collectionViewFrame: \(self.collectionView!.frame)")
//        println("CollectionViewController.ViewWillLayoutSubViews: viewFrame: \(self.view.frame)")
        
//        pageControl.sizeToFit()
////        pageControl.marginBottom = 0
//        pageControl.centerViewHorizontallyInSuperview()
////        pageControl.centerViewVerticallyInSuperview()
        
//        var frame = pageControl.frame
//        
//        pageControl.marginTop = collectionView!.neededSpaceHeight
//        self.view.sizeToFit()
     
        pageControl?.numberOfPages = numberOfPages
        
//        pageControl?.hidden = numberOfPages <= 1 ? true : true
//        pageControl?.dis
    }
    
    func configurateCollectionView()
    {
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.backgroundColor = UIColor.whiteColor()
        collectionView!.pagingEnabled = true
        collectionView!.showsHorizontalScrollIndicator = false
//        self.collectionView?.backgroundColor = UIColor.greenColor()
//        self.view.backgroundColor = UIColor.purpleColor()
    }
    
    func setDataForWidgets(widgets: [OHWidget])
    {
        self.widgets = widgets
//        println("DATA FOR WIDGETS")
//        println(self.widgets)
        self.collectionView!.reloadData()
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        
////        addGradientMask()
//    }
}

//MARK: Gradient Fade
extension OHWidgetCollectionViewController {
    
    func addGradientMask()
    {
        let gradientMask = CAGradientLayer()
        gradientMask.bounds = self.view.bounds
        println(gradientMask.bounds)
        gradientMask.position = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
        gradientMask.shouldRasterize = true;
        gradientMask.rasterizationScale =  UIScreen.mainScreen().scale  //[UIScreen mainScreen].scale;
        gradientMask.startPoint = CGPointMake(0.0, CGRectGetMidY(self.view.bounds))
        gradientMask.endPoint = CGPointMake(1.0, CGRectGetMidY(self.view.bounds))
        
        gradientMask.colors = [UIColor.clearColor().CGColor, UIColor.blackColor().CGColor, UIColor.blackColor().CGColor, UIColor.clearColor().CGColor]
        
        //        let fadePoint: CGFloat = 100 / CGRectGetWidth(viewWithMask.bounds);
        let fadePoint: CGFloat = 0.1
        let leftFadePoint: CGFloat = fadePoint
        let rightFadePoint: CGFloat = CGFloat(1 - fadePoint)
        // apply calculations to mask
        gradientMask.locations = [0, leftFadePoint, rightFadePoint, 1]
        //        viewWithMask.layer.mask = gradientMask;
        //        viewWithMask.layer.cornerRadius = 50
        //        viewWithMask.layer.masksToBounds = false
        //        self.view.addSubview(viewWithMask)
        //        viewWithMask.addSubview(imageView)
        //        self.view.layer.masksToBounds = true
        self.view.layer.mask = gradientMask
    }
}

// MARK: UICollectionViewDataSource
extension OHWidgetCollectionViewController: UICollectionViewDataSource {
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        var numberOfItems = 0
        
        if var widgets =  self.widgets {
            numberOfItems = widgets.count
        }
        
        return numberOfItems
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(self.reuseIdentifier, forIndexPath: indexPath) as! OHWidgetCell
        
        var imageName: String = self.widgets![indexPath.item].icon!
        
        if self.widgets![indexPath.item].icon! == "none" {
            if var item = self.widgets![indexPath.item].item {
                if var tags = item.tags {
                    
                    for (index, tag) in enumerate(tags)
                    {
                       
                        if tag.rangeOfString("OH_Light") != nil {
                            imageName = "bulb"
                            break
                        }
                    }
                }
            }
        }
        
        cell.imageView.image = UIImage(named: imageName)
        cell.label.text = self.widgets![indexPath.item].label
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
//        var cell = collectionView(collectionView, cellForItemAtIndexPath: indexPath)
        var cell = self.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! OHWidgetCell
        cell.imageView.backgroundColor = UIColor.purpleColor()
        cell.imageView.image = UIImage(named: "TV")
//        cell.layoutSubviews()
//        cell.selectedBackgroundView.backgroundColor = UIColor.purpleColor()
//        cell.selected
        
//        var vc = OHLightController()
//        vc.title = cell.label.text
//        self.parentViewController!.navigationController?.pushViewController(vc, animated: true)
        
        
        
//        if self.widgets![indexPath.item].icon! == "none" {
            if var item = self.widgets![indexPath.item].item {
                if var tags = item.tags {
                    
                    for (index, tag) in enumerate(tags)
                    {
                        
                        if tag.rangeOfString("OH_Light") != nil {
                            pushLightsController(widgets![indexPath.item])
                            break
                        }
                        
                        if tag.rangeOfString("OH_Scene") != nil {
                            println("Trigger Scene")
                            item.sendCommand("ON")
                            break
                        }
                    }
                }
//            }
        }
    
        
        
        
        
        
        
        
        
        
        
//        
//        if var widgets = self.widgets {
//            
//            
//            
//            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
////            var dataManager = appDelegate.dataManager
//            
//            if var bulbs = widgets[indexPath.item].linkedPage?.widgets {
//                
//                vc.initWidget(bulbs)
//                
//                var lights = [OHLight]()
//                
//                for (index, bulb) in enumerate(bulbs)
//                {
//                    var light = OHLight(widget: bulb)
//                    lights.append(light)
//                }
//                
//                vc.initLights(lights)
//            }
//        }

    }
    
    func pushLightsController(widget: OHWidget)
    {
        var vc = OHLightController()
        vc.title = widget.label
        self.parentViewController!.navigationController?.pushViewController(vc, animated: true)
        
        if var bulbs = widget.linkedPage?.widgets {
            
            vc.initWidget(bulbs)
            
            var lights = [OHLight]()
            
            for (index, bulb) in enumerate(bulbs)
            {
                var light = OHLight(widget: bulb)
                lights.append(light)
            }
            
            vc.initLights(lights)
        }
    }
    
    
//    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
//        return false
//    }
//    
//    override func collectionView(collectionView: UICollectionView, shouldDeselectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
//        return false
//    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
}

extension OHWidgetCollectionViewController {
    
    func getControllerForTags(tags: [String]) {
        if tags.count > 0 {
//            println(tags)
            var vc = OHLightController()
            
//            println(self.parentViewController)
            self.parentVC?.navigationController?.pushViewController(vc, animated: true)
//                self.navigationController?
//            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
}

// MARK: Deprecated
extension OHWidgetCollectionViewController {
    
    func calculateNumberOfItemsPerSection(collectionView: UICollectionView, section: Int) -> Int
    {
        var itemsInSection: Int?
        
        if (self.numberOfSectionsInCollectionView(collectionView) - (section + 1) > 0)
        {
            itemsInSection = self.numberOfItemsPerSection
        }
        else {
            itemsInSection =  self.numberOfItemsPerSection - (self.numberOfItemsPerSection * (section + 1) - self.widgets!.count)
        }
        
        return itemsInSection!
    }
    
    func calculateNumberSectionsInCollectionView() -> Int
    {
        var numberOfSections = Int(ceil(CGFloat(self.widgets!.count) / CGFloat(self.numberOfItemsPerSection)))
//        println("numberOfSections: \(numberOfSections)")
        
        return numberOfSections
    }
}

extension OHWidgetCollectionViewController: UIScrollViewDelegate {
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
//        super.scrollViewDidEndDecelerating(scrollView)
        
        var pageWidth = collectionView!.frame.size.width
        var currentPage = Float(collectionView!.contentOffset.x / pageWidth)
        
        var pointer: Float = Float(1.0)
        
        if (Float(0.0) != modff(currentPage, &pointer))
        {
            pageControl?.currentPage = Int(currentPage + 1)
        }
        else
        {
            pageControl?.currentPage = Int(currentPage)
        }
    }
}

extension OHWidgetCollectionViewController {
    func pageControlValueChanged(control: UIPageControl)
    {
        var contentOffset = collectionView!.contentOffset
        contentOffset.x = CGFloat(control.currentPage) * collectionView!.frame.size.width
        self.collectionView!.setContentOffset(contentOffset, animated: true)
    }
}
