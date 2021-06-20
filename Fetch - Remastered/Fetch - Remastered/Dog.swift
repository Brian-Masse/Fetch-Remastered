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
        
        
//        self.animator = Animator( [
//            Animation(State.home, animates: { return SKAction.animate(with: self.sitAtlas , timePerFrame: 0.1) }, for: self),
//            Animation(State.throwing, animates: { return SKAction.animate(with: self.runAtlas, timePerFrame: 0.1) }, for: self, waitForCompletion: false),
//        ])
    }
    
    func test() -> State {
        return States.currentState
    }
    
    func update() {
        position = globalScene.currentBall.position
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
