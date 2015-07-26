//
//  OHLight.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 01/06/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import Foundation

public class OHLight {
    
    public var dimmer: OHItem?
    public var color: OHItem?
    public var widget: OHWidget?
    public var label: String?
    
    public init(dimmer: OHItem?, color: OHItem?) {
        self.dimmer = dimmer
        self.color = color
    }
    
    public init(widget: OHWidget) {
        self.widget = widget
        
        if let widgets = self.widget?.linkedPage?.widgets {
            for (_, w) in widgets.enumerate() {
                if let item = w.item {
                    if item.type == "ColorItem" {
                        color = item
                    } else if (item.type == "DimmerItem") {
                        dimmer = item
                    }
                }
            }
        }
    }
    
    public func setColorValue(value: String) {
        if let color = self.color {
            color.sendCommand(value)
        }
    }
    
    public func setDimmerValue(value: Int) {
        if let dimmer = self.dimmer {
            dimmer.sendCommand("\(value)")
            dimmer.state = "\(value)"
        }
    }
    
    public func setState(state: String) {
        if let dimmer = self.dimmer {
            dimmer.sendCommand("\(state)")
        }
    }
}

//MARK: OHLight: Printable
extension OHLight : CustomStringConvertible {
    
    public var description: String {
        var desc = ""
        desc += "OHLight: {\n"
        desc += "\tdimmer: \(dimmer), \n"
        desc += "\tcolor: \(color), \n"
        desc += "}"
        
        return desc
    }
}
