//
//  Ball.swift
//  Fetch - Remastered
//
//  Created by Brian Masse on 6/19/21.
//  Copyright © 2021 Brian Masse. All rights reserved.
//

import Foundation
import SpriteKit

class Ball: SKSpriteNode {
    var skin: String = ""
    var ballAtlas: [SKTexture] = []
    var stretch: Bool = false
    
    var animator: Animator? = nil
    
    
    
    init(skin: String, stretch: Bool) {
        super.init(texture: nil, color: .white, size: CGSize(width: 50, height: 50))
        
        self.stretch = stretch
        self.skin = skin
    
        initializePhysics()
        createTextureAtlasses()
        
        calculatePixelWidth()
        setupAnimations()
    }
    
    func calculatePixelWidth() {
        pixelSize = (self.size.width / texture!.size().width)
    }
    
    func initializePhysics() {
        let physicsBody = SKPhysicsBody(rectangleOf: self.size)
        physicsBody.affectedByGravity = false
        physicsBody.linearDamping = friction
        physicsBody.mass = 200
        self.physicsBody = physicsBody
    }
    
    func createTextureAtlasses() {
        ballAtlas = createTextureAtlas(atlasName: skin, contentName: "ball")
        texture = ballAtlas[0]
    }
    
    func monitorSelf() {
        if (physicsBody?.velocity.dy)! < 0.1 && States.currentState == State.throwing {
            States.currentState = State.throwOver
            updateStateToThrowComplete()
        }
    }
    
    func throwSelf() {
        physicsBody!.applyImpulse(CGVector(dx: 0, dy: velocity * throwModifier))
        States.currentState = State.throwing
    }
    

    func setupAnimations() {
    
        animator = Animator([
            Animation(State.throwing, animates: nil, for: self, insteadRun: animateStretch),
//            Animation(State.throwing, animates: animateSpin, for: self)
        ])
    }
    
    func animateStretch() {
        
        
        globalScene.currentBall.yScale =  min(100, pow(2, globalScene.currentBall.physicsBody!.velocity.dy / 1000))
        
    }
    
    func animateSpin() -> SKAction {
        return SKAction.animate(with: ballAtlas, timePerFrame: 100 / Double(physicsBody!.velocity.dy))
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
