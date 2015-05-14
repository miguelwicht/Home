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
        self.widget = widget
        self.scrollView = UIScrollView()
        self.view.frame = frame
        
        initScrollView()
        initWidget(widget)
        
        println(widget.linkedPage!.widgets![1])
    }

    func initScrollView()
    {
        if var scrollView = self.scrollView {
            var scrollViewHeight = self.view.frame
            
            scrollView.delegate = self
            scrollView.frame = self.view.frame
            self.view.addSubview(scrollView)
            
            scrollView.marginTop = 0
            scrollView.marginLeft = 0
        }
    }
    
    
    override func loadView() {
        super.loadView()
    }
    
    func initWidget(widget: OHWidget?) {
        if var _widget = widget {
            self.setRoomWidget(_widget)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func createCollectionView(widgets: [OHWidget], rows: Int)
    {
        // TODO: Fix addChildViewController
        
        var layout = OHWidgetCollectionViewLayout()
//        layout.fixedRows = 1
        
        var collectionViewController: OHWidgetCollectionViewController = OHWidgetCollectionViewController(collectionViewLayout: layout, widgets: widgets)
        
        // TODO: add function to calculate row height
        
        var height = CGFloat(rows * 120)
        
        collectionViewController.view.frame = CGRectMake(0, 0, self.scrollView!.frame.width - 20, height)
        
//        if rows == 1 {
//            collectionViewController.view.frame = CGRectMake(0, 0, self.scrollView!.frame.width - 20, 120)
//        } else {
//            collectionViewController.view.frame = CGRectMake(0, 0, self.scrollView!.frame.width - 20, 220)
//        }
        
//        collectionViewController.view.frame = CGRectMake(0, 0, self.scrollView!.frame.width - 20, 220)
        self.addChildViewController(collectionViewController)
        self.scrollView!.addSubview(collectionViewController.view)
        
        println("collectionViewFrame: \(collectionViewController.view.frame)")
        println("scrollView: \(self.scrollView!.frame), bounds: \(self.scrollView!.bounds)")
        
        self.collectionViewControllers.append(collectionViewController)
    }

    override func viewWillLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
//        self.scrollView.frame = self.view.frame
        
        self.scrollView!.marginTop = 0
        self.scrollView!.marginLeft = 0
        
        
        
        for (index, element) in enumerate(collectionViewControllers)
        {
        
//        for var i = 0; i < collectionViewControllers.count; i++ {
            
            var offset = CGFloat(0)
            
//            if (self.navigationController?.navigationBarHidden != nil) {
//                offset += self.navigationController!.navigationBar.frame.height
//            }
            
//            collectionViewControllers[i].view.centerViewHorizontallyInSuperview()
//            collectionViewControllers[i].view.marginTop = i == 0 ? offset : collectionViewControllers[i - 1].view.marginBottom + 60
            element.view.centerViewHorizontallyInSuperview()
            element.view.marginTop = index == 0 ? offset : collectionViewControllers[index - 1].view.neededSpaceHeight + 60
        }
        
        
        
        println("RoomViewController.ViewWillLayoutSubviews: frame: \(self.view.frame)")
        println("RoomViewController.ViewWillLayoutSubviews: scrollFrame\(self.scrollView!.frame)")
        
        
        self.scrollView!.contentSize = calculateScrollViewContentSize()
    }
    
    func setRoomWidget(widget: OHWidget)
    {
        self.widget = widget
        
//        removeCollectionViewControllers()
        createCollectionViewControllers()
    }
    
    func createCollectionViewControllers()
    {
        var beaconFrame: OHWidget = self.widget!.linkedPage!.widgets![0]
        var outletFrame: OHWidget = self.widget!.linkedPage!.widgets![1]
        
        var outlets: [OHWidget] = outletFrame.widgets!
        
//        for var i = 0; i < 1; i++ {
        
        
        for var i = 0; i < outlets.count; i++ {
            var rows = 1
            
            if var item = outlets[i].item {
                if var tags = item.tags {
                    for (index, tag) in enumerate(tags)
                    {
                        if tag.rangeOfString("OH_Outlet_Rows_") != nil {
                            var tagString = tag
                            tagString = tag.stringByReplacingOccurrencesOfString("OH_Outlet_Rows_", withString: "")
                            rows = tagString.toInt()!
//                            rows = tagString.substringWithRange(Range<String.Index>(start: advance(tagString.startIndex, 14), end: advance(tagString.endIndex, 1))).toInt()!
                            
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension OHRoomViewController: UIScrollViewDelegate
{
    func calculateScrollViewContentSize() -> CGSize
    {
        var width = self.scrollView!.frame.width
        var height = self.collectionViewControllers.last!.view.neededSpaceHeight + 50
        
        return CGSize(width: width, height: height)
    }
    
}
