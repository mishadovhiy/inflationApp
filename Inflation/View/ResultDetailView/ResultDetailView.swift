//
//  ResultDetailView.swift
//  Inflation
//
//  Created by Misha Dovhiy on 10.11.2023.
//  Copyright © 2023 Misha Dovhiy. All rights reserved.
//

import SwiftUI

struct ResultDetailView: View {
    var result:ResultData
    @State var model:ResultDetailViewModel = .init()
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack(alignment:.leading) {
                    Spacer()
                        .frame(height: 10)
                    Text("Result")
                        .primaryStyle
                        .frame(width: geo.size.width - 20, alignment: .center)
                    
                    ForEach(model.resultTableData) {
                        resultTableCell($0, screen: geo.size.width)
                    }
                    Spacer()
                        .frame(height: 30)
                    VStack(alignment:.leading) {
                        Text("How to Calculate Inflation")
                            .primaryStyle
                        Text("To get the total inflation rate we use the following formula:")
                            .primaryStyle
                    }
                    Spacer()
                        .frame(height: 30)
                    Text("History title")
                        .primaryStyle
                    ForEach(model.historyData) {
                        historyCell($0)
                    }
                }
                .frame(width:geo.size.width - 20, alignment: .leading)
                .padding(.leading, 10)
                .padding(.trailing, 10)
            }
            .background(Color.primaryBackground)
        }
        .onAppear(perform: {
            model.load(result)
        })
    }
    
    
    func resultTableCell(_ data:RegularTableData, screen width:CGFloat) -> some View {
        return HStack() {
            Text(data.title)
                .primaryStyle
            Spacer()
            Text(data.description)
                .primaryStyle
        }
        .frame(width: width, height: 35, alignment: .leading)
    }
    
    func historyCell(_ data:HistoryData) -> some View {
        return VStack {
            HStack {
                Text(data.year)
                    .primaryStyle
                Spacer()
                Text(data.value)
                    .primaryStyle
            }
            ProgressView(value: data.progress)
        }
    }
    
}

#Preview {
    ResultDetailView(result: .init(calculatedResult: 123, from: "1850", to: "2023"))
}

