//
//  File.swift
//  Fetch - Remastered
//
//  Created by Brian Masse on 9/2/20.
//  Copyright © 2020 Brian Masse. All rights reserved.
//

import SpriteKit
import GameKit


class testScene: SKScene {
    
    
    let backPlate = SKSpriteNode()
    let frontLight = SKLightNode()
    
    let secondLight = SKLightNode()
    
    override func sceneDidLoad() {
        
        let texture = SKTexture(imageNamed: "Test")
        texture.filteringMode = .nearest
        
        backPlate.texture = texture
        backPlate.size = CGSize(width: frame.width, height: frame.height)
        backPlate.position = CGPoint(x: frame.midX, y: frame.midY)
        
        backPlate.lightingBitMask = 1
        backPlate.shadowedBitMask = 1
        backPlate.shadowCastBitMask = 0
        
        self.addChild(backPlate)
        
        frontLight.categoryBitMask = 1
        frontLight.ambientColor = UIColor(red: 1, green: 249 / 255, blue: 0 / 255, alpha: 0.0)
        frontLight.lightColor = UIColor(red: 1, green: 249 / 255, blue: 0 / 255, alpha: 1)
        frontLight.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.0)
        frontLight.falloff = 2

        frontLight.position = CGPoint(x: frame.midX, y: frame.midY)

        self.addChild(frontLight)
        
    }

}
