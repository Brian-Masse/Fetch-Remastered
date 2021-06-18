//
//  UniversalFunctions.swift
//  Fetch - Remastered
//
//  Created by Brian Masse on 6/12/21.
//  Copyright © 2021 Brian Masse. All rights reserved.
//

import Foundation
import SpriteKit

let emptyColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
let defaults = UserDefaults.standard
let defaultFont = "Fetch_remasteredFont-Regular"

//MARK: States:

enum State {
    case home
    case throwing
    case throwOver
}

class StateClass: ObservableObject {
    @Published var currentState: State = State.home
}

var States = StateClass()


//MARK: Modifiers:
var friction = CGFloat(1)
var throwModifier = CGFloat(4000)


var virtualCamera: CameraObject!

var velocity = CGFloat(0)
var velocityLabel: FlippingLabel?

var pixelSize: CGFloat = 0

var currentBall: Ball!
var currentDog: Dog!




func updateStateToThrowComplete() {
    velocityLabel?.update(newAmount: 0.00, usingQueue: true, speed: 1)
}


func scalingTextures(texture: String) -> SKTexture{
    let tempTexture = SKTexture(imageNamed: texture)
    tempTexture.filteringMode = .nearest
    return tempTexture
}

func createTextureAtlas(atlasName: String, contentName: String) -> [SKTexture] {
    var returningAtlas: [SKTexture] = []
    let tempAtlas = SKTextureAtlas(named: atlasName)
        for i in 0..<tempAtlas.textureNames.count {
            let name = "\(contentName)\(i + 1)"
            returningAtlas.append(scalingTextures(texture: name))
        }
    return returningAtlas
}

extension CGFloat {
    func trimCGFloat(_ decimalCount: Int) -> CGFloat {
        let modifier = CGFloat(pow(10, Float(decimalCount)))
        var trimmedFloat = self
        
        trimmedFloat *= modifier
        trimmedFloat.round()
        trimmedFloat /= modifier
        
        return trimmedFloat
    }

}
