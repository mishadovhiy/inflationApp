//
//  ResultViewController.swift
//  Inflation
//
//  Created by Misha Dovhiy on 27.11.2019.
//  Copyright © 2019 Misha Dovhiy. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
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
    var percantDifference = (data.secondCpi - data.firstCpi) / data.firstCpi * 100
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
        DispatchQueue.main.async {
            self.subtitleLabel.text = "$\(data.amount) in \(data.firstYear) → $\(data.result) in \(data.secondYear)"
        }
        calculationPriceChange()
        tableInfo()
        textInfo()
        howToCalculate()
        inflationHistory()
        
    }
    
    func tableInfo() {
        
        DispatchQueue.main.async {
            self.percentDifferenceLabel.text = "\(self.percantDifference)%"
            self.cpi1Label.text = "CPI in \(data.firstYear)"
            self.cpi1AmountLabel.text = "\(data.firstCpi)"
            self.cpi2AmountLabel.text = "\(data.secondCpi)"
            self.cpi2Label.text = "CPI in \(data.secondYear)"
            self.dollar1Label.text = "$\(data.amount)"
            self.dollar2Label.text = "$\(data.result)"
            self.differenceLabel.text = "$\(self.calculationPriceDifference())"
        }
        
    }
    
    func textInfo() {
        
        DispatchQueue.main.async {
            self.textLabel.text = """
            To calculate inflation we use the consumer price index (CPI), which measures the average change in prices over time using a market basket of goods and services, to see how far your dollar goes today, compared with previous years.
            
            According to the Bureau of Labor Statistics consumer price index, prices in \(data.secondYear) are \(self.percantDifference)% \(self.pricesLowOrHigh) than average prices throughout \(data.firstYear).
            
            In other words, $\(data.amount) in \(data.firstYear) is equivalent in purchasing power to about $\(data.result) in \(data.secondYear), a difference of $\(self.calculationPriceDifference()) over \(self.calculationOfYears()) years. 
            """
        }
        
    }
    
    func howToCalculate() {
        
        DispatchQueue.main.async {
            self.formCPI1Label.text = "\(data.firstCpi) (\(data.firstYear) CPI)"
            self.formCPI2Label.text = "\(data.secondCpi) (\(data.secondYear) CPI)"
            self.formAmountLabel.text = "$\(data.amount)"
            self.formResultLabel.text = "$\(data.result)"
        }
        
    }
    
    func inflationHistory() {
        
        let cdi1 = data.firstCpi
        let dollar = Int(data.amount)!
        var year = Int(data.firstYear)!
        DispatchQueue.main.async {
            self.historyTitleLabel.text = "Inflation history of $\(dollar) between \(data.firstYear) and \(data.secondYear)"
        }
        
        if Int(data.secondYear)! > Int(data.firstYear)! {
            for _ in 0...calculationOfYears()-1 {
                year += 1
                historyCalculation(year: year, cdi1: cdi1, dollar: dollar)
            }
        }
        if Int(data.secondYear)! < Int(data.firstYear)! {
            for _ in 0...calculationOfYears()-1 {
                year -= 1
                historyCalculation(year: year, cdi1: cdi1, dollar: dollar)
            }
        }
    }
    
    func historyCalculation(year: Int, cdi1: Double, dollar: Int) {
        
        let cdi2 = data.cpi["\(year)"]!
        let sum = (cdi2 / cdi1) * Double(dollar)
        let convertedSum = round(100 * Double(sum)) / 100
        let new = HistoryCell(year: "\(year)", value: "\(convertedSum)", count: n)
        valuesAccrossYears.append(convertedSum)
        n += 1
        historyResults.append(new)
        
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
    
    func progressBarSetup(n: String) -> Float {
        
        let biggest = Float(valuesAccrossYears.max() ?? 0.0)
        let nFloat = Float(n) ?? 0.0
        let sum = ((100 * nFloat) / biggest) / 100
        return sum
    }
    
    @IBAction func closeResults(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
}

extension ResultViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return historyResults.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = historyResults[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! TableViewCell
        
        cell.cellValue.text = "$\(row.value)"
        cell.cellYear.text = row.year
        //cell.countLabel.text = "\(row.count)."
        cell.progressBar.progress = progressBarSetup(n: row.value)
        
        return cell
        
    }
    
}
