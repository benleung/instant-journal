//
//  EmotionOption.swift
//  instant-journal
//
//  Created by Ben Leung on 2022/09/18.
//

import Foundation

// raw value is used for serialization in firebase
enum EmotionOption: Int {
    case worst = -20
    case bad = -10
    case good = 10
    case perfect = 20
}
