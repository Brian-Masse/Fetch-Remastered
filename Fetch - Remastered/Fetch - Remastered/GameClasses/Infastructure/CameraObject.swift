//
//  CameraObject.swift
//  Fetch - Remastered
//
//  Created by Brian Masse on 6/11/21.
//  Copyright © 2021 Brian Masse. All rights reserved.
//

import Foundation
import SpriteKit

class CameraObject: SKCameraNode {
    
    var targetObject: SKNode!
    
    init(_ targetObject: SKNode?) {
        super.init()
        self.targetObject = targetObject
        self.setScale(414 / globalFrame.width)
        self.update()
    }
    
    func update() {
        position.y = (GameView.game.model.currentDog.position.y + GameView.game.model.currentBall.position.y) / 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
