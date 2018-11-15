//
//  GameOverViewController.swift
//  FlyingOverThePlanet
//
//  Created by user04 on 2018/9/24.
//  Copyright © 2018年 jerryHU. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController {
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    var score: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func commonInit() {
        scoreLabel.text = "得分: \(score)"
    }
    
}

