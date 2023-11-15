//
//  KeyPressDetectorView.swift
//  Inflation
//
//  Created by Misha Dovhiy on 15.11.2023.
//  Copyright © 2023 Misha Dovhiy. All rights reserved.
//

import UIKit
import SwiftUI

struct KeyPressDetectorView: UIViewRepresentable {
    typealias UIViewType = KeyPressDetectorUIView

    func makeUIView(context: Context) -> KeyPressDetectorUIView {
        return KeyPressDetectorUIView()
    }

    func updateUIView(_ uiView: KeyPressDetectorUIView, context: Context) {
    }
}

class KeyPressDetectorUIView: UIView {
    override var canBecomeFirstResponder: Bool {
        return true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.becomeFirstResponder()
    }

    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        super.pressesBegan(presses, with: event)
        // Handle key presses here
        if let key = presses.first?.key {
            print("Pressed key: \(key.charactersIgnoringModifiers ?? "")")
        }
    }
}
