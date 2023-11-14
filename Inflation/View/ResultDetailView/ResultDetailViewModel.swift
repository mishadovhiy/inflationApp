//
//  ResultDetailView_Extensions.swift
//  Inflation
//
//  Created by Misha Dovhiy on 10.11.2023.
//  Copyright © 2023 Misha Dovhiy. All rights reserved.
//

import SwiftUI

extension ResultDetailView {
    struct ResultDetailViewModel {
        var historyData:[ResultDetailView.HistoryData] = []
        var resultTableData:[RegularTableData] = []
        private var cpiResult:ResultDetailView.ResultData = .init()
        private var valuesAccrossYears:[Double] = []
        var cpi1:Double {
            cpiResult.cpis.first(where: {$0.year == cpiResult.from})?.cpi ?? 0
        }
        var cpi2:Double {
            cpiResult.cpis.first(where: {$0.year == cpiResult.to})?.cpi ?? 0
        }
        
        mutating func load(_ result:ResultDetailView.ResultData) {
            self.cpiResult = result
            loadHistory()
            loadGeneral(result)
        }
        
        mutating func loadGeneral(_ result:ResultDetailView.ResultData) {
            resultTableData = [
                .init(title: "Cumulative price change", description: priceChangePrecent.string),
                .init(title: "CPI in \(result.from)", description: cpi1.string),
                .init(title: "CPI in \(result.to)", description: cpi2.string),
                .init(title: "Amount", description: result.enteredAmount + "."),
                .init(title: "Converted amount", description: result.calculatedResult.string),
                .init(title: "Price difference", description: priceChange(result).string)
            ]
        }
        
        private var priceChangePrecent: Double {
            return (cpi2 - cpi1) / cpi1 * 100
        }
        
        private func priceChange(_ result:ResultDetailView.ResultData) -> Double {
            
            var priceDifference: Double
            let enteredAmount = Double(result.enteredAmount) ?? 0
            if result.calculatedResult > enteredAmount {
                priceDifference = result.calculatedResult - enteredAmount
            } else {
                priceDifference = enteredAmount - result.calculatedResult
            }
            
            return round(100 * Double(priceDifference)) / 100
            
        }
        
        private mutating func loadHistory() {
//            historyData = [
//                .init(year: "w", value: "e", progress: 0.8)
//            ]
            var resultData:[ResultDetailView.HistoryData] = []
            let dollar = Int(cpiResult.enteredAmount)!
            var year = Int(cpiResult.from)!
         //   self.historyTitleLabel.text = "Inflation history of $\(dollar) between \(Globals.firstYear) and \(Globals.secondYear)"
            
            if Int(cpiResult.to)! > Int(cpiResult.from)! {
                for _ in 0...calculationOfYears-1 {
                    year += 1
                    resultData.append(historyCalculation(year: year, dollar: dollar))
                }
            }
            if Int(cpiResult.to)! < Int(cpiResult.from)! {
                for _ in 0...calculationOfYears-1 {
                    year -= 1
                    resultData.append(historyCalculation(year: year, dollar: dollar))
                }
            }
            
            self.historyData = resultData
            
        }
        
        private mutating func historyCalculation(year: Int, dollar: Int) -> ResultDetailView.HistoryData {
            let cpi1 = cpiResult.cpis.first(where: {$0.year == "\(year)"})?.cpi ?? 0
            let sum = (cpi2 / cpi1) * Double(dollar)
            let convertedSum = round(100 * Double(sum)) / 100
        //    let new = HistoryCell(year: "\(year)", value: "\(convertedSum)", count: n)
            valuesAccrossYears.append(convertedSum)
            return .init(year: "\(year)", value: "\(convertedSum)", progress: 0)
            
        }
        
        var calculationOfYears: Int {
            
            var sum: Int
            if Int(cpiResult.to)! > Int(cpiResult.from)! {
                sum = Int(cpiResult.to)! - Int(cpiResult.from)!
            } else {
                sum = Int(cpiResult.from)! - Int(cpiResult.to)!
            }
            return sum
        }
        
        func progressBarSetup(n: String) -> Float {
            
            let biggest = Float(valuesAccrossYears.max() ?? 0.0)
            let nFloat = Float(n) ?? 0.0
            let sum = ((100 * nFloat) / biggest) / 100
            return sum
        }
    }
    
    

}

extension ResultDetailView {
    struct ResultData {
        let calculatedResult:Double
        let from:String
        let to:String
        var cpis:[CPIData]
        let enteredAmount:String
        
        init(calculatedResult: Double, from: String, to: String, cpis: [CPIData], enteredAmount: String) {
            self.calculatedResult = calculatedResult
            self.from = from
            self.to = to
            self.cpis = cpis
            self.enteredAmount = enteredAmount
        }
        init() {
            self = .init(calculatedResult: 0, from: "", to: "", cpis: [], enteredAmount: "")
        }
        
        public static func with(
          _ populator: (inout Self) throws -> ()
        ) rethrows -> Self {
          var message = Self()
          try populator(&message)
          return message
        }
    }
    
    struct HistoryData:Identifiable {
        var id:UUID = .init()
        let year:String
        let value:String
        let progress:CGFloat
    }
    

    

}
