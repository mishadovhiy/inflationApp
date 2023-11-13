//
//  DB.swift
//  swiftUITestApp
//
//  Created by Misha Dovhiy on 06.11.2023.
//

import Foundation
 

struct DBModelObservable {
    private let dbKey = "dataBaseee"
    static func save(_ newValue:LocalDataBase) {
        var db = DBModelObservable.init()
        db.loadDB {
            db.dataBase = newValue
        }
    }

    var dataBase: LocalDataBase {
           didSet {
               DispatchQueue(label: "db", qos: .userInitiated).async { [self] in
                   UserDefaults.standard.setValue(self.dataBase.dict, forKey: dbKey)
               }
           }
       }

       init() {
           self.dataBase = .init(dict: [:])
       }

    
    mutating func loadDB(completion:(()->())? = nil) {
        self.performLoad(completion: completion)
    }






    private mutating func performLoad(completion:(()->())? = nil) {
        let db = UserDefaults.standard.value(forKey: dbKey) as? [String:Any] ?? [:]
      //  DispatchQueue.main.async {
            self.dataBase = .init(dict: db)
            completion?()
     //   }
    }
}



struct LocalDataBase {
    var dict:[String:Any]
    init(dict: [String : Any]) {
        self.dict = dict
    }
    
    var cpi:[CPIData] {
        get {
            let db = dict["cpi"] as? [[String : Any]] ?? []
            return db.compactMap({.init(dict: $0)}).sorted(by: {$0.year > $1.year})
        }
        set {
            dict.updateValue(newValue.compactMap({$0.dict}), forKey: "cpi")
        }
    }
    
    
    
    var selectedSegment:HomeSegment {
        get {
            return .init(rawValue: dict["selectedSegment"] as? Int ?? 0) ?? .inflation
        }
        set {
            dict.updateValue(newValue.rawValue, forKey: "selectedSegment")
        }
    }


    var selectedYearFrom:String {
        get {
            return selectedYear[.from] ?? ""
        }
        set {
            selectedYear.updateValue(newValue, forKey: .from)
        }
    }
    
    var selectedYearTwo:String {
        get {
            return selectedYear[.to] ?? ""
        }
        set {
            selectedYear.updateValue(newValue, forKey: .to)
        }
    }
    
    var selectedYear: [PickerSelections: String] {
        get {
            let value = (dict["SelectedYear"] as? [String:String]) ?? [:]
            let array = value.compactMap({
                return (PickerSelections.init(rawValue: $0.key) ?? .from, $0.value)
            })
            return Dictionary(uniqueKeysWithValues: array)
        }
        set {
            let array = newValue.compactMap { (key: PickerSelections, value: String) in
                return (key.rawValue, value)
            }
            let new = Dictionary(uniqueKeysWithValues: array)
            
            dict.updateValue(new, forKey: "SelectedYear")
        }
    }
    

    enum PickerSelections:String {
        case from, to
    }
    
    enum HomeSegment:Int {
    case inflation, calculator
    }
    
     
    
}
