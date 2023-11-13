//
//  Extensions.swift
//  Inflation
//
//  Created by Misha Dovhiy on 17.09.2023.
//  Copyright © 2023 Misha Dovhiy. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

extension Date {
    var differenceFromNow: DateComponents {
        return Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self, to: Date())
    }
    
    func toDateComponents() -> DateComponents {
        let string = self.iso8601withFractionalSeconds
        let comp = DateComponents()
        return comp.stringToCompIso(s: string)
    }
    var iso8601withFractionalSeconds: String {
        return Formatter.iso8601withFractionalSeconds.string(from: self)
        
    }
    
}

extension String {
    var iso8601withFractionalSeconds: Date? {
        return Formatter.iso8601withFractionalSeconds.date(from: self)
        
    }
}
extension DateComponents {
    var intDate:UInt64 {
        let date = Calendar.current.date(from: self)
        let timeInterval = date?.timeIntervalSince1970
        let int = UInt64(timeInterval ?? 0)
        return int
    }
    func toIsoString() -> String? {
        if let date = Calendar.current.date(from: self){
            return date.iso8601withFractionalSeconds
        }
        return nil
    }
    func stringToCompIso(s: String, dateFormat:String="dd.MM.yyyy") -> DateComponents {
        if let date = s.iso8601withFractionalSeconds {
            return Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        } else {
            return stringToDateComponent(s: s, dateFormat: dateFormat)
        }
    }
    
    private func stringToDateComponent(s: String, dateFormat:String="dd.MM.yyyy") -> DateComponents {//make privat
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.date(from: s)
        return Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date ?? Date())
    }
    
}

extension ISO8601DateFormatter {
    convenience init(_ formatOptions: Options) {
        self.init()
        self.formatOptions = formatOptions
    }
}
extension Formatter {
    static let iso8601withFractionalSeconds = ISO8601DateFormatter([.withInternetDateTime, .withFractionalSeconds])
}

extension Int {
    var dateComponents:DateComponents {
        return Date.init(timeIntervalSince1970: TimeInterval(self)).toDateComponents()
    }
}

extension UInt64 {
    var dateComponents:DateComponents {
        return Int(self).dateComponents
    }
}


extension UIView {
    func contains(touches:Set<UITouch>) -> Bool {
        if let touch = touches.first {
                    let touchLocation = touch.location(in: self)
                    
                    return self.bounds.contains(touchLocation)
        } else {
            return false
        }
    }
}


extension CALayer {
    enum MoveDirection {
        case top
        case left
    }
    
    func move(_ direction:MoveDirection, value:CGFloat) {
        switch direction {
        case .top:
            self.transform = CATransform3DTranslate(CATransform3DIdentity, 0, value, 0)
        case .left:
            self.transform = CATransform3DTranslate(CATransform3DIdentity, value, 0, 0)
        }
    }
    
    func zoom(value:CGFloat) {
        self.transform = CATransform3DMakeScale(value, value, 1)
    }
    
    enum KeyPath:String {
        case height = "bounds.size.height"
        case background = "backgroundColor"
        
        func from(_ view:CALayer) -> Any {
            switch self {
            case .height:
                return view.bounds.size.height
            case .background:
                return view.backgroundColor ?? UIColor.black.cgColor
            }
        }
        
        func to(_ view:CALayer) -> Any? {
            switch self {
            case .height:
                return 0
            case .background:
                return nil
                //UIColor(cgColor:(view.backgroundColor ?? UIColor.black.cgColor)).lighter(0.3).cgColor
            }
        }
        
        func set(to:Any?, view:CALayer) {
            switch self {
            case .height:
                view.bounds.size.height = ((to ?? self.to(view)) as? CGFloat ?? 0)
            case .background:
                view.backgroundColor = ((to ?? self.to(view)) as! CGColor)
            }
        }
    }

    enum AnimationKey:String {
        case general = "backgroundpress"
        case general1 = "backgroundpress1"
        
    }
    
    func performAnimation(key:KeyPath,
                          to:Any? = nil,
                          code:AnimationKey = .general,
                          duration:CGFloat = 0.5,
                          completion:(()->())? = nil
    ) {
     //   self.removeAnimation(forKey: key.rawValue)
        let animation = CABasicAnimation(keyPath: key.rawValue)
        animation.fromValue = key.from(self)
        animation.toValue = to ?? key.to(self)
        animation.duration = duration
        animation.beginTime = CACurrentMediaTime()
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            key.set(to: to, view: self)
            completion?()
        }
        self.add(animation, forKey: code.rawValue)
        CATransaction.commit()
    }
}


extension UIColor {
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
    
    func lighter(_ componentDelta: CGFloat = 0.1) -> UIColor {
        return makeColor(componentDelta:componentDelta)
    }
    
    func darker(_ componentDelta: CGFloat = 0.1) -> UIColor {
        return makeColor(componentDelta:-1*componentDelta)
    }
}
