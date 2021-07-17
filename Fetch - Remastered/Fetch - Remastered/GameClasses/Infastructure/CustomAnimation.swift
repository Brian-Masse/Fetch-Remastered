//
//  CustomAnimation.swift
//  Fetch - Remastered
//
//  Created by Brian Masse on 6/15/21.
//  Copyright © 2021 Brian Masse. All rights reserved.
//

import Foundation
import SpriteKit
import Combine

class Animator {
    
    var animations: [CustomAnimation] = []
    var target: SKNode = SKNode()
    
    var runningActions: [String] = []
    
    var itemObserver: AnyCancellable!
    
    //block then completion
    init( animate target: SKNode, with animations: [CustomAnimation] ) {
        self.animations = animations
        for a in self.animations {
            a.animator = self
        }
        self.target = target
        
            itemObserver = GameView.game.$model
                .sink() { [self] model in
                    stateDidChange(model.currentState)
                }
    }
    init() {}
    func stateDidChange(_ newState : FetchClassic.StateEnum) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
            self.update()
        }
    }
    
    func destroy() {
        for animation in animations {
            animation.repeatTotal = 0
        }
        animations.removeAll()
        target.removeAllActions()
        runningActions.removeAll()
    }
    
    func update() {
        runningActions.removeAll()
        for enumeration in animations.enumerated() {
            if enumeration.element.triggerState == GameView.game.currentState {
                animations[enumeration.offset].animate()
            }
        }
    }

    class CustomAnimation {
        let triggerState: FetchClassic.StateEnum
        let key: String
        var repeatTotal: Int
        
        let animation: (() -> SKAction)?
        let completion: (() -> Void)?
        let block: (() -> Void)?
        
        var animator: Animator = Animator()
        var repeatCount: Int = 0
        
        init(triggerState: FetchClassic.StateEnum, animates animation: (() -> SKAction)?, or block: (() -> Void)?, withCompletion: (() -> Void)?, withKey: String, repeating: Int = -1 ) {
            self.triggerState = triggerState
            self.animation = animation
            self.completion = withCompletion
            self.block = block
            self.key = withKey
            self.repeatTotal = repeating
        }
        
        func canIterate() -> Bool {
            repeatCount += 1
            if GameView.game.currentState == triggerState && (repeatCount < repeatTotal || repeatTotal == -1)  { return true }
            else { return false }
        }
        
        func animate() {

            if animation != nil {
                if animator.runningActions.firstIndex(of: key) == nil {
                    animator.runningActions.append(key)
                    self.animator.target.run(animation!()) { [self] in
                        if let indexOfKey = animator.runningActions.firstIndex(of: key) { animator.runningActions.remove(at: indexOfKey) }
                        if completion != nil { completion!() }
                        if canIterate() { animate() }
                    }
                }
            }
            if block != nil {
                if canIterate() {
                    block!()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.001, execute: animate )
                }
            }
        }
    }
}



//
//class Animator {
//
//    var animations: [CustomAnimation] = []
//
//    lazy var itemObserver: AnyCancellable? = GameView.game.$model
//     .sink() { self.currentState = $0.currentState}
//
//    var currentState: FetchClassic.StateEnum = .home {
//        didSet {
//            update()
//        }
//    }
//
//    init(_ animations: [CustomAnimation]) {
//        self.animations = animations
//    }
//
//    func update() {
//        for animation in animations {
//            if animation.triggerState == currentState {
//                animation.update(true)
//            }
//        }
//    }
//
//    func destroy() {
//        for animation in animations {
//            animation.destroy()
//        }
//        animations.removeAll()
//    }
//}
//
//
//class CustomAnimation {
//
//    var repeating: Bool
//    var running: Bool = false
//    let triggerState: FetchClassic.StateEnum
//    var currentState: FetchClassic.StateEnum {
//        return GameView.game.model.currentState
//    }
//
//    var target: SKNode?
//
//    let animationConstructor: (() -> SKAction)?
//    let optionalBlock: (() -> Void)?
//
//    let completionBlock: (() -> Void)?
//
//    init(_ triggerState: FetchClassic.StateEnum, animates animationConstructor: (() -> SKAction)?, for target: SKNode, repeating: Bool = true, insteadRun block: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
//
//        self.triggerState = triggerState
//        self.target = target
//        self.animationConstructor = animationConstructor
//        self.optionalBlock = block
//        self.repeating = repeating
//        self.completionBlock = completion
//
//
//    }
//
//    func update(_ first: Bool) {
//        if (currentState == triggerState || first) && !running {
//            guard let _ = optionalBlock else { runAnimation(); return }
//            runBlock()
//        }
//        else if currentState != triggerState && first {
//            running = false
//            self.update(true)
//        }
//    }
//
//    func runAnimation() {
//        self.running = true
//        target!.run(animationConstructor!()) {
//            self.running = false
//            if let block = self.completionBlock { block()}
//            if self.repeating { self.update(false); }
//        }
//    }
//
//    func runBlock() {
//        self.optionalBlock!()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
//            self.update(false)
//
//        }
//    }
//
//    func destroy() {
//        repeating = false
//        running = true
//        target = nil
//    }
//}
