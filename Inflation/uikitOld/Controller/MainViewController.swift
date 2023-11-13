//
//  ViewController.swift
//  Inflation
//
//  Created by Misha Dovhiy on 27.11.2019.
//  Copyright © 2019 Misha Dovhiy. All rights reserved.
//

import UIKit
import AVFoundation


class MainViewController: SuperVC {
    
    @IBOutlet weak var segmentHolderView: UIView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var showResultButton: UIButton!
    @IBOutlet weak var firstYearPickerView: UIPickerView!
    @IBOutlet weak var secondYearPickerView: UIPickerView!
    var segment:SegmentView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        segment = .init(titles: [.init(name: "inflation", hideGradient: true, shadowColow: .red, tintColor: .green, selectedTextColor: .black), .init(name: "regular", hideGradient: true, shadowColow: .brown, tintColor: .orange, selectedTextColor: .white, deselectedColor: .black)], size: segmentHolderView.frame.size, background: .blue, selected: segmentedChanged(_:))
        segmentHolderView.addSubview(segment!)
        segment?.addConstaits([.left:0, .right:0, .top:0, .bottom:0], superV: segmentHolderView)
    }
    
    func segmentedChanged(_ newValue:Int) {
        print(newValue, " yrhtegrfsec")
        UIView.animate(withDuration: 0.3, delay: 0, options: .allowUserInteraction, animations: {
            self.firstYearPickerView.superview?.isHidden = newValue == 1
            self.resultLabel.superview?.isHidden = newValue == 1
            
        })
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    
    func updateUI() {
        firstYearPickerView.dataSource = self
        firstYearPickerView.delegate = self
        secondYearPickerView.dataSource = self
        secondYearPickerView.delegate = self
        showResultButton.isEnabled = false
        resultsActivation(active: false)
        defaultYears()
        let view = [firstYearPickerView, secondYearPickerView]
        view.forEach({
            $0?.layer.cornerRadius = 9
            $0?.layer.borderColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 1).cgColor
            $0?.layer.borderWidth = 1
        })
        let tfViews = [resultLabel.superview, amountLabel.superview]
        tfViews.forEach({
            $0?.layer.cornerRadius = 9
            $0?.layer.borderColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 1).cgColor
            $0?.layer.borderWidth = 1
        })
    }
    
    func defaultYears() {
        print("Globals.cpi:", Globals.cpi.count)
        let maxNumber = Globals.cpi.keys.count - 1
        if maxNumber > 1 {
            let lastYearSelected = UserDefaults.standard.value(forKey: "lastYear") as? Int
            let firstYear = Globals.pickerData()[lastYearSelected ?? 0]
            let lastYear = Globals.pickerData()[maxNumber]
            firstYearPickerView.selectRow(lastYearSelected ?? 0/*64*/, inComponent: 0, animated: true)
            secondYearPickerView.selectRow(maxNumber, inComponent: 0, animated: true)
            Globals.firstYear = firstYear
            Globals.secondYear = lastYear
            Globals.firstCpi = Globals.cpi[firstYear]!
            Globals.secondCpi = Globals.cpi[lastYear]!
        }

    }
    
    func calculateInflation(amount: Double, firstCPI: Double, secondCPI: Double) {
        let sum = (secondCPI / firstCPI) * amount
            
        Globals.result = round(100 * Double(sum)) / 100
        resultsActivation(active: true)
        DispatchQueue.main.async {
            self.resultLabel.text = "$\(Globals.result)"
        }
    }
    
    func eraseLast() {
        if Globals.amount.count > 0 {
            Globals.amount.removeLast()
            DispatchQueue.main.async {
                self.amountLabel.text = "$\(Globals.amount)"
            }
            if let dataAmountt = Double(Globals.amount) {
                calculateInflation(amount: dataAmountt, firstCPI: Globals.firstCpi, secondCPI: Globals.secondCpi)
            } else {
                eraseAll()
            }

        }
        
    }
    
    func eraseAll() {
        Globals.amount = ""
        DispatchQueue.main.async {
            self.amountLabel.text = "$0"
        }
        resultsActivation(active: false)
        
    }
    
    func resultsActivation(active: Bool) {
        if active {
            showResultButton.isEnabled = true
            resultLabel.alpha = 1
        } else {
            showResultButton.isEnabled = false
            resultLabel.alpha = 0.3
            Globals.result = 0.00
            resultLabel.text = "$\(Globals.result)"
        }
    }
    
    func keySounds(soundID: SystemSoundID) {
        if Globals.amount != "" && Globals.amount != "0" {
            AudioServicesPlaySystemSound (soundID)
        } else {
            UIImpactFeedbackGenerator().impactOccurred()
        }
        
    }
    
    @IBAction func numberPressed(_ sender: UIButton) {
        if Globals.amount == "0" {
            Globals.amount = ""
        }
        if Globals.amount.count != 9 {
            Globals.amount = Globals.amount + sender.currentTitle!
            if let dataAmountt = Double(Globals.amount) {
                calculateInflation(amount: dataAmountt, firstCPI: Globals.firstCpi, secondCPI: Globals.secondCpi)
            }
            keySounds(soundID: 1104)
        } else {
            UIImpactFeedbackGenerator().impactOccurred()
        }
        amountLabel.text = "$\(Globals.amount)"

    }
    
    @IBAction func eraseNumers(_ sender: UIButton) {
        if sender.tag == 11 {
            keySounds(soundID: 1155)
            eraseLast()
        }
        if sender.tag == 12 {
            keySounds(soundID: 1156)
            eraseAll()
        }
        
    }
    
}

extension MainViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Globals.pickerData().count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == firstYearPickerView {
            UserDefaults.standard.setValue(row, forKey: "lastYear")
            Globals.firstYear = Globals.pickerData()[row]
            Globals.firstCpi = Globals.cpi[Globals.firstYear]!
            if let dataAmountt = Double(Globals.amount) {
                if let fYear = Globals.cpi[Globals.firstYear] {
                    calculateInflation(amount: dataAmountt, firstCPI: fYear, secondCPI: Globals.secondCpi)
                }
            }
        }
        
        if pickerView == secondYearPickerView {
            Globals.secondYear = Globals.pickerData()[row]
            Globals.secondCpi = Globals.cpi[Globals.secondYear]!
            if let dataAmountt = Double(Globals.amount) {
                if let secondY = Globals.cpi[Globals.secondYear] {
                    calculateInflation(amount: dataAmountt, firstCPI: Globals.firstCpi, secondCPI: secondY)
                }
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Globals.pickerData()[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let titleData = Globals.pickerData()[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.foregroundColor:UIColor.white])
        return myTitle
    }
    
}
