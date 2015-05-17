//
//  OHRoomViewController.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 12/05/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import UIKit

class OHRoomViewController: UIViewController {
    
    var widget: OHWidget?
    var collectionViewControllers: [OHWidgetCollectionViewController] = [OHWidgetCollectionViewController]()
    var scrollView: UIScrollView?
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(widget: OHWidget, frame: CGRect)
    {
        self.init(nibName: nil, bundle: nil)
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.frame = frame
        
        initScrollView()
        initWidget(widget)
        
//        println(widget.linkedPage!.widgets![1])
        
    }

    override func loadView() {
        super.loadView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        self.scrollView!.marginTop = 0
        self.scrollView!.marginLeft = 0
        
        for (index, element) in enumerate(collectionViewControllers)
        {
            var offset = CGFloat(0)
            
            element.view.centerViewHorizontallyInSuperview()
            element.view.marginTop = index == 0 ? offset : collectionViewControllers[index - 1].view.neededSpaceHeight + 60
        }
        
        self.scrollView!.contentSize = calculateScrollViewContentSize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension OHRoomViewController {
    
    func initWidget(widget: OHWidget)
    {
        self.widget = widget
        
        if var _widget = self.widget {
            self.setRoomWidget(_widget)
        }
    }
    
    func setRoomWidget(widget: OHWidget)
    {
        self.widget = widget
        
        //        removeCollectionViewControllers()
        createCollectionViewControllers()
    }
    
    func initScrollView()
    {
        self.scrollView = UIScrollView()
        
        if var scrollView = self.scrollView {
            var scrollViewHeight = self.view.frame
            
            scrollView.delegate = self
            scrollView.frame = self.view.frame
            self.view.addSubview(scrollView)
            
            scrollView.marginTop = 0
            scrollView.marginLeft = 0
        }
    }
    
}

extension OHRoomViewController {
    
    func createCollectionView(widgets: [OHWidget], rows: Int)
    {
        var layout = OHWidgetCollectionViewLayout()
        var collectionViewController: OHWidgetCollectionViewController = OHWidgetCollectionViewController(collectionViewLayout: layout, widgets: widgets)
        
        // TODO: add function to calculate row height
        var height = CGFloat(rows * 120)
        
        collectionViewController.view.frame = CGRectMake(0, 0, self.scrollView!.frame.width - 30, height)
        
        self.addChildViewController(collectionViewController)
        self.scrollView!.addSubview(collectionViewController.view)
        
//        println("collectionViewFrame: \(collectionViewController.view.frame)")
//        println("scrollView: \(self.scrollView!.frame), bounds: \(self.scrollView!.bounds)")
        
        self.collectionViewControllers.append(collectionViewController)
    }
    
    func createCollectionViewControllers()
    {
        // TODO: don't really like this setup, maybe just use tags to and groups
        var beaconFrame: OHWidget = self.widget!.linkedPage!.widgets![0]
        
        var outletFrame: OHWidget = self.widget!.linkedPage!.widgets![1]
        
        var outlets: [OHWidget] = outletFrame.widgets!
        
        for (i, outlet) in enumerate(outlets) {
            
            var rows = 1
            
            if var item = outlet.item {
                if var tags = item.tags {
                    for (index, tag) in enumerate(tags)
                    {
                        if tag.rangeOfString("OH_Outlet_Rows_") != nil {
                            var tagString = tag.stringByReplacingOccurrencesOfString("OH_Outlet_Rows_", withString: "")
                            rows = tagString.toInt()!
                        }
                    }
                }
            }
            
            createCollectionView(outlets[i].linkedPage!.widgets!, rows: rows)      
        }
    }
    
    func removeCollectionViewControllers()
    {
        for (index, element) in enumerate(self.collectionViewControllers)
        {
            element.view.removeFromSuperview()
//            element = nil
        }
        
        self.collectionViewControllers = [OHWidgetCollectionViewController]()
    }
    
}

extension OHRoomViewController: UIScrollViewDelegate {
    
    func calculateScrollViewContentSize() -> CGSize
    {
        var width = self.scrollView!.frame.width
        var height = self.collectionViewControllers.last!.view.neededSpaceHeight + 50
        
        return CGSize(width: width, height: height)
    }
    
}
