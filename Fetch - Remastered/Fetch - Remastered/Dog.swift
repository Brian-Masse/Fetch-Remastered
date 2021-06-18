//
//  DOgsAndBalls.swift
//  Fetch - Remastered
//
//  Created by Brian Masse on 6/9/21.
//  Copyright © 2021 Brian Masse. All rights reserved.
//

import Foundation
import SpriteKit
import GameKit



class Dog: SKSpriteNode {
    var skin: String = ""
    var runAtlas: [SKTexture] = []
    var sitAtlas: [SKTexture] = []
    
    var animator: Animator = Animator([])
    
    enum ActionKeys: String {
        case animation = "Animation"
    }
    
    init(skin: String) {
        super.init(texture: nil, color: .white, size: CGSize(width: 100, height: 100))
        
        self.skin = skin
        createTextureAtlasses()
        if let staticTexture = sitAtlas.first {
            staticTexture.filteringMode = .nearest
            self.texture = staticTexture
        }
        setup()
        
        
        self.animator = Animator( [
            Animation(State.home, animates: { return SKAction.animate(with: self.sitAtlas , timePerFrame: 0.1) }, for: self),
            Animation(State.throwing, animates: { return SKAction.animate(with: self.runAtlas, timePerFrame: 0.1) }, for: self, waitForCompletion: false),
        ])
    }
    
    func test() -> State {
        return States.currentState
    }
    
    func update() {
        position = currentBall.position
    }
    
    func setup() {
        self.position = CGPoint(x: 0, y: -100)
        let textureSize = texture!.size()
        let size = CGSize(width: textureSize.width * pixelSize * 2, height:  textureSize.height * pixelSize * 2)
        self.size = size
        
    }
    
    func createTextureAtlasses() {
        sitAtlas = createTextureAtlas(atlasName: "\(skin)Sit", contentName: "Sit")
        runAtlas = createTextureAtlas(atlasName: "\(skin)Run", contentName: "Run")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}




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
        velocity = physicsBody!.velocity.dy
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
        var stretchVar: CGFloat {
            return (min(2, max((velocity / 140), 1)))
        }
        
        animator = Animator([
            Animation(State.throwing, animates: animateStretch, for: self)
        ])
    }
    
    func animateStretch() -> SKAction {
        let stretchVar: CGFloat = (min(2, max((velocity / 140), 1)))
        return SKAction.group([
            SKAction.animate(with: ballAtlas, timePerFrame: 0.1),
            SKAction.scaleY(to: stretchVar, duration: 0)
        ])
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


