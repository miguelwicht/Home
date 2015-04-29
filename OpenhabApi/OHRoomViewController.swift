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
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        
//        restManager.getSitemaps()
        
        println("viewDidLoad")
        self.view.backgroundColor = UIColor.whiteColor()
    }
    
    convenience init(widgets: [OHWidget])
    {
        self.init(nibName: nil, bundle: nil)
        
        self.widgets = widgets
        
        println("convenience init")
        println(widgets)
    }
    
    override func loadView() {
        
        super.loadView()
        
        println("loadView")
        
        var labels: [UILabel] = [UILabel]()
        
        var sections: [OHSectionView]
        
        self.widgets?.count
        
//        for (index, element) in enumerate(self.widgets!)
//        {
//            var label = UILabel(frame: CGRectMake(0, 20, self.view.frame.width, 20))
//            label.text = element.label
//            label.sizeToFit()
//            //self.view.addSubview(label)
//            
//            println(element.linkedPage)
//            
//            labels.append(label)
//            
//            var section: OHSectionView = OHSectionView(widgets: element.linkedPage!.widgets!, headline: element.label!)
//            
//            section.frame.origin.y = CGFloat(300 * index)
//            
//            self.view.addSubview(section)
//        }
        println(self.widgets!)
        createCollectionView(self.widgets![0].linkedPage!.widgets!)
    }
    
    func createCollectionView(widgets: [OHWidget]){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        layout.minimumInteritemSpacing = 20
        layout.itemSize = CGSize(width: 80, height: 90)
        
        
        
//        var collectionViewController: OHWidgetCollectionViewController = OHWidgetCollectionViewController(collectionViewLayout: layout)
        var collectionViewController: OHWidgetCollectionViewController = OHWidgetCollectionViewController(collectionViewLayout: OHWidgetCollectionViewLayout())
        collectionViewController.view.frame = CGRectMake(20, 20, self.view.frame.width - 40, 280)
        collectionViewController.setDataForWidgets(widgets)
        collectionViewController.collectionView?.reloadData()
//        collectionViewController.view.backgroundColor = UIColor.greenColor()
//        collectionViewController.collectionView?.backgroundColor = UIColor.blackColor()
        
        self.collectionViewControllers.append(collectionViewController)
        
        self.view.addSubview(collectionViewController.view)
    }
//    func createCollectionView()
//    {
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
//        layout.sectionInset = UIEdgeInsets(top: 20, left: 40, bottom: 20, right: 40)
//        layout.itemSize = CGSize(width: 60, height: 60)
//        collectionView = UICollectionView(frame: CGRectMake(20, 100, self.view.frame.width - 40, 180), collectionViewLayout: layout)
//        collectionView!.dataSource = self
//        collectionView!.delegate = self
//        collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
//        collectionView!.backgroundColor = UIColor.whiteColor()
//        collectionView!.pagingEnabled = true
//        
//        self.view.addSubview(collectionView!)
//
//    }
}