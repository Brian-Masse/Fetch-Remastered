//
//  Animation.swift
//  Fetch - Remastered
//
//  Created by Brian Masse on 6/15/21.
//  Copyright © 2021 Brian Masse. All rights reserved.
//

import Foundation
import SpriteKit
import Combine

class Animator {
    
    var itemObserver: AnyCancellable?
    var animations: [Animation] = []
    
    var state: State {
        didSet {
            update()
        }
    }
    
    init(_ animations: [Animation]) {
        
        self.animations = animations
        self.state = States.currentState
        //initialize a temporary value, such that the class has initialized self
        itemObserver = States.$currentState.sink() { let _ = ($0) }
        itemObserver = States.$currentState
            .sink() { self.state = $0 }
    }
    
    func update() {
        for animation in animations {
            if animation.triggerState == state {
                animation.update(true)
            }
        }
    }
}



class Animation {
    
    let waitForCompletion: Bool
    let repeating: Bool
    
    var running: Bool = false
    let triggerState: State
    var currentState: State {
        return States.currentState
    }
    
    let target: SKNode
    let animationConstructor: (() -> SKAction)?
    let optionalBlock: (() -> Void)?
    
    
    init(_ triggerState: State, animates animationConstructor: (() -> SKAction)?, for target: SKNode, waitForCompletion: Bool = true, repeating: Bool = true, insteadRun block: (() -> Void)? = nil) {
    
        self.triggerState = triggerState
        self.target = target
        self.animationConstructor = animationConstructor
        self.optionalBlock = block
        
        self.waitForCompletion = waitForCompletion
        self.repeating = repeating
        
    }
    
    func update(_ first: Bool) {
        
        if (currentState == triggerState || first) && !running {
            if let _ = optionalBlock {
                runBlock()
            }else {
                runAnimation()
            }
            
        }
    }
    
    func runAnimation() {
        self.running = true
        
        if !self.waitForCompletion { target.removeAllActions() }
        if !target.hasActions() {
            target.run(animationConstructor!()) {
                self.running = false
                self.target.removeAllActions()
                if self.repeating { self.update(false) }
            }
        }
    }
    
    func runBlock() {
        optionalBlock!()
    }
}
