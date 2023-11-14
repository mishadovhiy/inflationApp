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
}
