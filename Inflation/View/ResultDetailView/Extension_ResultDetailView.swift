//
//  ResultDetailView_Extensions.swift
//  Inflation
//
//  Created by Misha Dovhiy on 10.11.2023.
//  Copyright © 2023 Misha Dovhiy. All rights reserved.
//

import SwiftUI

extension ResultDetailView {
    struct ResultData {
        let calculatedResult:Double
        let from:String
        let to:String
    }
    
    struct HistoryData:Identifiable {
        var id:UUID = .init()
        let year:String
        let value:String
        let progress:CGFloat
    }
    
    struct ResultDetailViewModel {
        var historyData:[ResultDetailView.HistoryData] = []
        var resultTableData:[RegularTableData] = []
        
        mutating func load(_ result:ResultDetailView.ResultData) {
            historyData = [
                .init(year: "w", value: "e", progress: 0.8)
            ]
        }
        
        mutating func loadGeneral(_ result:ResultDetailView.ResultData) {
            resultTableData = [
                .init(title: "Cumulative price change", description: "d"),
                .init(title: "CPI in ..."),
                .init(title: "CPI in .."),
                .init(title: "Amount", description: "\(result.calculatedResult)"),
                .init(title: "Converted amount"),
                .init(title: "Price difference")
            ]
        }
    }

}
