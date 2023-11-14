//
//  CALayer.swift
//  Inflation
//
//  Created by Misha Dovhiy on 14.11.2023.
//  Copyright © 2023 Misha Dovhiy. All rights reserved.
//

import UIKit

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
