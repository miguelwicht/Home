//
//  OHItem.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 15/04/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import UIKit

public class OHItem {
    
    let type: String
    let name: String
    let state: String
    let link: String
    
    public init(type: String, name: String, state: String, link: String)
    {
        self.type = type
        self.name = name
        self.state = state
        self.link = link
    }
    
    public init(item: JSON)
    {
        var i = item.dictionaryValue
        
        self.type = i["type"]!.stringValue
        self.name = i["name"]!.stringValue
        self.state = i["state"]!.stringValue
        self.link = i["link"]!.stringValue
    }
    
    public func stateAsInt() -> Int
    {
        return state.toInt()!
    }
    
    public func stateAsFloat() -> Float
    {
        let numberFormatter = NSNumberFormatter()
        
        return numberFormatter.numberFromString(state)!.floatValue
    }
    
    public func stateAsUIColor() -> UIColor
    {
        let fallbackColor = UIColor(hue: 0.0, saturation: 0.0, brightness: 0.0, alpha: 1.0)
        
        let values: [String] = self.state.componentsSeparatedByString(",")
        
        if (values.count == 3)
        {
            let numberFormatter = NSNumberFormatter()
            let hue: CGFloat = CGFloat(numberFormatter.numberFromString(values[0])!.floatValue)
            let saturation: CGFloat = CGFloat(numberFormatter.numberFromString(values[1])!.floatValue)
            let brightness: CGFloat = CGFloat(numberFormatter.numberFromString(values[2])!.floatValue)
            
            return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
        }
        
        return fallbackColor
        
    }
}