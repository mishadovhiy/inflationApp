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

        var inflationResult:Double = 0
        var inflationTextHolder:String = ""
        var resultEnubled:Bool {
            result != 0
        }
        mutating func calculateInflation(firstCPI: Double, secondCPI: Double) {
            let amount = Double(textFiledValue) ?? 0
            let sum = (secondCPI / firstCPI) * amount
            result = round(100 * Double(sum)) / 100
            inflationResult = result
            print(result, " resultt")
            print(firstCPI, " firstCPI")
            print(secondCPI, " secondCPI")


        }
        
        
        
        
        func cpi(_ key:String, db:[CPIData]) -> Double {
//            if db.count - 1 >= key {
//                return db[key].cpi
//            } else {
//                return 0
//            }
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
