//
//  ColorWheel.swift
//  graphicsTests
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 17/04/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import UIKit

@IBDesignable class ColorWheel: UIControl {
    
    var padding: CGFloat = 1
    var ringWidth: CGFloat = 30
    var sectors: Int = 360
    var angle: Int = 0
    var radius: CGFloat = 100 / 2
    
    var handleSize: CGSize = CGSizeMake(50, 50)
    var button: UIButton?
    
    var circleView: UIImageView?
    var handleView: UIImageView?
    
    var currentColor: UIColor?
    
    var brightness: CGFloat = 0.8 {
        didSet {
            currentColor = getColorForAngle(angle)
            self.sendActionsForControlEvents(UIControlEvents.ValueChanged)
            changeHandleColor()
        }
    }
    
    
    var saturation: CGFloat = 1.0 {
        didSet {
            
//            var hue: CGFloat = 0.0
//            var saturation: CGFloat = 0.0
//            var brightness: CGFloat = 0.0
//            var alpha: CGFloat = 0.0
//            
//            var success = currentColor?.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
//            println("success: \(success), hue: \(hue), saturation: \(saturation), brightness: \(brightness), alpha: \(alpha)")
//            var color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
//            currentColor = color
            
            currentColor = getColorForAngle(angle)
            self.sendActionsForControlEvents(UIControlEvents.ValueChanged)
            changeHandleColor()
//            moveHandleToColor(currentColor!)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clearColor()
        let size = CGSizeMake(self.frame.size.width, self.frame.size.height);
        radius = CGFloat(min((size.width - self.padding), (size.width - self.padding) / 2)) // -1 to prevent clipping
        
        
        initCircleView()
        initButton()
        initHandle()
        
        moveHandleToColor(UIColor.purpleColor())
    }
    
    func initHandle()
    {
        handleView = UIImageView(frame: CGRectMake(0, 0, handleSize.width, handleSize.height))
        handleView?.backgroundColor = UIColor.clearColor()
        handleView?.userInteractionEnabled = false
        
        handleView?.image = drawHandle(CGSizeMake(50, 50)).imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        handleView?.layer.borderWidth = 3.0
        handleView?.layer.borderColor = UIColor.whiteColor().CGColor
        handleView?.layer.cornerRadius = handleView!.frame.width / 2.0
        
        handleView?.layer.shadowColor = UIColor.blackColor().CGColor;
        handleView?.layer.shadowOpacity = 0.5;
        handleView?.layer.shadowRadius = 3;
        handleView?.layer.shadowOffset = CGSizeMake(0, 1);
        
        self.addSubview(handleView!)
    }
    
    func initButton()
    {
        button = PowerButton.buttonWithType(.Custom) as! PowerButton
        
        button!.addTarget(button, action: "buttonPressed:", forControlEvents: .TouchUpInside)
        
        if var button = self.button {
            button.clipsToBounds = false
            
            var buttonRect = CGRect(x: 0, y: 0, width: self.frame.width - ringWidth * 2, height: self.frame.height - ringWidth * 2)
            var imageRect = CGRect(x: 0, y: 0, width: buttonRect.width + 40, height: buttonRect.height + 40)
            
            var buttonColor = UIColor(red: (235.0 / 255.0), green: (235.0 / 255.0), blue: (235.0 / 255.0), alpha: 1.0)
            var buttonTitleColor = UIColor(red: (126.0 / 255.0), green: (126.0 / 255.0), blue: (126.0 / 255.0), alpha: 1.0)
            
            var buttonImage = drawCircleWithColor(buttonColor, rect: imageRect)
            var buttonImageSelected = drawCircleWithColor(buttonTitleColor, rect: imageRect)
            
            let buttonBuffer: CGFloat = 40.0
            
            var buttonOrigin = CGPoint(x: self.bounds.origin.x + ringWidth + buttonBuffer, y: self.bounds.origin.y + ringWidth + buttonBuffer)
            var buttonSize = CGSize(width: self.frame.width - ringWidth * 2 - buttonBuffer * 2, height: self.frame.height - ringWidth * 2 - buttonBuffer * 2)
            
            button.frame = CGRect(x: buttonOrigin.x, y: buttonOrigin.y, width: buttonSize.width, height: buttonSize.height)
            button.layer.cornerRadius = (self.frame.width - ringWidth * 2) / 2.0
            
            button.setBackgroundImage(buttonImage, forState: .Normal)
            button.setTitleColor(buttonTitleColor, forState: .Normal)
            
            button.setBackgroundImage(buttonImageSelected, forState: .Selected)
            button.setTitleColor(buttonColor, forState: .Selected)
            
            button.setBackgroundImage(buttonImageSelected, forState: .Highlighted)
            button.setTitleColor(buttonColor, forState: .Highlighted)
            
//            button.setTitle("On", forState: .Normal)
//            button.setTitle("Off", forState: .Selected)
//            button.setTitle("Off", forState: .Highlighted)
            
            self.insertSubview(button, belowSubview: circleView!)
        }
        
    }
    
    func initCircleView()
    {
        self.circleView = UIImageView(frame: CGRectMake(0, 0, frame.width, frame.height))
        self.circleView?.image = self.drawRing()
        self.addSubview(self.circleView!)
    }

    required init(coder aDecoder: NSCoder) {
        self.circleView = UIImageView(frame: CGRectZero)
        self.handleView = UIImageView(frame: CGRectZero)
        button = UIButton.buttonWithType(.Custom) as! UIButton
        super.init(coder: aDecoder)
        self.addSubview(self.circleView!)
        self.backgroundColor = UIColor.clearColor()
    }
    
    func drawCircleWithColor(color: UIColor, rect: CGRect) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(rect.width, rect.height), false, 0.0);
        
