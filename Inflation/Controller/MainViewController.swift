//
//  ViewController.swift
//  Inflation
//
//  Created by Misha Dovhiy on 27.11.2019.
//  Copyright © 2019 Misha Dovhiy. All rights reserved.
//

import UIKit
import AVFoundation

var data = Data()

class MainViewController: SuperVC {
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var showResultButton: UIButton!
    @IBOutlet weak var firstYearPickerView: UIPickerView!
    @IBOutlet weak var secondYearPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("MainViewController")
        
        updateUI()
        
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
        
    }
    
    func defaultYears() {
        print("data.cpi:", data.cpi.count)
        let maxNumber = data.cpi.keys.count - 1
        if maxNumber > 1 {
            let lastYearSelected = UserDefaults.standard.value(forKey: "lastYear") as? Int
            let firstYear = data.pickerData()[lastYearSelected ?? 0]
            let lastYear = data.pickerData()[maxNumber]
            firstYearPickerView.selectRow(lastYearSelected ?? 0/*64*/, inComponent: 0, animated: true)
            secondYearPickerView.selectRow(maxNumber, inComponent: 0, animated: true)
            data.firstYear = firstYear
            data.secondYear = lastYear
            data.firstCpi = data.cpi[firstYear]!
            data.secondCpi = data.cpi[lastYear]!
        }

    }
    
    func calculateInflation(amount: Double, firstCPI: Double, secondCPI: Double) {
      //  if data.amount != "" && data.amount != "0" {
        let sum = (secondCPI / firstCPI) * amount
            
        data.result = round(100 * Double(sum)) / 100
        resultsActivation(active: true)
        DispatchQueue.main.async {
            self.resultLabel.text = "$\(data.result)"
        }
            
            
      /*  } else {
            print("calculateInflation: error")
        }*/
        
    }
    
    func eraseLast() {
        if data.amount.count > 0 {
            data.amount.removeLast()
            DispatchQueue.main.async {
                self.amountLabel.text = "$\(data.amount)"
            }
            if let dataAmountt = Double(data.amount) {
                calculateInflation(amount: dataAmountt, firstCPI: data.firstCpi, secondCPI: data.secondCpi)
            } else {
                eraseAll()
            }

        }
        
    }
    
    func eraseAll() {
        data.amount = ""
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
            data.result = 0.00
            resultLabel.text = "$\(data.result)"
        }
    }
    
    func keySounds(soundID: SystemSoundID) {
        if data.amount != "" && data.amount != "0" {
            AudioServicesPlaySystemSound (soundID)
        } else {
            UIImpactFeedbackGenerator().impactOccurred()
        }
        
    }
    
    @IBAction func numberPressed(_ sender: UIButton) {
        if data.amount == "0" {
            data.amount = ""
        }
        if data.amount.count != 9 {
            data.amount = data.amount + sender.currentTitle!
            if let dataAmountt = Double(data.amount) {
                calculateInflation(amount: dataAmountt, firstCPI: data.firstCpi, secondCPI: data.secondCpi)
            }
            keySounds(soundID: 1104)
        } else {
            UIImpactFeedbackGenerator().impactOccurred()
        }
        amountLabel.text = "$\(data.amount)"

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
        return data.pickerData().count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == firstYearPickerView {
            UserDefaults.standard.setValue(row, forKey: "lastYear")
            data.firstYear = data.pickerData()[row]
            data.firstCpi = data.cpi[data.firstYear]!
            if let dataAmountt = Double(data.amount) {
                if let fYear = data.cpi[data.firstYear] {
                    calculateInflation(amount: dataAmountt, firstCPI: fYear, secondCPI: data.secondCpi)
                }
            }
        }
        
        if pickerView == secondYearPickerView {
            data.secondYear = data.pickerData()[row]
            data.secondCpi = data.cpi[data.secondYear]!
            if let dataAmountt = Double(data.amount) {
                if let secondY = data.cpi[data.secondYear] {
                    calculateInflation(amount: dataAmountt, firstCPI: data.firstCpi, secondCPI: secondY)
                }
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data.pickerData()[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let titleData = data.pickerData()[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.foregroundColor:UIColor.white])
        return myTitle
    }
    
}
