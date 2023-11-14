//
//  extensionsSwiftui.swift
//  Inflation
//
//  Created by Misha Dovhiy on 13.11.2023.
//  Copyright © 2023 Misha Dovhiy. All rights reserved.
//

import SwiftUI

struct TextModifier: ViewModifier {
    enum TextStyle {
        case primary, secondary
    }
    var style:TextStyle
    func body(content: Content) -> some View {
        content
            .foregroundColor(.primaryText)
    }
}

struct CalculatorButton: ViewModifier {
    var isDefault:Bool = true
    func body(content: Content) -> some View {
        content
            //.foregroundStyle(.background).background()
    }
}




extension Text {
    var primaryStyle: some View {
        return self.modifier(TextModifier(style: .primary))
    }
    
    var secondaryStyle: some View {
        return self.modifier(TextModifier(style: .secondary))
    }

}

extension TextField {
    var primaryStyle:some View {
        return self.modifier(TextModifier(style: .primary))
    }
    
}

extension Button {
    var calculatorStyle:some View {
        return self.modifier(CalculatorButton(isDefault: true))
    }
    
    var calculatorAdditionalButtonStyle:some View {
        return self.modifier(CalculatorButton(isDefault: false))
    }
}


extension Color {
    static var primaryBackground:Color {
        return .black
    }
    
    static var primaryText:Color {
        return .white
    }
    
    static var secondaryText:Color {
        return .gray
    }
}

extension UIWindow {
    open override func didMoveToWindow() {
        super.didMoveToWindow()
        self.backgroundColor = .red
    }
}
