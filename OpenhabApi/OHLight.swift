//
//  OHLight.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 01/06/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import Foundation

@objc public class OHLight {
    
    public var dimmer: OHItem?
    public var color: OHItem?
    
    public var widget: OHWidget?
    
    public init(dimmer: OHItem?, color: OHItem?) {
        self.dimmer = dimmer
        self.color = color
    }
    
    public init(widget: OHWidget)
    {
        self.widget = widget
        
        if var widgets = self.widget?.linkedPage?.widgets {
            for (index, w) in enumerate(widgets)
            {
                if var item = w.item {
                    if item.type == "ColorItem" {
                        color = item
                    } else if (item.type == "DimmerItem") {
                        dimmer = item
                    }
                }
            }
        }
    }
    
    public func setColorValue(value: String)
    {
        if var color = self.color {
            color.sendCommand(value)
        }
    }
    
    public func setDimmerValue(value: Int)
    {
        if var dimmer = self.dimmer {
            dimmer.sendCommand("\(value)")
            dimmer.state = "\(value)"
        }
    }
    
    public func setState(state: String)
    {
        if var dimmer = self.dimmer {
            dimmer.sendCommand("\(state)")
        }
    }
}

//MARK: OHLight: Printable
extension OHLight : Printable {
    
    public var description: String
        {
            var desc = ""
            desc += "OHLight: {\n"
            desc += "\tdimmer: \(dimmer), \n"
            desc += "\tcolor: \(color), \n"
            desc += "}"
            
            return desc
    }
}
