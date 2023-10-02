//
//  NumberButton.swift
//  Inflation
//
//  Created by Misha Dovhiy on 30.09.2023.
//  Copyright © 2023 Misha Dovhiy. All rights reserved.
//

import UIKit

class NumberButton: Button {

    override func firstMoved() {
        super.firstMoved()
        let borderColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 1)
        layer.cornerRadius = 9
        layer.borderWidth = 1
        layer.borderColor = borderColor.cgColor
        customTouchAnimation = { touched in
            UIView.animate(withDuration: 0.2, delay: 0, options: .allowUserInteraction, animations: {
                self.backgroundColor = touched ? borderColor : .clear
            })
        }
    }
}
