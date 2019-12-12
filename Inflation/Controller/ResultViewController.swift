//
//  ResultViewController.swift
//  Inflation
//
//  Created by Misha Dovhiy on 27.11.2019.
//  Copyright © 2019 Misha Dovhiy. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var percentDifferenceLabel: UILabel!
    @IBOutlet weak var cpi1Label: UILabel!
    @IBOutlet weak var cpi1AmountLabel: UILabel!
    @IBOutlet weak var cpi2Label: UILabel!
    @IBOutlet weak var cpi2AmountLabel: UILabel!
    @IBOutlet weak var year1Label: UILabel!
    @IBOutlet weak var year2Label: UILabel!
    @IBOutlet weak var dollar1Label: UILabel!
    @IBOutlet weak var dollar2Label: UILabel!
    @IBOutlet weak var differenceLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var formCPI1Label: UILabel!
    @IBOutlet weak var formCPI2Label: UILabel!
    @IBOutlet weak var formAmountLabel: UILabel!
    @IBOutlet weak var formResultLabel: UILabel!
    @IBOutlet weak var historyTitleLabel: UILabel!
    @IBOutlet weak var historyTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadResults()
        
    }
    
    var pricesLowOrHigh = "higher"
    
    var percantDifference = (data.secondCpi - data.firstCpi) / data.firstCpi * 100
    
    func loadResults() {
        
        subtitleLabel.text = "$\(data.amount) in \(data.firstYear) → $\(data.result) in \(data.secondYear)"
        calculationPriceChange()
        tableInfo()
        textInfo()
        howToCalculate()
        inflationHistory()
        
    }
    
    func tableInfo() {
        
        percentDifferenceLabel.text = "\(percantDifference)%"
        cpi1Label.text = "CPI in \(data.firstYear)"
        cpi1AmountLabel.text = "\(data.firstCpi)"
        cpi2AmountLabel.text = "\(data.secondCpi)"
        cpi2Label.text = "CPI in \(data.secondYear)"
        year1Label.text = data.firstYear
        year2Label.text = data.secondYear
        dollar1Label.text = "$\(data.amount)"
        dollar2Label.text = "$\(data.result)"
        differenceLabel.text = "$\(calculationPriceDifference())"
        
    }
    
    func textInfo() {
        
        textLabel.text = """
        To calculate inflation we use the consumer price index (CPI), which measures the average change in prices over time using a market basket of goods and services, to see how far your dollar goes today, compared with previous years.
        
        According to the Bureau of Labor Statistics consumer price index, prices in \(data.secondYear) are \(percantDifference)% \(pricesLowOrHigh) than average prices throughout \(data.firstYear).
        
        In other words, $\(data.amount) in \(data.firstYear) is equivalent in purchasing power to about $\(data.result) in \(data.secondYear), a difference of $\(calculationPriceDifference()) over \(calculationOfYears()) years. 
        """
        
    }
    
    func howToCalculate() {
        
        formCPI1Label.text = "\(data.firstCpi) (\(data.firstYear) CPI)"
        formCPI2Label.text = "\(data.secondCpi) (\(data.secondYear) CPI)"
        formAmountLabel.text = "$\(data.amount)"
        formResultLabel.text = "$\(data.result)"
        
    }
    
    func inflationHistory() {
        
        var n = 1
        let cdi1 = data.firstCpi
        let dollar = Int(data.amount)!

        var year = Int(data.firstYear)!
        var cdi2: Double = data.cpi["\(year)"]!
        
        var sum = (cdi2 / cdi1) * Double(dollar)
        var text = "\(n). Buying power in \(year) is $\(Int(sum))"
        var textArray: [String] = ["\(text)"]
        
        if Int(data.secondYear)! > Int(data.firstYear)! {
            for _ in 0...calculationOfYears()-1 {
                year += 1
                n += 1
                cdi2 = data.cpi["\(year)"]!
                sum = (cdi2 / cdi1) * Double(dollar)
                text = "\(n). Buying power in \(year) is $\(round(100 * Double(sum)) / 100)"
                textArray.append(text)
            }
        }
        if Int(data.secondYear)! < Int(data.firstYear)! {
            for _ in 0...calculationOfYears()-1 {
                year -= 1
                n += 1
                cdi2 = data.cpi["\(year)"]!
                sum = (cdi2 / cdi1) * Double(dollar)
                text = "\(n). Buying power in \(year) is $\(round(100 * Double(sum)) / 100)"
                textArray.append(text)
            }
        }
        
        let result = textArray.joined(separator: "\n")
        historyTextView.text = result
        historyTitleLabel.text = "Inflation history of $\(dollar) between \(data.firstYear) and \(data.secondYear)"
        
    }
    
    func calculationPriceChange() {
        
        if Int(data.result) < Int(data.amount)! {
            pricesLowOrHigh = "lower"
            percantDifference = (data.firstCpi - data.secondCpi) / data.secondCpi * 100
        }
        percantDifference = round(100 * Double(percantDifference)) / 100
        
    }
    
    func calculationOfYears() -> Int {
        
        var sum: Int
        if Int(data.secondYear)! > Int(data.firstYear)! {
            sum = Int(data.secondYear)! - Int(data.firstYear)!
        } else {
            sum = Int(data.firstYear)! - Int(data.secondYear)!
        }
        return sum
    }
    
    func calculationPriceDifference() -> Double {
        
        var priceDifference: Double
        if data.result > Double(data.amount)! {
            priceDifference = Double(data.result) - (Double(data.amount) ?? 1)
        } else {
            priceDifference = (Double(data.amount) ?? 1) -  Double(data.result)
        }

        return round(100 * Double(priceDifference)) / 100
        
    }
    
    @IBAction func closeResults(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
