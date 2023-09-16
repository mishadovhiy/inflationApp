//
//  loadingViewController.swift
//  Inflation
//
//  Created by Mikhailo Dovhyi on 04.02.2021.
//  Copyright © 2021 Misha Dovhiy. All rights reserved.
//

import UIKit

class loadingViewController: SuperVC {

    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var reloadButton: UIButton!
    var logoFrame = CGRect.zero
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.alpha = 0
        reloadButton.alpha = 0
        DispatchQueue.main.async {
            self.logoFrame = self.logoImage.frame
        }
        AppDelegate.shared?.api.loadCPI { (loadedData, error) in
            if error != "" {
                self.errorLoading(error: error)
                
            } else {
                if loadedData.count > 0 {
                    data.cpi = loadedData
                    UserDefaults.standard.setValue(loadedData, forKey: "CPIData")
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "loaded", sender: self)
                    }
                } else {
                    self.errorLoading()
                }
                
            }
        }
    }
    
    
    func errorLoading(error: String = "Error loading data") {
        if let cpi = UserDefaults.standard.value(forKey: "CPIData") as? [String:Double] {
            data.cpi = cpi
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "loaded", sender: self)
            }
        } else {
            DispatchQueue.main.async {
                self.logoImage.frame = self.logoFrame
                self.logoImage.translatesAutoresizingMaskIntoConstraints = true
                self.mainTitleLabel.alpha = 0
                self.errorLabel.alpha = 0
                self.reloadButton.alpha = 0
                UIView.animate(withDuration: 0.2) {
                    self.view.backgroundColor = .red
                } completion: { (_) in
                    UIView.animate(withDuration: 0.43) {
                        self.logoImage.frame = CGRect(x: self.logoFrame.minX, y: self.logoFrame.minY - 80, width: self.logoFrame.width, height: self.logoFrame.height)
                    } completion: { (_) in
                        self.mainTitleLabel.text = error
                        self.mainTitleLabel.font = UIFont.systemFont(ofSize: 27, weight: .medium)
                        self.mainTitleLabel.textColor = .red
                        UIView.animate(withDuration: 0.2) {
                            self.view.backgroundColor = UIColor.white
                            self.errorLabel.alpha = 1
                            self.mainTitleLabel.alpha = 1
                            self.reloadButton.alpha = 1
                        }
                    }
                }
            }
        }
    }

    @IBAction func reloadPressed(_ sender: UIButton) {
        AppDelegate.shared?.api.loadCPI { (loadedData, error) in
            if error != "" {
                self.errorLoading(error: error)
            } else {
                if loadedData.count > 0 {
                    data.cpi = loadedData
                    UserDefaults.standard.setValue(loadedData, forKey: "CPIData")
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "loaded", sender: self)
                    }
                } else {
                    self.errorLoading()
                }
            }
        }
    }
}
