//
//  SoundModel.swift
//  Inflation
//
//  Created by Misha Dovhiy on 14.11.2023.
//  Copyright © 2023 Misha Dovhiy. All rights reserved.
//

import UIKit
import AudioToolbox

struct SoundModel {
    func play(_ sound:SoundName) {
        AudioServicesPlaySystemSound(sound.rawValue)
    }

    func vibrate() {
        UIImpactFeedbackGenerator().impactOccurred()
    }
    
    enum SoundName:SystemSoundID {
        case key = 1104
        case erase = 1155
        case eraseAll = 1156
    }
}




