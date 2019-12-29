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

class MainViewController: UIViewController {
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var showResultButton: UIButton!
    @IBOutlet weak var firstYearPickerView: UIPickerView!
    @IBOutlet weak var secondYearPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
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
        
        let maxNumber = data.cpi.keys.count - 1
        let firstYear = data.pickerData()[0]
        let lastYear = data.pickerData()[maxNumber]
        secondYearPickerView.selectRow(maxNumber, inComponent: 0, animated: true)
        data.firstYear = firstYear
        data.secondYear = lastYear
        data.firstCpi = data.cpi[firstYear]!
        data.secondCpi = data.cpi[lastYear]!
        
    }
    
    func calculateInflation() {
        
        if data.amount != "" && data.amount != "0" {
            let sum = (data.secondCpi / data.firstCpi) * Double(data.amount)!
            data.result = round(100 * Double(sum)) / 100
            resultLabel.text = "$\(data.result)"
            resultsActivation(active: true)
        }
        
    }
    
    func eraseLast() {
        
        if data.amount.count > 0 {
            data.amount.removeLast()
            amountLabel.text = "$\(data.amount)"
            calculateInflation()
        }
        if data.amount.count == 0 {
            eraseAll()
        }
        
    }
    
    func eraseAll() {
        
        data.amount = ""
        amountLabel.text = "$0"
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
            calculateInflation()
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
            data.firstYear = data.pickerData()[row]
            data.firstCpi = data.cpi[data.firstYear]!
            calculateInflation()
        }
        
        if pickerView == secondYearPickerView {
            data.secondYear = data.pickerData()[row]
            data.secondCpi = data.cpi[data.secondYear]!
            calculateInflation()
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
