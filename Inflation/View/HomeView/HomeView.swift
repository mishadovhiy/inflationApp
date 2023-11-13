//
//  HomeView.swift
//  Inflation
//
//  Created by Misha Dovhiy on 10.11.2023.
//  Copyright © 2023 Misha Dovhiy. All rights reserved.
//

import SwiftUI

struct HomeView:View {
    @State var model:CalculatorViewModel = .init()
    @State var db:DBModelObservable = .init()
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment:.center) {
                segmentedView
                VStack {
                    if db.dataBase.selectedSegment == .inflation {
                        pickersView()
                    }
                    Spacer()
                    VStack {
                        Text("result \(model.result)")
                            .primaryStyle
                        TextField("tf value", text: $model.textFiledValue)
                            .primaryStyle
                            .onChange(of: model.textFiledValue) {
                                tfChanged(oldValue: $0, newValue: $1)
                            }
                            
                            
                    }
                    Spacer()
                    calculatorPadView(screen: geometry.size.width)
                        .frame(width: geometry.size.width)
                    
                }
            }
            .padding(.top, 5)
            .frame(alignment:.trailing)
            .background(Color.primaryBackground)
            
        }
        .onAppear(perform: {
            DispatchQueue(label: "db", qos: .userInitiated).async {
                self.db.loadDB {
                    Api().loadCPI { cpi, error in
                        if error == "" {
                            self.db.dataBase.cpi = cpi
                        }
                    }
                }
            }
        })

    }

    func cpi(_ key:LocalDataBase.PickerSelections) -> Double {
        return model.cpi(db.dataBase.selectedYear[key] ?? "", db: db.dataBase.cpi)
    }

    
    func removePressed(lastOnly:Bool = false) {
        if lastOnly {
            if model.textFiledValue.count > 0 {
                model.textFiledValue.removeLast()
                if let amount = Double(model.textFiledValue) {
                    model.calculateInflation(firstCPI: cpi(.from), secondCPI: cpi(.to))
                }
            }
        } else {
            model.textFiledValue = ""
        }
    }
    
    var segmentedView:some View {
        Button {
            withAnimation(.easeInOut) {
                self.db.dataBase.selectedSegment = self.db.dataBase.selectedSegment == .inflation ? .calculator : .inflation
                self.model.result = self.db.dataBase.selectedSegment == .inflation ? self.model.inflationResult : 0
                self.model.textFiledValue = self.db.dataBase.selectedSegment == .inflation ? self.model.inflationTextHolder : ""
            }
        } label: {
            Text("segmented view \(db.dataBase.selectedSegment.rawValue)")
                .primaryStyle
        }
        .tint(.black)

    }
    
    func pickersView() -> some View {
        return HStack {
            Picker("",selection: $db.dataBase.selectedYearFrom) {
                ForEach(db.dataBase.cpi.sorted(by: {$0.year < $1.year})) { cpi in
                    Text(cpi.year)
                        .primaryStyle
                        .tag(cpi.year)
                    
                }
            }
            .pickerStyle(.wheel)
            Picker("",selection: $db.dataBase.selectedYearTwo) {
                ForEach(db.dataBase.cpi) { cpi in
                    Text(cpi.year)
                        .primaryStyle
                        .tag(cpi.year)
                        
                }
                
            }
            .pickerStyle(.wheel)
        }
        .frame(height: 240)
        .onChange(of: db.dataBase.selectedYearTwo) { oldValue, newValue in
            model.calculateInflation(firstCPI: cpi(.from), secondCPI: cpi(.to))
        }
        .onChange(of: db.dataBase.selectedYearFrom) { oldValue, newValue in
            model.calculateInflation(firstCPI: cpi(.from), secondCPI: cpi(.to))

        }
    }
    
    func calculatorPadView(screen width:CGFloat) -> some View {
         return VStack(alignment: .leading, content: {
             if db.dataBase.selectedSegment == .calculator {
                 HStack {
                     calcButton("+", isSmall: true, pressed: {
                         numberActionPressed(.plus)
                     }, screen: width)
                     calcButton("-", isSmall: true, pressed: {
                         numberActionPressed(.minus)
                     }, screen: width)
                     calcButton("/", isSmall: true, pressed: {
                         numberActionPressed(.divide)
                     }, screen: width)
                     calcButton("*", isSmall: true, pressed: {
                         numberActionPressed(.multiply)
                     }, screen: width)
                 }
                 Spacer()
                     .frame(height: 10)
             }
             HStack(alignment: .top, content: {
                 numberPadView(screen: width)
                 VStack(spacing:db.dataBase.selectedSegment == .calculator ? 15 : 0, content: {
                     switch db.dataBase.selectedSegment {
                    case .inflation:
                        calcButton("<", pressed: {
                            removePressed(lastOnly: true)
                        }, screen: width)
                        calcButton("C", pressed: {
                            removePressed()
                        }, screen: width)
                        calcButton("</", pressed: {
                            model.showingDetail.toggle()
                        }, screen: width)
                        .sheet(isPresented: $model.showingDetail, content: {
                            ResultDetailView(result: .init(calculatedResult: 560, from: "1900", to: "2000"))
                        })
                    case .calculator:
                        Spacer()
                            .frame(height: 55)
                        calcButton("=", pressed: {
                            numberActionPressed(.result)
                        }, screen: width)
                        
                    }
 
                    
                })
            })
            
        })
    }
    
    func numberPadView(screen width:CGFloat) -> some View {
        return VStack(alignment:.leading, content: {
            ForEach(0..<3) {section in
                HStack {
                    ForEach(0..<3) { i in
                        calcButton(number:(i + 1) + (section * 3), screen: width)
                    }
                }
            }
            HStack {
                if db.dataBase.selectedSegment == .calculator {
                    calcButton(",", pressed: {
                       print("///,")
                    }, screen: width)
                }
                calcButton(number: 0, screen: width)

            }
        })
        
    }
    
    
    func calcButton(_ text:String? = nil, number:Int? = nil, isSmall:Bool = false, pressed:(()->())? = nil, screen width:CGFloat) -> some View {
        Button(action: {
            if let pressed = pressed {
                pressed()
            } else {
                numberPressed(number ?? 0)
            }
        }) {
            Text(text ?? "\(number ?? 0)")
                .primaryStyle
        }
        .tint(.white)
        .frame(width: width / 4, height: 60)
    }
    
    
    
    func numberPressed(_ number:Int) {
        model.higlightActionButtonAt = nil
        print(number)
        if model.textFiledValue == "0" {
            model.textFiledValue = ""
        }
        if model.textFiledValue.count != 9 {
            model.textFiledValue = model.textFiledValue + "\(number)"
            if let _ = Double(model.textFiledValue) {
                model.calculateInflation(firstCPI: cpi(.from), secondCPI: cpi(.to))
            }
        }
    }

    
    func tfChanged(oldValue:String, newValue:String) {
        if Double(self.model.textFiledValue) == nil {
            model.textFiledValue = oldValue
            
            
        } else {
            if db.dataBase.selectedSegment == .inflation {
                model.calculateInflation(firstCPI: cpi(.from), secondCPI: cpi(.to))
                self.model.inflationTextHolder = self.model.textFiledValue
            }
        }
    }
    
    func numberActionPressed(_ action:CalculatorViewModel.ActionButton) {
        
    }

}

#Preview {
    HomeView()
}
