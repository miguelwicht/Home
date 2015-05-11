//
//  OHRoomViewController.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 21/04/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import UIKit

class OHRoomViewController: UIViewController {
    
    var widgets: [OHWidget]?
    var collectionViewControllers: [OHWidgetCollectionViewController] = [OHWidgetCollectionViewController]()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder)
    {
//        self.restManager = OHRestManager(baseUrl: "http://10.10.32.251:8888")
        super.init(coder: aDecoder)
//        self.restManager.delegate = self
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.whiteColor()
    }
    
    convenience init(widgets: [OHWidget])
    {
        self.init(nibName: nil, bundle: nil)
        
        self.widgets = widgets
    }
    
    override func loadView()
    {
        super.loadView()
        
        // TODO: create other collectionViews e.g. for scenes
//        createCollectionView(self.widgets![0].linkedPage!.widgets!)
        println(self.widgets!)
//        println(self.widgets![0].linkedPage!.title)
//        println(self.widgets![0].linkedPage!.widgets![1].widgets![0].linkedPage!.widgets!)
        
//        var beaconFrame: OHWidget;
//        var outletFrame: OHWidget;
//        
//        
//        for var i = 0; i < self.widgets![0].linkedPage!.widgets!.count {
//        
//        }
        
        var beaconFrame: OHWidget = self.widgets![0].linkedPage!.widgets![0]
        var outletFrame: OHWidget = self.widgets![0].linkedPage!.widgets![1]
        
        var outlets: [OHWidget] = outletFrame.widgets!
        
        for var i = 0; i < outlets.count; i++ {
            createCollectionView(outlets[i].linkedPage!.widgets!, rows: i + 1)
        }
        
        
//        createCollectionView(self.widgets![0].linkedPage!.widgets![1].widgets![0].linkedPage!.widgets!)
    }
    
    func createCollectionView(widgets: [OHWidget], rows: Int)
    {
        var collectionViewController: OHWidgetCollectionViewController = OHWidgetCollectionViewController(collectionViewLayout: OHWidgetCollectionViewLayout())
        
        var navbarOffset = CGFloat(20)
        
        if (self.navigationController?.navigationBarHidden != nil) {
            navbarOffset += self.navigationController!.navigationBar.frame.height
        }
//        collectionViewController.layout?.itemSize.height + 
        collectionViewController.view.frame = CGRectMake(0, 0, self.view.frame.width - 20, 220)
        
        self.view.addSubview(collectionViewController.view)
        
        collectionViewController.view.marginLeft = 0
        collectionViewController.view.marginTop = navbarOffset
        collectionViewController.view.centerViewVerticallyInSuperview()
        collectionViewController.view.centerViewHorizontallyInSuperview()
        
//        collectionViewController.view.backgroundColor = UIColor.redColor()
        collectionViewController.setDataForWidgets(widgets)
//        collectionViewController.collectionView?.reloadData()
        
        self.collectionViewControllers.append(collectionViewController)
        
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        for var i = 0; i < collectionViewControllers.count; i++ {
            
            var offset = CGFloat(20)
            
            if (self.navigationController?.navigationBarHidden != nil) {
                offset += self.navigationController!.navigationBar.frame.height
            }

            collectionViewControllers[i].view.marginTop = i == 0 ? offset : collectionViewControllers[i - 1].view.marginBottom + 60
        }
    }
}