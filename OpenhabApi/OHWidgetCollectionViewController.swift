//
//  OHWidgetCollectionViewController.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 28/04/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import UIKit

class OHWidgetCollectionViewController: UICollectionViewController {
    
    //MARK: - Properties
    var widgets: [OHWidget]?
    var layout: UICollectionViewFlowLayout?
    var reuseIdentifier: String = "reuseIdentifier"
    var leftArrowButton = UIButton(frame: CGRectMake(0, 0, 20, 20))
    var rightArrowButton = UIButton(frame: CGRectMake(0, 0, 20, 20))
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
    
    //MARK: - Initializers
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        self.layout = layout as? UICollectionViewFlowLayout
        super.init(collectionViewLayout: layout)

        collectionView!.registerClass(OHWidgetCell.self, forCellWithReuseIdentifier: self.reuseIdentifier)
        configurateCollectionView()
    }
    
    convenience init(collectionViewLayout layout: UICollectionViewLayout, widgets: [OHWidget]) {
        self.init(collectionViewLayout: layout)
        self.setDataForWidgets(widgets)
    }
    
    //MARK: -
    override func loadView() {
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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
//        self.leftArrowButton.marginTop = (self.view.frame.height / 2) - (self.leftArrowButton.frame.height / 2)
//        self.rightArrowButton.marginTop = (self.view.frame.height / 2) - (self.leftArrowButton.frame.height / 2)
//        self.rightArrowButton.marginLeft = self.view.frame.width - self.rightArrowButton.frame.width
        pageControl?.numberOfPages = numberOfPages
    }
    
    func configurateCollectionView() {
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.backgroundColor = UIColor.whiteColor()
        collectionView!.pagingEnabled = true
        collectionView!.showsHorizontalScrollIndicator = false
    }
    
    func setDataForWidgets(widgets: [OHWidget]) {
        self.widgets = widgets
        self.collectionView!.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension OHWidgetCollectionViewController: UICollectionViewDataSource {
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var numberOfItems = 0
        
        if var widgets =  self.widgets {
            numberOfItems = widgets.count
        }
        
        return numberOfItems
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(self.reuseIdentifier, forIndexPath: indexPath) as! OHWidgetCell
        var imageName: String = self.widgets![indexPath.item].icon!
        
        if self.widgets![indexPath.item].icon! == "none" {
            if var item = self.widgets![indexPath.item].item, tags = item.tags  {
                imageName = item.isLightFromTags() ? "bulb" : imageName
            }
        }
        
        cell.imageView.image = UIImage(named: imageName)
        cell.label.text = self.widgets![indexPath.item].label
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var cell = self.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! OHWidgetCell
        cell.imageView.backgroundColor = UIColor.purpleColor()
        cell.imageView.image = UIImage(named: "TV")

        if var item = self.widgets![indexPath.item].item, tags = item.tags {
            for (index, tag) in enumerate(tags) {
                if item.isLightFromTags() {
                    pushLightsController(widgets![indexPath.item])
                    break
                }
                
                if item.hasTag("OH_Scene") {
                    item.sendCommand("ON")
                    break
                }
            }
        }
    }
    
    func pushLightsController(widget: OHWidget) {
        var vc = OHLightController()
        vc.title = widget.label
        self.parentViewController!.navigationController?.pushViewController(vc, animated: true)
        
        if var bulbs = widget.linkedPage?.widgets {
            vc.initWidget(bulbs)
            var lights = [OHLight]()
            
            for (index, bulb) in enumerate(bulbs) {
                var light = OHLight(widget: bulb)
                lights.append(light)
            }
            
            vc.initLights(lights)
        }
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
}

//MARK: - UIScrollViewDelegate
extension OHWidgetCollectionViewController: UIScrollViewDelegate {
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        var pageWidth = collectionView!.frame.size.width
        var currentPage = Float(collectionView!.contentOffset.x / pageWidth)
        var pointer: Float = Float(1.0)
        pageControl?.currentPage = (Float(0.0) != modff(currentPage, &pointer)) ? Int(currentPage + 1) : Int(currentPage)
    }
}

//MARK: -
extension OHWidgetCollectionViewController {
    
    func pageControlValueChanged(control: UIPageControl) {
        var contentOffset = collectionView!.contentOffset
        contentOffset.x = CGFloat(control.currentPage) * collectionView!.frame.size.width
        self.collectionView!.setContentOffset(contentOffset, animated: true)
    }
}
