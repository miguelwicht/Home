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
    var pageControlsForControllers: [String: UIPageControl] = [String: UIPageControl]()
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(widget: OHWidget, frame: CGRect)
    {
        self.init(nibName: nil, bundle: nil)
        
//        self.automaticallyAdjustsScrollViewInsets = false
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
//        self.scrollView.contentSize = calculateScrollViewContentSize()
        
//        addConstraintsToView()
    }

    override func viewWillLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
//        scrollView.marginTop = 0
//        scrollView.marginLeft = 0
//        
//        var offset = CGFloat(30)
//        
//        for (index, element) in enumerate(collectionViewControllers)
//        {
//            var pageControllerHeight = CGFloat(0)
//            
//            if var pageControl = pageControlsForControllers["\(index)"] {
//                pageControl.marginTop = element.view.neededSpaceHeight
//                pageControl.sizeToFit()
//                pageControl.centerViewHorizontallyInSuperview()
//                pageControllerHeight = pageControl.frame.height
//            }
//            
//            if var label = labelsForControllers["\(index)"] {
//                label.sizeToFit()
//                label.centerViewHorizontallyInSuperview()
//            
//                label.marginTop = index == 0 ? offset : collectionViewControllers[index - 1].view.neededSpaceHeight + 30 + pageControllerHeight
//                
////                label.marginTop = index != 0 ? label.marginTop + collectionViewControllers[index - 1].pageControl.frame.height : label.marginTop
//                
//                offset = label.neededSpaceHeight + 20
//            }
//            
////            element.view.centerViewHorizontallyInSuperview()
//            element.view.marginTop = offset
//            
//            offset = element.view.neededSpaceHeight
//        }
//        
////        scrollView.contentSize = calculateScrollViewContentSize()
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
        
        scrollView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        
        scrollView.addSubview(contentView)
        contentView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        addScrollViewConstraints()
        
//            
//        scrollView.marginTop = 0
//        scrollView.marginLeft = 0
    }
    
    func addScrollViewConstraints()
    {
        var views = [String: AnyObject]()
        views["scrollView"] = scrollView
        views["contentView"] = contentView
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(0)-[scrollView]-(0)-|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[scrollView]-(0)-|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: views))
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(0)-[contentView]-(0)-|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[contentView]-(0)-|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: views))
        
        self.view.addConstraint(NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0))
    }
}

extension OHRoomViewController {
    
    
    func addLeftAndRightConstraintsToCollectionViewController(collectionViewController: UICollectionViewController){
//        view.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        
        var viewToConstraint = collectionViewController.view
        viewToConstraint.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        var widthConstraint = NSLayoutConstraint(item: viewToConstraint, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0.0)
        
        var centerXConstraint = NSLayoutConstraint(item: viewToConstraint, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0)
        
        var heightConstraint = NSLayoutConstraint(item: viewToConstraint, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Height, multiplier: 0.0, constant: viewToConstraint.frame.height)
        
        self.view.addConstraint(widthConstraint)
        self.view.addConstraint(centerXConstraint)
        self.view.addConstraint(heightConstraint)
        
        var index = find(collectionViewControllers, collectionViewController as! OHWidgetCollectionViewController)
        
        if var label = labelsForControllers["\(index)"] {
            
            
        }
        
        if index == 0 {
            
        }
    
    }
    
