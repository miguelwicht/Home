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

    required init(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(collectionViewLayout layout: UICollectionViewLayout)
    {
        self.widgets = [OHWidget]()
        self.layout = layout as? UICollectionViewFlowLayout
        super.init(collectionViewLayout: layout)

        collectionView!.registerClass(OHWidgetCell.self, forCellWithReuseIdentifier: self.reuseIdentifier)
        configurateCollectionView()
    }

    override func loadView()
    {
        super.loadView()
        
        self.collectionView!.reloadData()

        leftArrowButton.setImage(UIImage(named: "arrow_left"), forState: .Normal)
        leftArrowButton.imageView?.contentMode = UIViewContentMode.Center
        self.view.addSubview(leftArrowButton)
        
        rightArrowButton.setImage(UIImage(named: "arrow_right"), forState: .Normal)
        rightArrowButton.imageView?.contentMode = UIViewContentMode.Center
        self.view.addSubview(rightArrowButton)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.collectionView!.frame = CGRectMake(20, 0, self.view.frame.width - 40, self.view.frame.height)
        self.layout?.prepareLayout()
        self.leftArrowButton.frame.origin.y = (self.view.frame.height / 2) - (self.leftArrowButton.frame.height / 2)
        self.rightArrowButton.frame.origin.y = (self.view.frame.height / 2) - (self.leftArrowButton.frame.height / 2)
        self.rightArrowButton.frame.origin.x = self.view.frame.width - self.rightArrowButton.frame.width
    }
    
    func configurateCollectionView()
    {
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.backgroundColor = UIColor.whiteColor()
        collectionView!.pagingEnabled = true
        collectionView!.showsHorizontalScrollIndicator = false
    }
    
    func setDataForWidgets(widgets: [OHWidget]){
        self.widgets = widgets
        println("DATA FOR WIDGETS")
//        println(self.widgets)
        self.collectionView!.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        addGradientMask()
    }
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
        return self.widgets!.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(self.reuseIdentifier, forIndexPath: indexPath) as! OHWidgetCell
        
        cell.imageView.image = UIImage(named: self.widgets![indexPath.item].icon!)
        cell.label.text = self.widgets![indexPath.item].label
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath)
    {
        println("\(indexPath.item)")
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
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
        println("numberOfSections: \(numberOfSections)")
        
        return numberOfSections
    }
}
