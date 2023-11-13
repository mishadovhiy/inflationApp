//
//  View.swift
//  Inflation
//
//  Created by Misha Dovhiy on 24.09.2023.
//  Copyright © 2023 Misha Dovhiy. All rights reserved.
//

import UIKit

@IBDesignable
class ViewRegular: UIView {
    @IBInspectable open var linkBackground:Bool = false {
        didSet {
            if linkBackground {
                self.backgroundColor = self.tintColor.withAlphaComponent(0.15)
            }
        }
    }
    @IBInspectable open var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }
    
    @IBInspectable open var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = self.borderWidth
        }
    }
    
    @IBInspectable open var lineColor: UIColor? = nil {
        didSet {
            if let color = lineColor {
                self.layer.borderWidth = borderWidth == 0 ? 2 : borderWidth
                self.layer.borderColor = color.cgColor
            }
        }
    }
    

    @IBInspectable open var shadowOpasity: Float = 0 {
        didSet {
            if !backgroundShadow {
                self.layer.shadow(opasity: shadowOpasity)
            }
        }
    }
    @IBInspectable open var backgroundShadow: Bool = false {
        didSet {
            if backgroundShadow {
                self.layer.shadow(opasity: 0.3, offset: .init(width: 2, height: 5), color: self.backgroundColor ?? .black, radius: 5)
            }
            
        }
    }
    override func resignFirstResponder() -> Bool {
        return super.resignFirstResponder()
    }
    
    
    
    
    
    var pressedcolor:UIColor? = nil
    @IBInspectable open var pressColor: UIColor? = nil {
        didSet {
            if let color = pressColor {
                self.pressedcolor = color
            }
        }
    }
    

    var pressed:(()->())?
    var customTouchAnimation:((_ touched:Bool) ->())?
    
    private var backHolder:UIColor?
    override var backgroundColor: UIColor? {
        get { return super.backgroundColor }
        set {
            if backHolder == nil {
                backHolder = newValue
            }
            super.backgroundColor = newValue
        }
    }
    
    private var animationCompleted:Bool = true
    private var animationCompletionAction:(()->())?
    
    private func touch(_ begun:Bool) {
        if animationCompleted {
            animationCompleted = false
            if let customAnimation = customTouchAnimation {
                customAnimation(begun)
            } else {
                self.defaultAnimation(begun: begun)
            }
        } else {
            animationCompletionAction = {
                self.touch(begun)
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        touch(true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        touch(false)
        if self.contains(touches: touches) {
            pressed?()
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        touch(self.contains(touches: touches))
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        touch(false)
    }
    
    
    private func defaultAnimation(begun:Bool) {
        let defaultColor = self.backHolder ?? .white

        self.layer.performAnimation(key: .background, to: begun ? defaultColor.lighter(0.3).cgColor : defaultColor.cgColor, duration: 0.1, completion: {
            self.animationCompleted = true
            if let action = self.animationCompletionAction {
                self.animationCompletionAction = nil
                action()
            }
        })
    }

}


class ButtonRegular:UIButton {
    private var moveToWindow:Bool = false
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if !moveToWindow {
            self.moveToWindow = true
            firstMoved()
        }
    }
    
    func firstMoved() {
        
    }
    
    var pressedcolor:UIColor? = nil
    @IBInspectable open var pressColor: UIColor? = nil {
        didSet {
            if let color = pressColor {
                self.pressedcolor = color
            }
        }
    }
    

    var pressed:(()->())?
    var customTouchAnimation:((_ touched:Bool) ->())?
    
    private var backHolder:UIColor?
    override var backgroundColor: UIColor? {
        get { return super.backgroundColor }
        set {
            if backHolder == nil {
                backHolder = newValue
            }
            super.backgroundColor = newValue
        }
    }
    
    private var animationCompleted:Bool = true
    private var animationCompletionAction:(()->())?
    
    private func touch(_ begun:Bool) {
       /* if animationCompleted {
            animationCompleted = false
            if let customAnimation = customTouchAnimation {
                customAnimation(begun)
            } else {
                self.defaultAnimation(begun: begun)
            }
        } else {
            animationCompletionAction = {
                self.touch(begun)
            }
        }*/
        if let customAnimation = customTouchAnimation {
            customAnimation(begun)
        } else {
            self.defaultAnimation(begun: begun)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        touch(true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        touch(false)
        if self.contains(touches: touches) {
            pressed?()
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        touch(self.contains(touches: touches))
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        touch(false)
    }
    
    
    private func defaultAnimation(begun:Bool) {
        let defaultColor = self.backHolder ?? .white

        self.layer.performAnimation(key: .background, to: begun ? defaultColor.lighter(0.3).cgColor : defaultColor.cgColor, duration: 0.1, completion: {
            self.animationCompleted = true
            if let action = self.animationCompletionAction {
                self.animationCompletionAction = nil
                action()
            }
        })
    }
}





extension UIView {
    func addConstaits(_ constants:[NSLayoutConstraint.Attribute:CGFloat], superV:UIView) {
        let layout = superV
        constants.forEach { (key, value) in
            let keyNil = key == .height || key == .width
            let item:Any? = keyNil ? nil : layout
            superV.addConstraint(.init(item: self, attribute: key, relatedBy: .equal, toItem: item, attribute: key, multiplier: 1, constant: value))
        }
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension UIColor {
    public convenience init?(hex:String) {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
                if #available(iOS 14.0, *) {
                    self.init(.gray)
                } else {
                    self.init()
                    // Fallback on earlier versions
                }
            return
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        if #available(iOS 14.0, *) {
            self.init(
                red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: CGFloat(1.0)
            )
        } else {
            self.init()
        }
    }
    func lighter(componentDelta: CGFloat = 0.1) -> UIColor {
        return makeColor(componentDelta: componentDelta)
    }
    
    func darker(componentDelta: CGFloat = 0.1) -> UIColor {
        return makeColor(componentDelta: -1*componentDelta)
    }
    
    
    
    private func makeColor(componentDelta: CGFloat) -> UIColor {
        var red: CGFloat = 0
        var blue: CGFloat = 0
        var green: CGFloat = 0
        var alpha: CGFloat = 0

        
        getRed(
            &red,
            green: &green,
            blue: &blue,
            alpha: &alpha
        )

        
        return UIColor(
            red: add(componentDelta, toComponent: red),
            green: add(componentDelta, toComponent: green),
            blue: add(componentDelta, toComponent: blue),
            alpha: alpha
        )
    }
    
    private func add(_ value: CGFloat, toComponent: CGFloat) -> CGFloat {
        return max(0, min(1, toComponent + value))
    }
}



extension CALayer {
    enum MulltippleGradientType:Int {
        case bluePurpure = 0
        case blueViolet = 1
        case greenBlue = 2
        case pinkYellow = 3
        case orangeBlue = 4
        

        init?(rawValue: Int?) {
            switch rawValue ?? -1 {
            case 0: self = .bluePurpure
            case 1: self = .blueViolet
            case 2: self = .greenBlue
            case 3: self = .pinkYellow
            case 4: self = .orangeBlue
            default:
                self = .init(rawValue: Int.random(in: 0..<4)) ?? .bluePurpure
            }
        }
    }
    func mulltippleGradient(_ type: MulltippleGradientType, dark:Bool, width:CGFloat? = nil, height:CGFloat? = nil) {
        let alpha = dark ? 0.4 : 1
        let frame:CGRect = .init(x: 0, y: 0, width: width ?? self.bounds.width + 20, height: (height ?? self.bounds.height) + 50)
        let gradientColors = typeToColorsMulttiple(type, alpha: alpha)
        let name = "MulltippleGradientType"
        self.sublayers?.removeAll(where: { layer in
            return layer.name == name
        })
        let gradient = self.gradient(colors: gradientColors.background,
                                     points: (start: .init(x: 0, y: 0.5), end: .init(x: 1, y: 0)),
                                     locations: [0.0, 0.6, 1.0],
                                     frame: frame,
                                     insertAt: 0)
        gradient?.name = name
        let oval = ovalGradient(frame: frame, color: gradientColors.oval)
        oval?.name = name
        
    }
    func ovalGradient(frame:CGRect, color: [CGColor], insert:UInt32? = 1, middle:Bool = false, radous:CGFloat? = nil) -> CAGradientLayer? {
        return self.gradient(colors: color,
                             points: (start: .init(x: 0.8, y: !middle ? 0.1 : 0.5), end: .init(x: 1, y: 1)),
                             locations: [0.0, 0.75, 1.0],
                             frame: frame,
                             type: .radial,
                             insertAt: insert,
                             radious: radous
        )
    }
    func gradient(colors:[CGColor], points:(start:CGPoint, end:CGPoint), locations:[NSNumber]?, frame:CGRect? = nil, type:CAGradientLayerType? = nil, insertAt:UInt32? = nil, zpozition:Int? = nil, radious:CGFloat? = nil, opasity:Float? = nil) -> CAGradientLayer? {
        let l = CAGradientLayer()
        l.colors = colors
        if let type = type {
            l.type = type
        }
        if let radious = radious {
            l.cornerRadius = radious
        }
        if let locations = locations {
            l.locations = locations
        }
        
        l.startPoint = points.start
        l.endPoint = points.end
        l.frame = frame ?? .init(x: frame?.midX ?? 0, y: frame?.midY ?? 0, width: self.frame.width, height: self.frame.height)
        //.init(x: 0, y: 0, width: frame.width, height: frame.height)
        if let at = insertAt {
            self.insertSublayer(l, at: at)
        } else {
            self.addSublayer(l)
        }
        if let zpozition = zpozition {
            l.zPosition = CGFloat.init(integerLiteral: zpozition)
        }
        if let opasity = opasity {
            l.opacity = opasity
        }
        return l
    }
    func typeToColorsMulttiple(_ type:MulltippleGradientType, alpha:CGFloat) -> (background: [CGColor], oval:[CGColor]) {
        switch type {
        case .bluePurpure:
            return (background: [
                UIColor.init(red: 82/255, green: 159/255, blue: 231/255, alpha: alpha).cgColor,
                UIColor.init(red: 211/255, green: 58/255, blue: 245/255, alpha: alpha).cgColor
            ],
                    oval:[
                        UIColor.init(red: 194/255, green: 45/255, blue: 143/255, alpha: alpha).cgColor,
                        UIColor.init(red: 194/255, green: 45/255, blue: 143/255, alpha: 0).cgColor,
                    ])
        case .orangeBlue:
            return (background: [
                UIColor.init(red: 250/255, green: 141/255, blue: 12/255, alpha: 1).cgColor,
                UIColor.blue.cgColor,
            ],
                    oval:[
                        UIColor.init(red: 254/255, green: 12/255, blue: 99/255, alpha: 0.6).cgColor,
                        UIColor.init(red: 254/255, green: 12/255, blue: 99/255, alpha: 0).cgColor,
                    ])
        case .blueViolet:
            return (background: [
                UIColor.init(red: 107/255, green: 187/255, blue: 139/255, alpha: alpha).cgColor,
                UIColor.init(red: 88/255, green: 40/255, blue: 190/255, alpha: alpha).cgColor
            ],
                    oval:[
                        UIColor.init(red: 213/255, green: 80/255, blue: 104/255, alpha: alpha).cgColor,
                        UIColor.init(red: 213/255, green: 80/255, blue: 104/255, alpha: 0).cgColor
                    ])
        case .greenBlue:
            return (background: [
                UIColor.init(red: 213/255, green: 184/255, blue: 80/255, alpha: alpha).cgColor,
                UIColor.init(red: 26/255, green: 54/255, blue: 58/255, alpha: alpha).cgColor
            ],
                    oval:[
                        UIColor.init(red: 80/255, green: 93/255, blue: 213/255, alpha: alpha).cgColor,
                        UIColor.init(red: 80/255, green: 93/255, blue: 213/255, alpha: 0).cgColor,
                    ])
        case .pinkYellow:
            return (background: [
                UIColor.init(red: 82/255, green: 159/255, blue: 231/255, alpha: alpha).cgColor,
                UIColor.init(red: 211/255, green: 58/255, blue: 245/255, alpha: alpha).cgColor
            ],
                    oval:[
                        UIColor.init(red: 194/255, green: 45/255, blue: 143/255, alpha: alpha).cgColor,
                        UIColor.init(red: 194/255, green: 45/255, blue: 143/255, alpha: 0).cgColor,
                    ])
        }
    }
    func shadow(opasity:Float = 0.6, offset:CGSize = .init(width: 0, height: 0), color:UIColor? = nil, radius:CGFloat = 10) {
        self.shadowColor = (color ?? .black).cgColor
        self.shadowOffset = offset
        self.shadowRadius = radius
        self.shadowOpacity = opasity
    }
}
