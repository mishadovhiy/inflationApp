//
//  Extension_HomeView.swift
//  Inflation
//
//  Created by Misha Dovhiy on 10.11.2023.
//  Copyright © 2023 Misha Dovhiy. All rights reserved.
//

import SwiftUI

extension HomeView {
    struct CalculatorViewModel {
        var textFiledValue:String = ""
        var higlightActionButtonAt:ActionButton? = nil
        var showingDetail:Bool = false
        var result:Double = 0
        
        var calculationResultShowing:Bool = false
        var inflationResult:Double = 0
        var inflationTextHolder:String = ""
        var calculatorFirstValue:Double = 0
        var resultEnubled:Bool {
            result != 0
        }
        var appeared:Bool = false
        
        static func calculateInflation(firstCPI: Double, secondCPI: Double, enteredValue:String) -> Double {
            let amount = Double(enteredValue) ?? 0
            let sum = (secondCPI / firstCPI) * amount
            return round(100 * Double(sum)) / 100
        }
        
        mutating func calculateInflation(firstCPI: Double, secondCPI: Double) {
            
            result = HomeView.CalculatorViewModel.calculateInflation(firstCPI: firstCPI, secondCPI: secondCPI, enteredValue: textFiledValue)
            inflationResult = result
        }
        
        
        mutating func calculateResult(action:ActionButton) {
            switch action {
            case .divide:
                result = calculatorFirstValue / (Double(textFiledValue) ?? 0)
            case .minus:
                result = calculatorFirstValue - (Double(textFiledValue) ?? 0)
            case .multiply:
                result = calculatorFirstValue * (Double(textFiledValue) ?? 0)
            case .plus:
                result = calculatorFirstValue + (Double(textFiledValue) ?? 0)
            default: return
            }
            calculatorFirstValue = 0
            higlightActionButtonAt = nil
            calculationResultShowing = true
        }
        
        
        func cpi(_ key:String, db:[CPIData]) -> Double {
            return db.first(where: {$0.year == key})?.cpi ?? 0
        }
    }
}

extension HomeView.CalculatorViewModel {
    enum ActionButton {
        case minus
        case plus
        case divide
        case multiply
        case result
    }
    
}
