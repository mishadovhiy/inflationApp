//
//  adBannerView.swift
//  Inflation
//
//  Created by Misha Dovhiy on 24.04.2022.
//  Copyright © 2022 Misha Dovhiy. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AdsBannerView: UIView {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet private weak var stackView: UIStackView!
    
    var _size:CGFloat = 0
    var adHidden = true
    var adNotReceved = true
    
    public func createBanner() {
        GADMobileAds.sharedInstance().start { status in
            DispatchQueue.main.async {
                let window = AppDelegate.shared?.window ?? UIWindow()
                let height = self.backgroundView.frame.height
                let screenWidth:CGFloat = window.frame.width > 330 ? 320 : 300
                let adSize = GADAdSizeFromCGSize(CGSize(width: screenWidth, height: height))
                self.size = height
                let bannerView = GADBannerView(adSize: adSize)
                bannerView.adUnitID = "ca-app-pub-5463058852615321/7238643809"
                bannerView.rootViewController = AppDelegate.shared?.window?.rootViewController
                bannerView.load(GADRequest())
                bannerView.delegate = self
                self.stackView.addArrangedSubview(bannerView)
                self.addConstants(window)
                self.stackView.layer.cornerRadius = 8
                self.stackView.layer.masksToBounds = true
                self.layer.zPosition = 999
                self.backgroundView.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, window.frame.height, 0)
            }
        }
    }

    
    public func appeare(force:Bool = false) {
        adHidden = false
        DispatchQueue.main.async {
            self.isHidden = false
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0, options: .allowAnimatedContent) {
                self.backgroundView.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, 0, 0)
            }
        }
    }


    
    var size:CGFloat {
        get {
            return adHidden ? 0 : _size
        }
        set {
            _size = newValue
        }
    }
    
    
    
    private func removeAd() {
        self.size = 0
        DispatchQueue.main.async {
            self.removeFromSuperview()
        }
    }
    

    private func addConstants(_ window:UIWindow) {
        window.addSubview(self)
        window.addConstraints([
            .init(item: self, attribute: .bottom, relatedBy: .equal, toItem: window.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0),
            .init(item: self, attribute: .centerXWithinMargins, relatedBy: .equal, toItem: window.safeAreaLayoutGuide, attribute: .centerXWithinMargins, multiplier: 1, constant: 0),
            .init(item: self, attribute: .trailing, relatedBy: .equal, toItem: window.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: 0),
            .init(item: self, attribute: .leading, relatedBy: .equal, toItem: window.safeAreaLayoutGuide, attribute: .leading, multiplier: 1, constant: 0)
        ])
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}


extension AdsBannerView {
    class func instanceFromNib() -> AdsBannerView {
        return UINib(nibName: "AdsBannerView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! AdsBannerView
    }
}


extension AdsBannerView:GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        if adHidden && adNotReceved {
            adNotReceved = false
            appeare(force: true)
        }
    }
}
