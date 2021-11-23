//
//  Ball.swift
//  Fetch - Remastered
//
//  Created by Brian Masse on 6/19/21.
//  Copyright © 2021 Brian Masse. All rights reserved.
//

import Foundation
import SpriteKit


class CurrentBall: SKSpriteNode, CurrentObject, ObservableObject {
    
    typealias currentType = Ball
    
    var type: Ball {
        didSet {
            setupAnimator()
            defineTextureAndSize()
        }
    }
    var animator: Animator = Animator()
    
    @Published var distance: CGFloat = 0
    
    
    var beingHeld: Bool = false {
        willSet {
            if newValue {
                GameView.game.model.currentDog.head.alpha = 1
            } else { GameView.game.model.currentDog.head.alpha = 0 }
        }
    }
    
    init(ball: Ball) {
        self.type = ball
        
        super.init(texture: nil, color: .white, size: CGSize(width: 50, height: 50))
        self.zPosition = GameScene.ZLayer.ball.rawValue
        
        initializePhysics()
        defineTextureAndSize()
    }
    
    func defineTextureAndSize() {
        texture = type.ballAtlas[0]
        if let size = scaleToPixels(node: self, modifier: type.scale) { self.size = size }
    }
    
    func monitorSelf() {
        distance = position.y.trimCGFloat(2)
        if (physicsBody?.velocity.dy)! < 10 && GameView.game.model.currentState == .throwing {
            physicsBody!.velocity.dy = 0 
            GameView.game.changeState(.throwOver)
        }
    }

    func throwSelf() {
        physicsBody!.applyImpulse(CGVector(dx: 0, dy: velocity * GameView.game.throwModifier))
        GameView.game.changeState(.throwing)        
    }
    
    func initializePhysics() {
        let physicsBody = SKPhysicsBody(rectangleOf: self.size)
        physicsBody.affectedByGravity = false
        physicsBody.mass = 200
        self.physicsBody = physicsBody
    }
    
    func setupAnimator() {
        animator.destroy()
        animator = Animator(animate: self, with: [
            Animator.CustomAnimation(triggerState: .throwing, animates: nil, or: animateStretch, withCompletion: nil, withKey: "extra"),
            Animator.CustomAnimation(triggerState: .throwing, animates: animateSpin, or: nil, withCompletion: nil, withKey: "frame"),
            Animator.CustomAnimation(triggerState: .returning, animates: { SKAction.moveBy(x: 0, y: -self.position.y, duration: self.position.y / 1200) }, or: nil, withCompletion: { GameView.game.changeState(.returningPT2) }, withKey: "movement", repeating: 1)
        ])
        animator.update()
    }

    func animateStretch() {
        let scale = 10 - ( 9 * ( ( 25000 -  GameView.game.model.currentBall.physicsBody!.velocity.dy) / 18750))
        GameView.game.model.currentBall.yScale = max(1, scale)
    }

    func animateSpin() -> SKAction {
        return SKAction.animate(with: type.ballAtlas, timePerFrame: 100 / Double(physicsBody!.velocity.dy))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



struct Ball: gameObject {
    let id: String
    
    let ballAtlas: [SKTexture]
    let cost: Int
    let stretch: Bool
    let skin: String
    let UIPreview: UIImage?
    let scale: CGFloat
    
    var isUnlocked = false
    var isCurrent = false {
        didSet { if isCurrent { isUnlocked = true } }
    }
    
    let mouthPos: CGFloat
    
    enum CodableKeys: String, CodingKey {
        case isCurrent
        case isUnlocked
    }
    
    init(skin: String, shouldStretch stretch: Bool, cost: Int, mouth: CGFloat, scale: CGFloat = 1.3) {
        
        self.cost = cost
        self.stretch = stretch
        self.skin = skin
        self.scale = scale
        id = skin + "ball"
        
        // for alligning the mouth and ball whwn the dog picks up a ball
        self.mouthPos = mouth
    
        ballAtlas = createTextureAtlas(atlasName: skin)
        
        guard let staticTexture = ballAtlas.first else { self.UIPreview = nil; return }
        self.UIPreview = UIImage(cgImage: staticTexture.cgImage())
    }
    
    func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodableKeys.self)
        try values.encode(isCurrent, forKey: .isCurrent)
        try values.encode(isUnlocked, forKey: .isUnlocked)
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodableKeys.self)
        
        
        isCurrent = try values.decode(Bool.self, forKey: .isCurrent)
        isUnlocked = try values.decode(Bool.self, forKey: .isUnlocked)
        
        id = ""; ballAtlas = []; cost = 0; stretch = false; skin = ""; mouthPos = 0; UIPreview = UIImage(); scale = 1
    }
}
