//
//  RegularTableData.swift
//  swiftUITestApp
//
//  Created by Misha Dovhiy on 10.11.2023.
//

import Foundation

struct RegularTableData:Hashable, Identifiable {
    var id:UUID = .init()
    let title:String
    var description:String = ""
}
