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
        createCollectionView(self.widgets![0].linkedPage!.widgets!)
    }
    
    func createCollectionView(widgets: [OHWidget])
    {
        var collectionViewController: OHWidgetCollectionViewController = OHWidgetCollectionViewController(collectionViewLayout: OHWidgetCollectionViewLayout())
        collectionViewController.view.frame = CGRectMake(0, 20, self.view.frame.width, 220)
//        collectionViewController.view.backgroundColor = UIColor.redColor()
        collectionViewController.setDataForWidgets(widgets)
//        collectionViewController.collectionView?.reloadData()
        
        self.collectionViewControllers.append(collectionViewController)
        
        self.view.addSubview(collectionViewController.view)
    }
}