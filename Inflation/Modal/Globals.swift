//
//  Data.swift
//  Inflation
//
//  Created by Misha Dovhiy on 27.11.2019.
//  Copyright © 2019 Misha Dovhiy. All rights reserved.
//

import UIKit

struct Globals {
        
    //here
    static var cpi:[String:Double] = [:] //UserDefaults.value(forKey: "cpiData") as? [String:Double] ?? [:]
    
   // var cpiData: [String:String] = [:]
    
    
    static var firstYear: String = ""
    
    static var secondYear: String = ""
    
    static var firstCpi = 0.0
    
    static var secondCpi = 0.0
    
    static var amount = "0"
    
    static var result = 0.0
    
    static func pickerData() -> [String] {
        return cpi.keys.sorted()
    }

}
