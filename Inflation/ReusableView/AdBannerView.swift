//
//  AdBannerView.swift
//  Inflation
//
//  Created by Misha Dovhiy on 14.11.2023.
//  Copyright © 2023 Misha Dovhiy. All rights reserved.
//

import GoogleMobileAds
import SwiftUI
import UIKit

struct GADBannerViewController: UIViewControllerRepresentable {
    
    static var size:CGSize = .init(width: 320, height: 55)
    
    func makeUIViewController(context: Context) -> UIViewController {
        let adSize = GADAdSizeFromCGSize(CGSize(width: GADBannerViewController.size.width, height: GADBannerViewController.size.height))
        let view = GADBannerView(adSize: adSize)
        let viewController = UIViewController()
        view.adUnitID = "ca-app-pub-3940256099942544/6300978111"///"ca-app-pub-5463058852615321/7238643809"
        view.rootViewController = viewController
        viewController.view.addSubview(view)
        viewController.view.frame = CGRect(origin: .zero, size: adSize.size)
        view.load(GADRequest())
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
