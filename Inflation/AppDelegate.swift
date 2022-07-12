//
//  AppDelegate.swift
//  Inflation
//
//  Created by Misha Dovhiy on 27.11.2019.
//  Copyright © 2019 Misha Dovhiy. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    let analyticsName = "appdelegate"
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        AnalyticModel.shared.analiticStorage.append(.init(key: #function.description, action: analyticsName))
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        AnalyticModel.shared.analiticStorage.append(.init(key: #function.description, action: analyticsName))
        AnalyticModel.shared.checkData()
    }

}

