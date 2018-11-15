//
//  GameViewController.swift
//  FlyingOverThePlanet
//
//  Created by user04 on 2018/9/24.
//  Copyright © 2018年 jerryHU. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    fileprivate var displayLink: CADisplayLink?
    fileprivate var beginTimestamp: TimeInterval = 0
    fileprivate var elapsedTime: TimeInterval = 0
    private lazy var gameView = SKView()
    let gameConfig = GameConfig.shared
    let sound = SoundManager()
    var interval = Int()
    
    // MARK: - IBOutlets
    @IBOutlet weak var clockLabel: UILabel!
    var scene: SKScene?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults.set(false, forKey: "isGameOver")
        scene = makeScene()
        self.view.addSubview(gameView)
        gameView.frame = view.bounds
        gameView.backgroundColor = UIColor.clear
        if gameView.scene == nil {
            gameView.presentScene(scene)
            addBackBtn()
        }
        startGame()
    }
    
    @objc func tick(sender: CADisplayLink) {
        updateCountUpTimer(timestamp: sender.timestamp)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toGameOver" {
            let vc = segue.destination as! GameOverViewController
            vc.score = clockLabel.text!
        }
    }
        
    func makeScene() -> SKScene {
        return RocketScene(size: UIScreen.main.bounds.size)
    }
    
    func addBackBtn() {
        let backBtn = UIButton()
        backBtn.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
        backBtn.setImage(#imageLiteral(resourceName: "返回"), for: .normal)
        gameView.addSubview(backBtn)
        backBtn.snp.makeConstraints { (make) in
            make.top.left.equalTo(view)
        }
    }
    
    @objc func buttonClick(_ sender: UIButton) {
        stopGame()
        dismiss(animated: true, completion: nil)
    }
    
    func startDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(tick(sender:)))
        displayLink?.add(to: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
    }
    
    func stopDisplayLink() {
        displayLink?.isPaused = true
        displayLink?.remove(from: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
        displayLink = nil
    }
    
    func gameOver() {
        stopGame()
        checkIsHighScore()
        performSegue(withIdentifier: "toGameOver", sender: clockLabel.text)
    }
    
    func checkIsHighScore() {
        guard let highStr = defaults.object(forKey: "highScore") as? String else {
            return
        }
        
        guard var start = highStr.index(of: ":") else {
            return
        }
        
        start = highStr.index(after: start)
        
        guard let end = highStr.index(of: ".") else {
            return
        }
        
        let highMin = highStr.prefix(2)
        let highSec = highStr[start..<end]
        
        if interval / 60 % 60 > Int(highMin)! {
            defaults.set(clockLabel.text, forKey: "highScore")
        } else if interval % 60 > Int(highSec)! {
            defaults.set(clockLabel.text, forKey: "highScore")
        }
    }
    
    func stopGame() {
        stopDisplayLink()
        scene = nil
        gameView.removeFromSuperview()
        if gameConfig.isGameMusic {
            sound.stopBackGroundSound()
        }
        if gameConfig.isGameSound {
            sound.playOverSound()
        }
    }
    
    func startGame() {
        startDisplayLink()
        beginTimestamp = 0
        if gameConfig.isGameMusic {
            sound.playBackGroundSound()
        }
    }
    
    func updateCountUpTimer(timestamp: TimeInterval) {
        if beginTimestamp == 0 {
            beginTimestamp = timestamp
        }
        if defaults.bool(forKey: "isGameOver") {
            self.gameOver()
        }
        elapsedTime = timestamp - beginTimestamp
        clockLabel.text = format(timeInterval: elapsedTime)
    }
    
    func format(timeInterval: TimeInterval) -> String {
        interval = Int(timeInterval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let milliseconds = Int(timeInterval * 1000) % 1000
        return String(format: "%02d:%02d.%03d", minutes, seconds, milliseconds)
    }
    
}
