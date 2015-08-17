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
    
    var notificationConstraints: [NSLayoutConstraint]?
    
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
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let recognizer = UITapGestureRecognizer(target: self, action:"removeNotification")
        self.view.addGestureRecognizer(recognizer)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func loadView() {
        super.loadView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textLabel)
        
//        textLabel.text = "Awesome message awdasdasd asd asdasd asda sda sdasd asdasd a"
        textLabel.numberOfLines = 0
        
        
        
        let views = ["label": textLabel]
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(15)-[label]-(15)-|", options: NSLayoutFormatOptions(), metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(15)-[label]-(15)-|", options: NSLayoutFormatOptions(), metrics: nil, views: views))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setMessage(message: String) {
        textLabel.text = message
    }
    
    func addNotificationToView(view: UIView) {
        view.addSubview(self.view)
        
        if notificationConstraints == nil {
            let views: [String: AnyObject] = ["notification": self.view]
            notificationConstraints = [NSLayoutConstraint]()
            
            let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[notification]-(0)-|", options: NSLayoutFormatOptions(), metrics: nil, views: views)
            let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[notification]-(0)-|", options: NSLayoutFormatOptions(), metrics: nil, views: views)

            for (_, element) in verticalConstraints.enumerate() {
                notificationConstraints?.append(element)
            }
            
            for (_, element) in horizontalConstraints.enumerate() {
                notificationConstraints?.append(element)
            }
        }
        
        if let notificationConstraints = self.notificationConstraints {
            view.addConstraints(notificationConstraints)
        }
    }
    
    func removeNotification() {
        if let notificationConstraints = self.notificationConstraints {
            view.superview?.removeConstraints(notificationConstraints)
        }
        
        view.removeFromSuperview()
    }
}
