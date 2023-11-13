//
//  ResultViewController.swift
//  Inflation
//
//  Created by Misha Dovhiy on 27.11.2019.
//  Copyright © 2019 Misha Dovhiy. All rights reserved.
//

import UIKit

class ResultViewController: SuperVC {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var percentDifferenceLabel: UILabel!
    @IBOutlet weak var cpi1Label: UILabel!
    @IBOutlet weak var cpi1AmountLabel: UILabel!
    @IBOutlet weak var cpi2Label: UILabel!
    @IBOutlet weak var cpi2AmountLabel: UILabel!
    @IBOutlet weak var dollar1Label: UILabel!
    @IBOutlet weak var dollar2Label: UILabel!
    @IBOutlet weak var differenceLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var formCPI1Label: UILabel!
    @IBOutlet weak var formCPI2Label: UILabel!
    @IBOutlet weak var formAmountLabel: UILabel!
    @IBOutlet weak var formResultLabel: UILabel!
    @IBOutlet weak var historyTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var pricesLowOrHigh = "higher"
    var percantDifference = (Globals.secondCpi - Globals.firstCpi) / Globals.firstCpi * 100
    var historyResults = [HistoryCell]()
    var valuesAccrossYears = [0.0]
    var n = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        loadResults()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIView.animate(withDuration: 0.6) {
            self.closeButton.alpha = 0.6
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.closeButton.alpha = 1
    }
    
    func loadResults() {
        self.subtitleLabel.text = "$\(Globals.amount) in \(Globals.firstYear) → $\(Globals.result) in \(Globals.secondYear)"
        calculationPriceChange()
        tableInfo()
        textInfo()
        howToCalculate()
        inflationHistory()
        
    }
    
    func tableInfo() {
        
        self.percentDifferenceLabel.text = "\(self.percantDifference)%"
        self.cpi1Label.text = "CPI in \(Globals.firstYear)"
        self.cpi1AmountLabel.text = "\(Globals.firstCpi)"
        self.cpi2AmountLabel.text = "\(Globals.secondCpi)"
        self.cpi2Label.text = "CPI in \(Globals.secondYear)"
        self.dollar1Label.text = "$\(Globals.amount)"
        self.dollar2Label.text = "$\(Globals.result)"
        self.differenceLabel.text = "$\(self.calculationPriceDifference())"
        
    }
    
    func textInfo() {
        
        self.textLabel.text = """
            $\(Globals.amount) in \(Globals.firstYear) is equivalent in purchasing power to about $\(Globals.result) in \(Globals.secondYear), a difference of $\(self.calculationPriceDifference()) over \(self.calculationOfYears()) years. 
            """
        
    }
    
    func howToCalculate() {
        
        self.formCPI1Label.text = "\(Globals.firstCpi) (\(Globals.firstYear) CPI)"
        self.formCPI2Label.text = "\(Globals.secondCpi) (\(Globals.secondYear) CPI)"
        self.formAmountLabel.text = "$\(Globals.amount)"
        self.formResultLabel.text = "$\(Globals.result)"
        
    }
    
    func inflationHistory() {
        
        let cdi1 = Globals.firstCpi
        let dollar = Int(Globals.amount)!
        var year = Int(Globals.firstYear)!
        self.historyTitleLabel.text = "Inflation history of $\(dollar) between \(Globals.firstYear) and \(Globals.secondYear)"
        
        if Int(Globals.secondYear)! > Int(Globals.firstYear)! {
            for _ in 0...calculationOfYears()-1 {
                year += 1
                historyCalculation(year: year, cdi1: cdi1, dollar: dollar)
            }
        }
        if Int(Globals.secondYear)! < Int(Globals.firstYear)! {
            for _ in 0...calculationOfYears()-1 {
                year -= 1
                historyCalculation(year: year, cdi1: cdi1, dollar: dollar)
            }
        }
    }
    
    func historyCalculation(year: Int, cdi1: Double, dollar: Int) {
        
        let cdi2 = Globals.cpi["\(year)"]!
        let sum = (cdi2 / cdi1) * Double(dollar)
        let convertedSum = round(100 * Double(sum)) / 100
        let new = HistoryCell(year: "\(year)", value: "\(convertedSum)", count: n)
        valuesAccrossYears.append(convertedSum)
        n += 1
        historyResults.append(new)
        
    }
    
    func calculationPriceChange() {
        
        if Int(Globals.result) < Int(Globals.amount)! {
            pricesLowOrHigh = "lower"
            percantDifference = (Globals.firstCpi - Globals.secondCpi) / Globals.secondCpi * 100
        }
        percantDifference = round(100 * Double(percantDifference)) / 100
        
    }
    
    func calculationOfYears() -> Int {
        
        var sum: Int
        if Int(Globals.secondYear)! > Int(Globals.firstYear)! {
            sum = Int(Globals.secondYear)! - Int(Globals.firstYear)!
        } else {
            sum = Int(Globals.firstYear)! - Int(Globals.secondYear)!
        }
        return sum
    }
    
    func calculationPriceDifference() -> Double {
        
        var priceDifference: Double
        if Globals.result > Double(Globals.amount)! {
            priceDifference = Double(Globals.result) - (Double(Globals.amount) ?? 1)
        } else {
            priceDifference = (Double(Globals.amount) ?? 1) -  Double(Globals.result)
        }
        
        return round(100 * Double(priceDifference)) / 100
        
    }
    
    func progressBarSetup(n: String) -> Float {
        
        let biggest = Float(valuesAccrossYears.max() ?? 0.0)
        let nFloat = Float(n) ?? 0.0
        let sum = ((100 * nFloat) / biggest) / 100
        return sum
    }
    
    @IBAction func closeResults(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    struct HistoryCell {
        let year: String
        let value: String
        let count: Int
    }
}

