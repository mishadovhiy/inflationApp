//
//  Double+Int+Float.swift
//  Inflation
//
//  Created by Misha Dovhiy on 14.11.2023.
//  Copyright © 2023 Misha Dovhiy. All rights reserved.
//

import Foundation

extension Double {
    var string:String {
        let hasDecimals = self.truncatingRemainder(dividingBy: 1) != 0
        return String(format: "%.\(!hasDecimals ? 0 : 2)f", self)
    }
}


extension Int {
    var dateComponents:DateComponents {
        return Date.init(timeIntervalSince1970: TimeInterval(self)).toDateComponents()
    }
}

extension UInt64 {
    var dateComponents:DateComponents {
        return Int(self).dateComponents
    }
}
