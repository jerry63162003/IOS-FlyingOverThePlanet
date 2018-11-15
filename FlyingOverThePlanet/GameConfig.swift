//
//  GameConfig.swift
//  FlyingOverThePlanet
//
//  Created by user04 on 2018/9/24.
//  Copyright © 2018年 jerryHU. All rights reserved.
//

import UIKit
public let defaults = UserDefaults.standard
let gameLevelStr = "Sorce"
let uGameMusic = "isGameMusic"
let uGameSound = "isGameSound"

class GameConfig: NSObject {
    static let shared = GameConfig()
    
    private var _highScore: Int = 0
    var highScore: Int {
        get {
            return defaults.integer(forKey: gameLevelStr)
        }
        
        set {
            _highScore = newValue
            defaults.set(newValue, forKey: gameLevelStr)
            defaults.synchronize()
        }
    }
    
    var isGameMusic = defaults.object(forKey: uGameMusic) as? Bool ?? true {
        didSet {
            defaults.set(isGameMusic, forKey: uGameMusic)
            defaults.synchronize()
        }
    }
    var isGameSound = defaults.object(forKey: uGameSound) as? Bool ?? true {
        didSet {
            defaults.set(isGameSound, forKey: uGameSound)
            defaults.synchronize()
        }
    }
    
}
