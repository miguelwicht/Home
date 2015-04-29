//
//  ViewController.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 13/04/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        let restManager = OHRestManager(baseUrl: "http://10.10.32.251:8888")
//        restManager.delegate = self
//        restManager.getBeacons()
//        restManager.getItems()
//        restManager.getSitemaps()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: OHRestManagerDelegate {
    func didGetItems(items: [JSON]) {
        println(items)
    }
    
    func didGetBeacons(beacons: [OHBeacon]) {
        println(beacons)
    }
    
    func didGetSitemaps(sitemaps: [OHSitemap]) {
        println(sitemaps)
    }
}
