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


class CurrentDog: SKSpriteNode, CurrentObject {
    
    typealias currentType = Dog

    var type: Dog {
        didSet {
            setupAnimator()
            defineTextureAndSize()

        }
    }
    
    let head: SKSpriteNode
    var animator: Animator = Animator()
    
    init(dog: Dog) {
        
        self.type = dog
        self.head = SKSpriteNode(texture: scalingTextures(texture: dog.skin+"Head"))
        
        super.init(texture: nil, color: .white, size: CGSize(width: 100, height: 100))
        
        if let staticTexture = dog.sitAtlas.first {
            staticTexture.filteringMode = .nearest
            self.texture = staticTexture
        }
        
        setup()
    }
    
    
    func setup() {
        self.position = CGPoint(x: 0, y: -120)
        if let size = scaleToPixels(node: self, modifier: 2) { self.size = size }
        self.zPosition = 100
        
        self.addChild(head)
        head.zPosition = 1002
        head.alpha = 0
        head.anchorPoint = CGPoint(x: 0, y: 1)
        defineTextureAndSize()
    }
    
    func update() {
        if GameView.game.currentState == .throwing {
            position.y = GameView.game.model.currentBall.position.y - (self.size.height * 0.8)
        }
    }
    
    func defineTextureAndSize() {
        texture = type.sitAtlas[0]
        if let size = scaleToPixels(node: self, modifier: 2) { self.size = size }
        head.texture = scalingTextures(texture: type.skin+"Head")
        if let headSize = scaleToPixels(node: head, modifier: 2) { self.head.size = headSize }
        head.position = CGPoint(x: self.size.width / -2, y: self.size.height / 2)
    }
    
    func setupAnimator() {
        animator.destroy()
        
        func collectBallAnimation () -> SKAction {
            SKAction.moveTo(y: GameView.game.currentBall.position.y, duration: 0.4)
        }
        let run = SKAction.animate(with: self.type.runAtlas, timePerFrame: 0.1)
        let sit = SKAction.animate(with: self.type.sitAtlas , timePerFrame: 0.08)
        
        animator = Animator(animate: self, with: [
            Animator.CustomAnimation(triggerState: .home, animates: { return SKAction.rotate(toAngle: 0, duration: 0) }, or: nil, withCompletion: nil, withKey: "movement", repeating: 1),
            Animator.CustomAnimation(triggerState: .home, animates: { return sit }, or: nil, withCompletion: nil, withKey: "frame"),
            Animator.CustomAnimation(triggerState: .throwing, animates: { return run }, or: nil, withCompletion: nil, withKey: "frame"),
            Animator.CustomAnimation(triggerState: .throwOver, animates: collectBallAnimation, or: nil, withCompletion: { GameView.game.changeState(.caught)}, withKey: "movement",  repeating: 1),
            Animator.CustomAnimation(triggerState: .throwOver, animates: { return run }, or: nil, withCompletion: nil, withKey: "frame"),
            Animator.CustomAnimation(triggerState: .caught, animates: { return sit }, or: nil, withCompletion: nil, withKey: "frame"),
            Animator.CustomAnimation(triggerState: .returning, animates: { return SKAction.rotate(toAngle: CGFloat.pi, duration: 0) }, or: nil, withCompletion: nil, withKey: "movement", repeating: 1),
            Animator.CustomAnimation(triggerState: .returning, animates: nil, or: carryWalk, withCompletion: nil, withKey: "extra"),
            Animator.CustomAnimation(triggerState: .returning, animates: { return run }, or: nil, withCompletion: nil, withKey: "frame"),
            Animator.CustomAnimation(triggerState: .returningPT2, animates: { return run }, or: nil, withCompletion: nil, withKey: "frame"),
            Animator.CustomAnimation(triggerState: .returningPT2, animates: { return SKAction.moveTo(y:  GameView.game.currentBall.frame.minY - (GameView.game.currentDog.size.height / 2), duration: 1/5) }, or: nil, withCompletion: { GameView.game.changeState(.home)}, withKey: "movement", repeating: 1)
        ])
        
        animator.update()
    }
    
    func carryWalk() {
        let currentBall = GameView.game.model.currentBall
        let currentDog = GameView.game.model.currentDog
        
        let halfBallHeight = (currentBall!.size.height / 2)
        let halfDogHeight = (currentDog!.size.height / 2)
        currentDog!.position.y = (currentBall!.position.y + halfDogHeight) - (currentBall!.type.mouthPos * pixelSize) + halfBallHeight
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct Dog: gameObject, Codable {
    let id: String
        
    let runAtlas: [SKTexture]
    let sitAtlas: [SKTexture]
    
    let cost: Int
    let skin: String
    let UIPreview: UIImage?
    
    var isUnlocked = false
    var isCurrent = false
    
    let mouthPos: CGPoint
    
    enum CodableKeys: String, CodingKey {
        case isCurrent
        case isUnlocked
    }
    
    init(skin: String, cost: Int, mouth: CGPoint) {
        self.cost = cost
        self.skin = skin
        //for Alligining the ball in the dogs mouth when they catch it
        self.mouthPos = mouth
    
        sitAtlas = createTextureAtlas(atlasName: "\(skin)Sit")
        runAtlas = createTextureAtlas(atlasName: "\(skin)Run")
        
        id = skin + "dog"
        
        guard let staticTexture = sitAtlas.first else { self.UIPreview = nil; return }
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
        
        id = ""; skin = ""; cost = 0; sitAtlas = []; runAtlas = []; mouthPos = CGPoint(x: 0, y: 0); UIPreview = UIImage()
    }
}
