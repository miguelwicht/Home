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
    
    convenience init(widget: OHWidget, frame: CGRect) {
        self.init(nibName: nil, bundle: nil)
        
        self.view.frame = frame
        initScrollView()
        initWidget(widget)
    }

    override func loadView() {
        super.loadView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension OHRoomViewController {
    
    func initWidget(widget: OHWidget) {
        self.widget = widget
        
        if var _widget = self.widget {
            self.setRoomWidget(_widget)
        }
    }
    
    func setRoomWidget(widget: OHWidget) {
        self.widget = widget
        createCollectionViewControllers()
    }
    
    func initScrollView() {
//        scrollView.delegate = self
        scrollView.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.setTranslatesAutoresizingMaskIntoConstraints(false)
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
        
        addScrollViewConstraints()
    }
    
    func addScrollViewConstraints() {
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
    
    func addLeftAndRightConstraintsToCollectionViewController(collectionViewController: UICollectionViewController) {
        var viewToConstraint = collectionViewController.view
        var views: [String: AnyObject] = ["viewToConstraint": viewToConstraint]
        viewToConstraint.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[viewToConstraint]-(0)-|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: views))
        contentView.addConstraint(NSLayoutConstraint(item: viewToConstraint, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Height, multiplier: 0.0, constant: viewToConstraint.frame.height))
    }
    
    func createCollectionView(widgets: [OHWidget], rows: Int) -> OHWidgetCollectionViewController {
        var layout = OHWidgetCollectionViewLayout()
        layout.itemSize = OHDefaults.roomCollectionViewItemSize()
        layout.minimumInteritemSpacing = 25
        layout.minimumLineSpacing = 25
        var collectionViewController: OHWidgetCollectionViewController = OHWidgetCollectionViewController(collectionViewLayout: layout, widgets: widgets)
        
        var height = CGFloat(CGFloat(rows) * (layout.itemSize.height + layout.minimumLineSpacing)) - layout.minimumLineSpacing
        height = rows == 1 ? layout.itemSize.height : height
        collectionViewController.view.frame = CGRectMake(0, 0, scrollView.frame.width - 30, height)
        
        return collectionViewController
    }
    
    func createCollectionViewControllers() {
        var outlets: [OHWidget]?
        
        if var widgets = self.widget?.linkedPage?.widgets {
            for (index, widget) in enumerate(widgets) {
                if var label = widget.label {
                    outlets = label == "OH_Widgets" ? widget.widgets : outlets
                }
            }
        }
        
        if var outletsUnwrapped = outlets {
            for (i, outlet) in enumerate(outletsUnwrapped) {
                // We want at least one row if the number of rows is not defined
                var numberOfRows = outlet.item?.numberOfRowsFromTags()
                var rows = numberOfRows != nil ? numberOfRows! : 1
                
                if var widgets = outletsUnwrapped[i].linkedPage?.widgets {
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
    
    func addConstraintsToView() {
        var topObject = contentView
        
        // Add constraints to label
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
        
        // Add constraints to pageControl
        var pageControls = [String: AnyObject]()
        for (pageControlKey, pageControl) in pageControlsForControllers {
            pageControls["_\(pageControlKey)"] = pageControl
        }
        
        for (key, pageControl) in pageControls {
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(15)-[\(key)]-(15)-|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: pageControls))
        }
        
        // Add vertical constraints
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
}
