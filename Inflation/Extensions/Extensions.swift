//
//  Extensions.swift
//  Inflation
//
//  Created by Misha Dovhiy on 17.09.2023.
//  Copyright © 2023 Misha Dovhiy. All rights reserved.
//

import Foundation

extension Date {
    var differenceFromNow: DateComponents {
        return Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self, to: Date())
    }
    
    func toDateComponents() -> DateComponents {
        let string = self.iso8601withFractionalSeconds
        let comp = DateComponents()
        return comp.stringToCompIso(s: string)
    }
    var iso8601withFractionalSeconds: String {
        return Formatter.iso8601withFractionalSeconds.string(from: self)
        
    }
    
}

extension String {
    var iso8601withFractionalSeconds: Date? {
        return Formatter.iso8601withFractionalSeconds.date(from: self)
        
    }
}
extension DateComponents {
    var intDate:UInt64 {
        let date = Calendar.current.date(from: self)
        let timeInterval = date?.timeIntervalSince1970
        let int = UInt64(timeInterval ?? 0)
        return int
    }
    func toIsoString() -> String? {
        if let date = Calendar.current.date(from: self){
            return date.iso8601withFractionalSeconds
        }
        return nil
    }
    func stringToCompIso(s: String, dateFormat:String="dd.MM.yyyy") -> DateComponents {
        if let date = s.iso8601withFractionalSeconds {
            return Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        } else {
            return stringToDateComponent(s: s, dateFormat: dateFormat)
        }
    }
    
    private func stringToDateComponent(s: String, dateFormat:String="dd.MM.yyyy") -> DateComponents {//make privat
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.date(from: s)
        return Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date ?? Date())
    }
    
}

extension ISO8601DateFormatter {
    convenience init(_ formatOptions: Options) {
        self.init()
        self.formatOptions = formatOptions
    }
}
extension Formatter {
    static let iso8601withFractionalSeconds = ISO8601DateFormatter([.withInternetDateTime, .withFractionalSeconds])
}

