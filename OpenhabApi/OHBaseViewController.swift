//
//  OHBaseViewController.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 14/05/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import UIKit

class OHBaseViewController: UIViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?)
    {
        super.init(nibName: nil, bundle: nil)
        
        initNavigationBar()
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        initNavigationBar()
    }
    
    override func loadView()
    {
        super.loadView()
        
        self.view.backgroundColor = UIColor.whiteColor()
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension OHBaseViewController {
    
    func initNavigationBar()
    {
        addLeftNavigationBarItems()
        addRightNavigationBarItems()
    }
    
    func addLeftNavigationBarItems()
    {
        var menuItemImage = UIImageView(image: UIImage(named: "menu"))
        var item = UIBarButtonItem(customView: menuItemImage)
        self.navigationItem.leftBarButtonItem = item
    }
    
    func addRightNavigationBarItems()
    {
    
    }
}