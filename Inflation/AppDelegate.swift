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

    static var shared:AppDelegate?
    var window: UIWindow?
    lazy var banner: AdsBannerView = {
        return AdsBannerView.instanceFromNib() as! AdsBannerView
    }()
    var api = Api()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppDelegate.shared = self
        banner.createBanner()
        validateUrl()
        return true
    }

    
    func applicationDidBecomeActive(_ application: UIApplication) {

    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    
    private func validateUrl() {
        DispatchQueue(label: "db", qos: .userInitiated).async {
            if DB.db.urlSettedDate != 0,
               let d = Calendar.current.date(from: DB.db.urlSettedDate.dateComponents)?.differenceFromNow
            {
                print(d, " dateSetted from now")
                if (d.day ?? 0) >= 7 || (d.month ?? 0) >= 1 || (d.year ?? 0) >= 1 {
                    print("urlExpired")
                    DB.db.appUrl = nil
                }
                
            }
        }
    }
}

