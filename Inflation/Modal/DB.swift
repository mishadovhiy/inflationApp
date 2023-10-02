//
//  DB.swift
//  Inflation
//
//  Created by Misha Dovhiy on 17.09.2023.
//  Copyright © 2023 Misha Dovhiy. All rights reserved.
//

import Foundation

struct DB {
    static var _db:DataBase?
    static var db:DataBase {
        get {
            if let holder = DB._db {
                return holder
            } else {
                return .init(dict: UserDefaults.standard.value(forKey: "dbvdddddd") as? [String:Any] ?? [:])
            }
            
        }
        set {
            DB._db = newValue
            UserDefaults.standard.setValue(newValue.dict, forKey: "dbvdddddd")
        }
    }
    
}

struct DataBase {
    var dict:[String:Any]
    init(dict: [String : Any]) {
        self.dict = dict
    }
    
    var appUrl:String? {
        //"https://www.dovhiy.com/apps/InflationAppCPI.json" //old
        get {
            return dict["appUrlds"] as? String
        }
        set {
            guard let new = newValue else {
                dict.removeValue(forKey: "appUrlds")
                return
            }
            dict.updateValue(new, forKey: "appUrlds")
            urlSettedDate = Int(Date().toDateComponents().intDate)
            print(Date().toDateComponents(), " hrgdfsv")
        }
    }
    
    
    var urlSettedDate:Int {
        get {
            return dict["urlSettedDate"] as? Int ?? 0
        }
        set {
            dict.updateValue(newValue, forKey: "urlSettedDate")
        }
    }
    
    var cpi:[String:Double] {
        get {
            return dict["CPIData"] as? [String:Double] ?? [:]
        }
        set {
            dict.updateValue(newValue, forKey: "CPIData")
        }
    }
}

