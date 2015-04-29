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
    var numberOfItemsPerSection: Int = 6
    
    var layout: UICollectionViewLayout

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        self.layout = layout
        self.widgets = [OHWidget]()
        super.init(collectionViewLayout: layout)
        println("initCollectionView")
        //collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView!.registerClass(OHWidgetCell.self, forCellWithReuseIdentifier: "Cell")
        configurateCollectionView()
    }

    override func loadView() {
        super.loadView()
        
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
//        layout.sectionInset = UIEdgeInsets(top: 20, left: 40, bottom: 20, right: 40)
//        layout.itemSize = CGSize(width: 60, height: 60)
        //collectionView = UICollectionView(frame: CGRectMake(20, 100, self.view.frame.width - 40, 180), collectionViewLayout: layout)
//        collectionView!.dataSource = self
//        collectionView!.delegate = self
//        collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
//        collectionView!.backgroundColor = UIColor.whiteColor()
//        collectionView!.pagingEnabled = true
//        
//        self.view.addSubview(collectionView!)
        self.view.backgroundColor = UIColor.whiteColor()
        self.collectionView?.backgroundColor = UIColor.whiteColor()
        self.collectionView!.reloadData()
        println("WIDGETS:")
        println(self.widgets)
    }
    
    func configurateCollectionView() {
        collectionView!.dataSource = self
        collectionView!.delegate = self
//        collectionView!.backgroundColor = UIColor.greenColor()
        collectionView!.pagingEnabled = true
        self.collectionView!.frame = CGRectMake(self.collectionView!.frame.origin.x + 20, self.collectionView!.frame.origin.y, self.collectionView!.frame.width - 40, self.collectionView!.frame.height)
//        self.collectionView!.delegate = self
    }
    
    func setDataForWidgets(widgets: [OHWidget]){
        self.widgets = widgets
        println("DATA FOR WIDGETS")
        println(self.widgets)
        self.collectionView!.reloadData()
    }
}

extension OHWidgetCollectionViewController: UICollectionViewDataSource {
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var itemsInSection: Int?
        
        if (self.numberOfSectionsInCollectionView(collectionView) - (section + 1) > 0)
        {
            itemsInSection = self.numberOfItemsPerSection
        }
        else {
            itemsInSection =  self.numberOfItemsPerSection - (self.numberOfItemsPerSection * (section + 1) - self.widgets!.count)
        }
        println("itemsInSections: \(itemsInSection!)")
        return itemsInSection!
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        println("CellForRow")
        //let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! UICollectionViewCell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! OHWidgetCell
//        var hue: CGFloat = CGFloat(indexPath.item * 10)
//        hue = hue / 255
        
        //        cell.backgroundColor = UIColor(hue: hue, saturation: CGFloat(1.0), brightness: CGFloat(0.9), alpha: 1.0)
//                cell.backgroundColor = UIColor.redColor()
        
        //var imageView: UIImageView = UIImageView(image: UIImage(named: self.widgets![indexPath.item].icon!))
        //        cell.i
        //cell.addSubview(imageView)
        
//        cell.frame = CGRectMake(0, 0, 70 , 90)
        
        cell.imageView!.image = UIImage(named: self.widgets![indexPath.item].icon!)
//        cell.backgroundColor = UIColor.redColor()
        cell.label?.text = self.widgets![indexPath.item].label
        
//        println(hue)
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        println("\(indexPath.item)")
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        //        var q: CGFloat = CGFloat(self.items) % CGFloat(self.numberOfItemsInSection)
        
        var numberOfSections = Int(ceil(CGFloat(self.widgets!.count) / CGFloat(self.numberOfItemsPerSection)))
        println("numberOfSections: \(numberOfSections)")
        
        return numberOfSections
    }
}

extension OHWidgetCollectionViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
//        println("blub")
//        return CGFloat(30)
//    }
//    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
//        
//        return UIEdgeInsetsMake(0, 50, 0, 50)
//    }
}
