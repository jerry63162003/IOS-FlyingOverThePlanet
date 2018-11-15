//
//  RocketScene.swift
//  Swift Alps Game Jam
//
//  Created by Petteri Hyttinen on 2017-11-23.
//

import Foundation
import SpriteKit

final class RocketScene: SKScene, SKSceneDelegate, SKPhysicsContactDelegate {

    private var rocket: SKSpriteNode!
    private var asteroid: SKSpriteNode?
    private var asteroid1: SKSpriteNode?
    fileprivate func addRocket() {
        rocket = SKSpriteNode(imageNamed: "火箭")
        rocket.position.x = frame.midX
        rocket.position.y = frame.minY + rocket.frame.height/2

        addChild(rocket)
    }
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        self.delegate = self
        self.physicsWorld.contactDelegate = self
        self.backgroundColor = UIColor.clear
        addRocket()
        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { [weak self] _ in

            guard let scene = self else {
                return
            }
            let arr = ["1","2","3","4","5","6"]
            let num = arc4random_uniform(6)
            let imageNamed = arr[Int(num)]
            
            let asteroid = SKSpriteNode(imageNamed: imageNamed)
            scene.asteroid = asteroid
            asteroid.position.x = CGFloat(arc4random_uniform(UInt32(scene.frame.maxX)))
            asteroid.position.y = scene.frame.maxY
            asteroid.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
            asteroid.physicsBody?.isDynamic = false
            scene.addChild(asteroid)

            asteroid.run(.moveTo(y: -asteroid.frame.height, duration: 3)) {
                asteroid.removeFromParent()
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { [weak self] _ in
            
            guard let scene = self else {
                return
            }
            
            let asteroid_background = SKSpriteNode(imageNamed: "4")
            asteroid_background.scale(to: CGSize(width: 5, height: 5))
            
            asteroid_background.position.x = CGFloat(arc4random_uniform(UInt32(scene.frame.maxX)))
            asteroid_background.position.y = scene.frame.maxY
            scene.addChild(asteroid_background)
            
            asteroid_background.run(.moveTo(y: -asteroid_background.frame.height, duration: TimeInterval(arc4random_uniform(UInt32(4))))) {
                asteroid_background.removeFromParent()
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] _ in

            guard let scene = self else {
                return
            }
            let arr = ["4","5","6"]
            let num = arc4random_uniform(3)
            let imageNamed = arr[Int(num)]

            let asteroid = SKSpriteNode(imageNamed: imageNamed)
            scene.asteroid1 = asteroid
            asteroid.position.x = CGFloat(arc4random_uniform(UInt32(scene.frame.maxX)))
            asteroid.position.y = scene.frame.maxY
            asteroid.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
            asteroid.physicsBody?.isDynamic = false
            scene.addChild(asteroid)

            asteroid.run(.moveTo(y: -asteroid.frame.height, duration: 3)) {
                asteroid.removeFromParent()
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        let location = touches.first?.location(in: self.scene!)

        rocket.run(.move(to: location!, duration: 0.5))
    }

    override func update(_ currentTime: TimeInterval) {

        super.update(currentTime)
        
        if defaults.bool(forKey: "isGameOver") {
            self.rocket.removeFromParent()
            self.asteroid?.removeFromParent()
            self.asteroid1?.removeFromParent()
            self.removeAllActions()
            self.removeAllChildren()
            return
        }
        
        guard let rocket = self.rocket, let asteroid = self.asteroid, let asteroid1 = self.asteroid1 else {
            return
        }

        if asteroid.frame.intersects(rocket.frame) || asteroid1.frame.intersects(rocket.frame){

            let textures: [SKTexture] = [
                SKTexture(imageNamed: "Explosion-0"),
                SKTexture(imageNamed: "Explosion-1"),
                SKTexture(imageNamed: "Explosion-2"),
                SKTexture(imageNamed: "Explosion-3"),
                SKTexture(imageNamed: "Explosion-4"),
                SKTexture(imageNamed: "Explosion-5"),
                SKTexture(imageNamed: "Explosion-6")
            ]
            rocket.run(.animate(with: textures, timePerFrame: 0.05)) {
                self.rocket.removeFromParent()
                self.asteroid?.removeFromParent()
                self.asteroid1?.removeFromParent()
                self.removeAllActions()
                self.removeAllChildren()
                defaults.set(true, forKey: "isGameOver")
            }
        }
    }
    
}