        var ctx = UIGraphicsGetCurrentContext()

        CGContextSetLineWidth(ctx, 0.0);
        CGContextSetBlendMode(ctx, kCGBlendModeNormal)
        CGContextSetFillColorWithColor(ctx, color.CGColor)
        CGContextAddEllipseInRect(ctx, rect);
        CGContextFillPath(ctx);
        
        let buttonImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return buttonImage
    }
    
}

extension ColorWheel {
    //MARK: Handle
    /** Draw a white knob over the circle **/
    func drawHandle(size: CGSize) -> UIImage
    {
        let blurSize: CGFloat = 0
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width, size.height), false, 0.0);
        var ctx = UIGraphicsGetCurrentContext()
        //I Love shadows
        CGContextSetShadowWithColor(ctx, CGSizeMake(0, 0), blurSize, UIColor(red: 0, green: 0, blue: 0, alpha: 0.7).CGColor);
        
        //Get the handle position
        //var handleCenter = pointFromAngle(angle)
        var handleCenter = CGPointMake(size.width / 2 + blurSize, size.height / 2 + blurSize)
        
        //Draw It!
        UIColor(white:1.0, alpha:1.0).set();
        //CGContextFillEllipseInRect(ctx, CGRectMake(handleCenter.x, handleCenter.y, self.ringWidth, self.ringWidth));
        //CGContextFillEllipseInRect(ctx, CGRectMake(handleCenter.x, handleCenter.y, size.width, size.height));
        CGContextFillEllipseInRect(ctx, CGRectMake(blurSize, blurSize, size.width - blurSize * 2, size.height - blurSize * 2));
        
        let handleImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        
        
        return handleImage
    }
    
    /** Move the Handle **/
    func moveHandleToPoint(point: CGPoint)
    {
        //Get the center
        let centerPoint:CGPoint  = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        //Calculate the direction from a center point and a arbitrary position.
        let currentAngle:Double = AngleFromNorth(centerPoint, p2: point, flipped: false);
        let angleInt = Int(floor(currentAngle))
        
        //Store the new angle
        angle = Int(360 - angleInt)
        
        var newPoint: CGPoint = self.pointFromAngle(angle)
        
        angle = angleInt
        
        handleView!.frame.origin.x = newPoint.x - handleView!.frame.size.width
        handleView!.frame.origin.y = newPoint.y - handleView!.frame.size.height
    }
    
    func getColorForAngle(angle: Int) -> UIColor {
        var hue: CGFloat = CGFloat(angle) / CGFloat(sectors)
        var color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
        
        return color
    }
    
    func getAngleForColor(color: UIColor) -> Int
    {
        var col = CIColor(color: color)
        
        var red = CGFloat(col!.red() * 255)
        var green = CGFloat(col!.green() * 255)
        var blue = CGFloat(col!.blue() * 255)
        
        var hue = calculateHue(Int(red), green: Int(green), blue: Int(blue))
//        var hue = calculateHue(Int(colRed), green: Int(colGreen), blue: Int(colBlue))
        var angle = Int(hue * CGFloat(sectors))
        
//        angle = Int(360 - angle)
        
        return angle
    }
    
    func changeHandleColor() {
        currentColor = getColorForAngle(angle)
        
        button!.layer.borderColor = currentColor!.CGColor
        handleView?.tintColor = currentColor!
    }
    
    func updateHandleWithPoint(point: CGPoint)
    {
        self.moveHandleToPoint(point)
        changeHandleColor()
    }
    
    /** Given the angle, get the point position on circumference **/
    func pointFromAngle(angleInt:Int)->CGPoint{
        
        //Circle center
        let centerPoint = CGPointMake((self.frame.size.width + handleView!.frame.size.width)/2.0, (self.frame.size.height + handleView!.frame.size.height)/2.0);
        
        //The point position on the circumference
        var result:CGPoint = CGPointZero
        let y = round(Double(radius - self.ringWidth / 2) * sin(DegreesToRadians(Double(-angleInt)))) + Double(centerPoint.y)
        let x = round(Double(radius - self.ringWidth / 2) * cos(DegreesToRadians(Double(-angleInt)))) + Double(centerPoint.x)
        
        result.y = CGFloat(y)
        result.x = CGFloat(x)
        
        return result;
    }
    
    
    //Sourcecode from Apple example clockControl
    //Calculate the direction in degrees from a center point to an arbitrary position.
    func AngleFromNorth(p1:CGPoint , p2:CGPoint , flipped:Bool) -> Double {
        var v:CGPoint  = CGPointMake(p2.x - p1.x, p2.y - p1.y)
        let vmag:CGFloat = Square(Square(v.x) + Square(v.y))
        var result:Double = 0.0
        v.x /= vmag;
        v.y /= vmag;
        let radians = Double(atan2(v.y,v.x))
        result = RadiansToDegrees(radians)
        return (result >= 0  ? result : result + 360.0);
    }
}

