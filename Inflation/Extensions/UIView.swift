//
//  UIView.swift
//  Inflation
//
//  Created by Misha Dovhiy on 14.11.2023.
//  Copyright © 2023 Misha Dovhiy. All rights reserved.
//

import UIKit

extension UIView {
    func contains(touches:Set<UITouch>) -> Bool {
        if let touch = touches.first {
            let touchLocation = touch.location(in: self)
            
            return self.bounds.contains(touchLocation)
        } else {
            return false
        }
    }
    
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