    func createCollectionView(widgets: [OHWidget], rows: Int) -> OHWidgetCollectionViewController
    {
        var layout = OHWidgetCollectionViewLayout()
        layout.itemSize = OHDefaults.roomCollectionViewItemSize()
        layout.minimumInteritemSpacing = 25
        layout.minimumLineSpacing = 25
        var collectionViewController: OHWidgetCollectionViewController = OHWidgetCollectionViewController(collectionViewLayout: layout, widgets: widgets)
        
        // TODO: add function to calculate row height
        var height = CGFloat(CGFloat(rows) * (layout.itemSize.height + layout.minimumLineSpacing)) - layout.minimumLineSpacing
        height = rows == 1 ? layout.itemSize.height : height
        
        collectionViewController.view.frame = CGRectMake(0, 0, scrollView.frame.width - 30, height)
        
        
//        collectionViewController.view.setHeight(collectionViewController.pageControl.neededSpaceHeight)
        
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
                    contentView.addSubview(collectionViewController.view)
                    collectionViewControllers.append(collectionViewController)
                    
                    addLabelForCollectionViewController(collectionViewController, outlet: outlet)
                    addPageIndicatorForCollectionViewController(collectionViewController)
                    
                    
                    
                    
                    
                }
            }
        }
        
        addConstraintsToView()
    }
    
    func addConstraintsToView()
    {
        var topObject = contentView
        
        var labels = [String: AnyObject]()
        
        for (labelKey, label) in labelsForControllers {
            labels["_\(labelKey)"] = label
        }
        
        for (key, label) in labels {
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(15)-[\(key)]-(15)-|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: labels))
            
            if var l = label as? UILabel {
                if l.hidden {
                    contentView.addConstraint(NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: topObject, attribute: NSLayoutAttribute.Height, multiplier: 0.0, constant: 0.0))
                }
            }
        }
        
        
        var pageControls = [String: AnyObject]()
        
        for (pageControlKey, pageControl) in pageControlsForControllers {
            pageControls["_\(pageControlKey)"] = pageControl
        }
        
        for (key, pageControl) in pageControls {
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(15)-[\(key)]-(15)-|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: pageControls))
        }
        
        
        
        for (index, collectionViewController) in enumerate(collectionViewControllers) {
            

            if var label = labelsForControllers["\(index)"] {
                
                if index == 0 {
                    var constant = label.hidden ? CGFloat(0) : CGFloat(25)
                    contentView.addConstraint(NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: topObject, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: constant))
                } else {
                    
                    var constant = label.hidden ? CGFloat(0) : CGFloat(25)
                    
                    contentView.addConstraint(NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: topObject, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: constant))
                }

                
                topObject = label
                
            }
            
            
            contentView.addConstraint(NSLayoutConstraint(item: collectionViewController.view, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: topObject, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 20))
            
            
            addLeftAndRightConstraintsToCollectionViewController(collectionViewController)
            
            topObject = collectionViewController.view
            
            
            if var pageControl = pageControlsForControllers["\(index)"] {
                contentView.addConstraint(NSLayoutConstraint(item: pageControl, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: topObject, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 10))
                topObject = pageControl
            }
        }
        
        if var collectionViewController = collectionViewControllers.last {
            
            var scrollViewHeightConstraint = NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: topObject, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 15)
            
            view.addConstraint(scrollViewHeightConstraint)
        }
    }
    
    
    
    
    func addPageIndicatorForCollectionViewController(collectionViewController: OHWidgetCollectionViewController) {
        
        var pageControl = UIPageControl()
        pageControl.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addSubview(pageControl)
        
        collectionViewController.pageControl = pageControl
        var index = find(collectionViewControllers, collectionViewController)
        pageControlsForControllers["\(index!)"] = pageControl

    }
    
    func addLabelForCollectionViewController(collectionViewController: OHWidgetCollectionViewController, outlet: OHWidget){
        // create a label if one is defined for the collectionView
        
        var label = UILabel()
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.font = OHDefaults.defaultFontWithSize(22)
        label.text = outlet.label!.uppercaseString
        label.textAlignment = NSTextAlignment.Center
        contentView.addSubview(label)
        var index = find(collectionViewControllers, collectionViewController)
        labelsForControllers["\(index!)"] = label
        
        label.hidden = outlet.label == outlet.item?.name ? true : false
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
        var height = CGFloat(0)
        
        if var collectionViewBottom = collectionViewControllers.last?.view.neededSpaceHeight {
            height = collectionViewBottom
            
            if var pageControl = collectionViewControllers.last?.pageControl {
                height += pageControl.frame.height
            }
        }
        
        return CGSize(width: width, height: height)
    }
}
