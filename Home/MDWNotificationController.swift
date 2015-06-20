//
//  MDWNotificationController.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 17/06/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import UIKit

enum MDWNotificationType {
    case Normal
    case Success
    case Error
    case Custom
}

class MDWNotificationController: UIViewController {
    
    var normalColor = UIColor.grayColor()
    var successColor = UIColor.greenColor()
    var errorColor = UIColor.redColor()
    var customColor: UIColor?
    
    
    var dismissButton = UIButton()
    var textLabel = UILabel()
    
    var type = MDWNotificationType.Normal {
        didSet {
            switch(type) {
                case .Normal:
                    self.view.backgroundColor = normalColor
                case .Success:
                    view.backgroundColor = successColor
                case .Error:
                    view.backgroundColor = errorColor
                case .Custom:
                    view.backgroundColor = customColor
                default:
                    view.backgroundColor = normalColor
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func loadView() {
        super.loadView()
        
        view.addSubview(textLabel)
        
        textLabel.text = "Awesome message"
        
        view.addSubview(dismissButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
