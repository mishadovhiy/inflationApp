//
//  HomeView.swift
//  Inflation
//
//  Created by Misha Dovhiy on 10.11.2023.
//  Copyright © 2023 Misha Dovhiy. All rights reserved.
//

import SwiftUI
import Combine
struct HomeView:View {
    @State var model:CalculatorViewModel = .init()
    @State var db:DBModelObservable = .init()
    let sound:SoundModel = .init()
    
    var body: some View {
        GeometryReader { geometry in
            Color.black
                .ignoresSafeArea(.all)
            VStack(alignment:.center) {
                segmentedView
                VStack {
                    if db.dataBase.selectedSegment == .inflation {
                        pickersView()
                    }
                    Spacer()
                    VStack {
                        if db.dataBase.selectedSegment == .inflation {
                            Text("result \(model.result.string)")
                                .primaryStyle
                        }
                        Text(model.textFiledValue)
                            .primaryStyle
                    }
                    Spacer()
                    calculatorPadView(screen: geometry.size.width)
                        .frame(width: geometry.size.width)
                    HStack(alignment:.center) {
                        GADBannerViewController()
                    }
                    .frame(width: GADBannerViewController.size.width, height: GADBannerViewController.size.height)
                    
                }
            }
            .padding(.top, 5)
            .frame(alignment:.trailing)
            .background(Color.primaryBackground)
            
        }
        .background(Color.primaryBackground)
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
       // .tint(.black)

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
        
        .onReceive(Just(db.dataBase.selectedYearTwo), perform: { _ in
            model.calculateInflation(firstCPI: cpi(.from), secondCPI: cpi(.to))
        })
        
        .onReceive(Just(db.dataBase.selectedYearFrom), perform: { _ in
            model.calculateInflation(firstCPI: cpi(.from), secondCPI: cpi(.to))
        })
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
                 VStack(spacing:10, content: {
                     calcButton("<", pressed: {
                         removePressed(lastOnly: true)
                     }, screen: width)
                     calcButton("C", pressed: {
                         removePressed()
                     }, screen: width)
                     
                     switch db.dataBase.selectedSegment {
                    case .inflation:
                         if model.resultEnubled {
                             calcButton("</", pressed: {
                                 model.showingDetail.toggle()
                             }, screen: width)
                             .sheet(isPresented: $model.showingDetail, content: {
                                 ResultDetailView(result: .init(calculatedResult: model.result, from: db.dataBase.selectedYearFrom, to: db.dataBase.selectedYearTwo, cpis: db.dataBase.cpi, enteredAmount: model.textFiledValue))
                             })
                         }
                         
                    case .calculator:
                      //  Spacer()
                        //    .frame(height: 55)
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
                        self.toDecimalPressed()
                    }, screen: width)
                }
                calcButton(number: 0, screen: width)

            }
        })
        
    }
    
    func toDecimalPressed() {
        if !model.textFiledValue.contains(".") {
            model.textFiledValue += "."
        }
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
                .frame(width: width / 4, height: 60)
        }
        .frame(width: width / 4, height: 60)
    }
    
    
    
    func numberPressed(_ number:Int) {
   //     model.higlightActionButtonAt = nil
        print(number)
        if model.calculationResultShowing {
            model.textFiledValue = ""
            model.calculationResultShowing = false
        }
        if model.textFiledValue == "0" {
            model.textFiledValue = ""
        }
        if model.textFiledValue.count != 9 {
            model.textFiledValue = model.textFiledValue + "\(number)"
        }
        if db.dataBase.selectedSegment == .inflation {
            model.calculateInflation(firstCPI: cpi(.from), secondCPI: cpi(.to))
            self.model.inflationTextHolder = self.model.textFiledValue
        }
        sound.play(.key)
    }

    
  /*  func tfChanged(oldValue:String, newValue:String) {
        if Double(self.model.textFiledValue) == nil && self.model.textFiledValue != "" {
            model.textFiledValue = oldValue
        } else {
            if db.dataBase.selectedSegment == .inflation {
                model.calculateInflation(firstCPI: cpi(.from), secondCPI: cpi(.to))
                self.model.inflationTextHolder = self.model.textFiledValue
            }
        }
    }*/
    
    func numberActionPressed(_ action:CalculatorViewModel.ActionButton) {
        if action != .result {
            model.higlightActionButtonAt = action
            model.calculatorFirstValue = Double(model.textFiledValue) ?? 0
            model.textFiledValue = ""
        } else if let previousAction = model.higlightActionButtonAt {
            model.calculateResult(action: previousAction)
            model.higlightActionButtonAt = action
            model.textFiledValue = model.result.string
        }
        sound.play(.erase)
    }

    func removePressed(lastOnly:Bool = false) {
        let last = model.calculationResultShowing ? false : lastOnly
        if model.calculationResultShowing {
            model.calculationResultShowing = false
        }
        if last {
            if model.textFiledValue.count > 0 {
                model.textFiledValue.removeLast()
                model.calculateInflation(firstCPI: cpi(.from), secondCPI: cpi(.to))
            }
        } else {
            model.textFiledValue = ""
        }
        sound.play(last ? .erase : .eraseAll)
    }
}

#Preview {
    HomeView()
}
