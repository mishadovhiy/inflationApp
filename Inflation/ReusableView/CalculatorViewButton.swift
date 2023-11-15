//
//  CalculatorViewButton.swift
//  Inflation
//
//  Created by Misha Dovhiy on 15.11.2023.
//  Copyright © 2023 Misha Dovhiy. All rights reserved.
//

import SwiftUI

struct CalculatorViewButton:View {
    let title:String
    let style:TextModifier.TextStyle
    let isSelectedAction:Bool
    let pressed:()->()
    
    @State private var touchesBegun:Bool = false
    @GestureState var translation: CGSize = .zero

    var body: some View {
        GeometryReader(content: { geometry in
            Button(action: {
                pressed()
            }, label: {
                Text(title)
                    .style(.init(style: style))
                    .frame(width: geometry.size.width, height: geometry.size.height)
            })
            .background(Color("gray2").opacity(touchesBegun ? 0.2 : 0))
            .clipShape(RoundedRectangle(cornerRadius: 6))
            
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color("gray2"), lineWidth: isSelectedAction ? 1 : 0)
              .frame(width: geometry.size.width, height: geometry.size.height)
            
        })
        
    }
    
}
