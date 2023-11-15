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

    @State private var key = ""

    var body: some View {
        GeometryReader { geometry in
            Color.black
                .ignoresSafeArea(.all)
                .frame(height: 0)
            if isSmallDevice(geometry.size) {
                HStack(spacing:0) {
                    topView(geometry.size, smallDevice: true)
                    bottomView(geometry.size, smallDevice: true)
                }
                
            } else {
                VStack(alignment:.center) {
                    topView(geometry.size, smallDevice: false)
                    bottomView(geometry.size, smallDevice: false)
                }
                .padding(.top, 5)
                .frame(alignment:.trailing)
                .background(Color.primaryBackground)
            }
        }
        .onAppear(perform: {
            DispatchQueue(label: "db", qos: .userInitiated).async {
                self.db.loadDB {
                    Api().loadCPI { cpi, error in
                        print("rwsw ", cpi.first?.year)
                        print("sdf ", cpi.last?.year)

                        if error == "" {
                            self.db.dataBase.cpi = cpi
                        }
                    }
                }
            }
        })
        .sheet(isPresented: $model.showingDetail, content: {
            ResultDetailView(result: .init(calculatedResult: model.result, from: db.dataBase.selectedYearFrom, to: db.dataBase.selectedYearTwo, cpis: db.dataBase.cpi, enteredAmount: model.textFiledValue))
        })
        
    }
    
    private func topView(_ screenWidth:CGSize, smallDevice:Bool) -> some View {
        VStack {
            segmentedView
            if db.dataBase.selectedSegment == .inflation {
                pickersView(smallDevice: smallDevice, screenWidth: screenWidth.width)
            }
            Spacer()
           
            VStack(alignment:.leading) {
                if db.dataBase.selectedSegment == .inflation {
                    Text(model.result.string)
                        .secondaryStyle
                }
                Text(model.textFiledValue)
                    .style(.init(style: .primary, font:.system(size: 25)))
            }
            .frame(width:smallDevice ? (screenWidth.width / 2) : screenWidth.width, alignment: .leading)
            .background(Color.primaryBackground)
            .padding(.leading,10)
            .gesture( DragGesture()
                .onEnded({ value in
                    if value.predictedEndTranslation.width < 100 {
                        removePressed(lastOnly: true)
                    }
                })
            )
            Spacer()
        }

    }
    
    
    private func bottomView(_ screenWidth:CGSize, smallDevice:Bool) -> some View {
        return VStack {
            calculatorPadView(screen: screenWidth.width, smallDevice: smallDevice)
                .frame(width: smallDevice ? (screenWidth.width / 2) : screenWidth.width)
            HStack(alignment:.center) {
                GADBannerViewController()
            }
            .frame(width: GADBannerViewController.size.width, height: GADBannerViewController.size.height)
        }
    }
    
    
    var segmentedView:some View {
        SegmentView(values: ["Inflation", "Calculator"], didSelect: {
            self.segmentedChanged($0)
        }, selectedAt: db.dataBase.selectedSegment.rawValue)
        .frame(height: 40)
        .padding(.leading, 20)
        .padding(.trailing, 20)
        
    }
    
    func pickersView(smallDevice:Bool, screenWidth:CGFloat) -> some View {
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
        .frame(width:smallDevice ? screenWidth / 2 : screenWidth, height: smallDevice ? 150 : 240)
        .onReceive(Just(db.dataBase.selectedYearTwo), perform: { _ in
            model.calculateInflation(firstCPI: cpi(.from), secondCPI: cpi(.to))
        })
        
        .onReceive(Just(db.dataBase.selectedYearFrom), perform: { _ in
            model.calculateInflation(firstCPI: cpi(.from), secondCPI: cpi(.to))
        })
    }
    
    private func calculatorActionsView(smallDevice:Bool, resWidth:CGFloat) -> some View {
        let actions:[(String, CalculatorViewModel.ActionButton)] = [
            ("+", .plus),
            ("－", .minus),
            ("÷", .divide),
            ("×", .multiply)
        ]
        return HStack {
            ForEach(0..<actions.count, id:\.self) { i in
                calcButton(actions[i].0, isSelectedAction:model.higlightActionButtonAt == actions[i].1, isSmall: true, pressed: {
                    numberActionPressed(actions[i].1)
                }, screen: resWidth, style: .secondary)
            }
            
        }
    }
    
    private func inflationActionsView(resWidth:CGFloat, smallDevice:Bool) -> some View {
        VStack(spacing:10, content: {
            calcButton("⌫", pressed: {
                removePressed(lastOnly: true)
            }, screen: resWidth, style: .secondary)
            calcButton("C", pressed: {
                removePressed()
            }, screen: resWidth, style: .secondary)
            
            switch db.dataBase.selectedSegment {
            case .inflation:
                if model.resultEnubled {
                    calcButton("⎋", pressed: {
                        model.showingDetail.toggle()
                    }, screen: resWidth, style:.secondary)
                    
                }
                
            case .calculator:
                //  Spacer()
                //    .frame(height: 55)
                calcButton("=", pressed: {
                    numberActionPressed(.result)
                }, screen: resWidth, style: .secondary)
                
            }
            
            
        })
    }
    
    private func calculatorPadView(screen width:CGFloat, smallDevice:Bool) -> some View {
        let resWidth = smallDevice ? width / 2 : width
        return VStack(alignment: .leading, content: {
            if db.dataBase.selectedSegment == .calculator {
                calculatorActionsView(smallDevice: smallDevice, resWidth: resWidth)
                Spacer()
                    .frame(height: 10)
            }
            HStack(alignment: .top, content: {
                numberPadView(screen: resWidth)
                inflationActionsView(resWidth: resWidth, smallDevice: smallDevice)
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
                    }, screen: width, style:.secondary)
                }
                calcButton(number: 0, screen: width)
                
            }
        })
        
    }
    
    
    func cpi(_ key:LocalDataBase.PickerSelections) -> Double {
        let cpis = db.dataBase.cpi
        let defaultYear = key == .from ? (cpis.first?.year ?? "") : (cpis.last?.year ?? "")
        return model.cpi(db.dataBase.selectedYear[key] ?? defaultYear, db: cpis)
    }
    
    
    func toDecimalPressed() {
        if !model.textFiledValue.contains(".") {
            model.textFiledValue += "."
        }
    }
    
    func calcButton(_ text:String? = nil, number:Int? = nil, isSelectedAction:Bool = false, isSmall:Bool = false, pressed:(()->())? = nil, screen width:CGFloat, style:TextModifier.TextStyle = .primary) -> some View {
        CalculatorViewButton(title: text ?? "\(number ?? 0)", style: style, isSelectedAction:isSelectedAction, pressed: {
            if let pressed = pressed {
                pressed()
            } else {
                numberPressed(number ?? 0)
            }
        })
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
            model.calculatorFirstValue = 0
            model.higlightActionButtonAt = nil
        }
        sound.play(last ? .erase : .eraseAll)
        if db.dataBase.selectedSegment == .inflation {
            model.inflationTextHolder = model.textFiledValue
        }
    }
    
    
    private func segmentedChanged(_ new:Int) {
        withAnimation(.easeInOut) {
            self.db.dataBase.selectedSegment = .init(rawValue: new) ?? .inflation
            self.model.result = self.db.dataBase.selectedSegment == .inflation ? self.model.inflationResult : 0
            self.model.textFiledValue = self.db.dataBase.selectedSegment == .inflation ? self.model.inflationTextHolder : ""
        }
    }
    
    private func isSmallDevice(_ screenSize:CGSize) ->  Bool {
        print(screenSize, " screenSize")
        let isSmall = screenSize.width > screenSize.height && screenSize.height <= 500
        return isSmall
    }
}

#Preview {
    HomeView()
}
