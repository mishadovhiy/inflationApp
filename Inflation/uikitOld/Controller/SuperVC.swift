//
//  SuperVC.swift
//  Inflation
//
//  Created by Misha Dovhiy on 02.12.2022.
//  Copyright © 2022 Misha Dovhiy. All rights reserved.
//

import UIKit

class SuperVC:UIViewController {
    private var sbvsLoaded = false
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !sbvsLoaded {
            sbvsLoaded = true
            
            self.additionalSafeAreaInsets.bottom = 60
        }
    }
}