extension ColorWheel {
    // MARK: Math Helpers
    
    func DegreesToRadians (value:Double) -> Double {
        return value * M_PI / 180.0
    }
    
    func RadiansToDegrees (value:Double) -> Double {
        return value * 180.0 / M_PI
    }
    
    func Square (value:CGFloat) -> CGFloat {
        return value * value
    }
    
    func calculateHue(red: Int, green: Int, blue: Int) -> CGFloat
    {
        var minVal = CGFloat(min(min(red, green), blue))
        var maxVal = CGFloat(max(max(red, green), blue))
        
        var hue: CGFloat = 0.0
        
        if (maxVal == CGFloat(red))
        {
            hue = CGFloat(green - blue) / CGFloat(maxVal - minVal)
        }
        else if (maxVal == CGFloat(green))
        {
            hue = 2.0 + CGFloat(blue - red) / CGFloat(maxVal - minVal)
        }
        else
        {
            hue = 4.0 + CGFloat(red - green) / CGFloat(maxVal - minVal)
        }
        
        hue *= 60
        
        hue = hue < 0 ? hue + 360 : hue
        
        hue = CGFloat(hue / 255.0)
        
        return hue
    }
    
    func moveHandleToColor(color: UIColor)
    {
        var angle = getAngleForColor(color)
        var point = pointFromAngle(angle)
        
        updateHandleWithPoint(point)
        self.sendActionsForControlEvents(UIControlEvents.ValueChanged)
    }
}

extension ColorWheel {
    //MARK: Drawing
    
    func drawRing() -> UIImage
    {
        let size = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width, size.height), false, 0.0);
        
//        self.radius = CGFloat(min((size.width - 10), (size.height - 10) / 2)) // -1 to prevent clipping
        
//        self.radius = CGFloat(min((size.width), (size.height) / 2)) // -1 to prevent clipping
        
        let center: CGPoint = CGPointMake(size.width/2, size.height/2)
        
        let ctx = UIGraphicsGetCurrentContext()
        
        UIColor.clearColor().setFill();
        //UIRectFill(CGRectMake(0, 0, size.width, size.height));
        
        
        let angle: CGFloat = CGFloat(2 * M_PI / Double(sectors))
        var colorCirclePath: UIBezierPath = UIBezierPath()
        
        for (var i: Int = 0; i < sectors; i++)
        {
            let startAngle = CGFloat(i) * CGFloat(angle)
            let endAngle = (CGFloat(i) + 1) * CGFloat(angle)
            
            colorCirclePath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            
            colorCirclePath.addLineToPoint(center);
            colorCirclePath.closePath();
            
//            var hue: CGFloat = CGFloat(i) / CGFloat(sectors)
//            var color = UIColor(hue: hue, saturation: 1.0, brightness: 0.85, alpha: 1.0)
            
            var color = getColorForAngle(i)
            
            color.setFill()
            color.setStroke()
            colorCirclePath.fill()
            colorCirclePath.stroke()
        }
        
        // Remove circle in the middle to create the ring
        CGContextSaveGState(ctx);
        
        CGContextSetLineWidth(ctx, 0.0);
        CGContextSetBlendMode(ctx, kCGBlendModeClear); // Set blendMode to clear to erase center
        CGContextSetFillColorWithColor(ctx, UIColor.blueColor().CGColor)
        let rectangle = CGRectMake(self.bounds.origin.x + self.ringWidth, self.bounds.origin.y + self.ringWidth, self.frame.width - self.ringWidth * 2, self.frame.height - self.ringWidth * 2);
        CGContextAddEllipseInRect(ctx, rectangle);
        CGContextFillPath(ctx);
        CGContextRestoreGState(ctx);
        
        let ringImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        
        return ringImage
    }
}

extension ColorWheel {
    //MARK: Touch Tracking
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) -> Bool {
        super.beginTrackingWithTouch(touch, withEvent: event)
        
        updateHandleWithPoint(touch.locationInView(self))
        self.sendActionsForControlEvents(UIControlEvents.ValueChanged)
        
        return true
    }
    
    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) -> Bool {
        super.continueTrackingWithTouch(touch, withEvent: event)
        
        updateHandleWithPoint(touch.locationInView(self))
        self.sendActionsForControlEvents(UIControlEvents.ValueChanged)
        
        return true
    }
    
    override func endTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) {
        super.endTrackingWithTouch(touch, withEvent: event)
    }
}