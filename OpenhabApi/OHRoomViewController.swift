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
    var labelsForControllers: [String: UILabel] = [String: UILabel]()
    let scrollView = UIScrollView()
    
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
        
        scrollView.marginTop = 0
        scrollView.marginLeft = 0
        
        var offset = CGFloat(30)
        
        for (index, element) in enumerate(collectionViewControllers)
        {
            if var label = labelsForControllers["\(index)"] {
                label.sizeToFit()
                label.centerViewHorizontallyInSuperview()
            
                label.marginTop = index == 0 ? offset : collectionViewControllers[index - 1].view.neededSpaceHeight + 30
                offset = label.neededSpaceHeight + 20
            }
            
            element.view.centerViewHorizontallyInSuperview()
            element.view.marginTop = offset
            
            offset = element.view.neededSpaceHeight
        }
        
        scrollView.contentSize = calculateScrollViewContentSize()
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
        scrollView.delegate = self
        scrollView.frame = view.frame
        view.addSubview(scrollView)
            
        scrollView.marginTop = 0
        scrollView.marginLeft = 0
    }
}

extension OHRoomViewController {
    
    func createCollectionView(widgets: [OHWidget], rows: Int) -> OHWidgetCollectionViewController
    {
        var layout = OHWidgetCollectionViewLayout()
        layout.itemSize = CGSize(width: 60, height: 80)
        layout.minimumInteritemSpacing = 25
        layout.minimumLineSpacing = 25
        var collectionViewController: OHWidgetCollectionViewController = OHWidgetCollectionViewController(collectionViewLayout: layout, widgets: widgets)
        
        // TODO: add function to calculate row height
        var height = CGFloat(CGFloat(rows) * (layout.itemSize.height + layout.minimumLineSpacing)) - layout.minimumLineSpacing
        height = rows == 1 ? layout.itemSize.height : height
        
        collectionViewController.view.frame = CGRectMake(0, 0, scrollView.frame.width - 30, height)
        
        return collectionViewController
    }
    
    func createCollectionViewControllers()
    {
        var outlets: [OHWidget]?
        
        if var widgets = self.widget?.linkedPage?.widgets {
            for (index, widget) in enumerate(widgets) {
                if var label = widget.label {
                    outlets = label == "OH_Widgets" ? widget.widgets : outlets
                }
            }
        }
        
        if var outletsUnwrapped = outlets
        {
            for (i, outlet) in enumerate(outletsUnwrapped)
            {
                // We want at least one row if the number of rows is not defined
                var numberOfRows = outlet.item?.numberOfRowsFromTags()
                var rows = numberOfRows != nil ? numberOfRows! : 1
                
                if var widgets = outletsUnwrapped[i].linkedPage?.widgets
                {
                    var collectionViewController = createCollectionView(widgets, rows: rows)
                    addChildViewController(collectionViewController)
                    scrollView.addSubview(collectionViewController.view)
                    collectionViewControllers.append(collectionViewController)
                    
                    addLabelForCollectionViewController(collectionViewController, outlet: outlet)
                }
            }
        }
    }
    
    func addLabelForCollectionViewController(collectionViewController: OHWidgetCollectionViewController, outlet: OHWidget){
        // create a label if one is defined for the collectionView
        if outlet.label != outlet.item?.name {
            var label = UILabel()
            label.font = OHDefaults.defaultFontWithSize(22)
            label.text = outlet.label!.uppercaseString
            scrollView.addSubview(label)
            var index = find(collectionViewControllers, collectionViewController)
            labelsForControllers["\(index!)"] = label
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
        var width = scrollView.frame.width
        var height = collectionViewControllers.last!.view.neededSpaceHeight
        
        return CGSize(width: width, height: height)
    }
}
