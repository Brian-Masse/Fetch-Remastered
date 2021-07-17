//
//  Velocity Label.swift
//  Fetch - Remastered
//
//  Created by Brian Masse on 6/13/21.
//  Copyright © 2021 Brian Masse. All rights reserved.
//

import Foundation
import SpriteKit

class FlippingLabel: SKNode {
    
    var digits: [Digit] = []
    var usingQueueOnNextCompletion: Bool = false
    var queuedValue: CGFloat = 0
    
    var displayedDigits: Int = 0
    
    override init() {
        super.init()
    }
    
    init(displayedDigits: Int) {
        super.init()
        
        self.displayedDigits = displayedDigits
        self.initializeCharacters()
    }
    
    func initializeCharacters() {
        let x = (-displayedDigits + 1)
        let positionOffSet = CGFloat( (30 * x) / 2)
        for i in 0..<displayedDigits {
            let position = CGPoint(x: CGFloat(i * 30) + positionOffSet, y: 0)
            let digit = Digit(position: position)
            digits.append(digit)
            
            self.addChild(digit.newDigit)
            self.addChild(digit.currentDigit)
        }
    }
    
    func queueRun() {
        if children.allSatisfy({ !$0.hasActions() }) {
            self.update(newAmount: queuedValue, usingQueue: false, speed: 1)
        }
    }
    
    func update(newAmount: CGFloat, usingQueue: Bool, speed: CGFloat) {
        
        //If something wants to have a finalized update on this class, it can set the usingQueue to true, and when all of the digit classes are doen preforming their actions, it will run this one more time with this stored value
        if usingQueue { queuedValue = newAmount }
        usingQueueOnNextCompletion = usingQueue
        
        let stringedPassedValue = "\(newAmount)"
        var reverseOrderOfString: [Character] = stringedPassedValue.reversed()
                //This ensures that the deciml place is always 2 from the left, changing the decmial trim means chagning this as well
        while String(reverseOrderOfString[2]) != "." {
            reverseOrderOfString.insert(Character("0"), at: 0)
        }
        
        for i in 0..<digits.count {
            var value = "0"
            if i < reverseOrderOfString.count {
                value = String(reverseOrderOfString[i])
            }
            digits[digits.count - 1 - i].updateDigits(newValue: value, speed: speed)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




class Digit {
    var newDigit: FlippingCharacter
    var currentDigit: FlippingCharacter
    
    init(position: CGPoint) {
        newDigit = FlippingCharacter(position: position, isCurrent: false)
        currentDigit = FlippingCharacter(position: position, isCurrent: true)
    }
    
    func updateDigits(newValue: String, speed: CGFloat) {
        
        newDigit.speed = speed
        currentDigit.speed = speed
        
        let stringedCurrentValue = currentDigit.text
        
        if !newDigit.hasActions() && !currentDigit.hasActions() {
            if newValue != stringedCurrentValue {
                newDigit.text = newValue
                
                newDigit.animate(newValue: newValue)
                currentDigit.animate(newValue: newValue)
            }
        }
    }
}





class FlippingCharacter: SKLabelNode {
    
    var isCurrent = false
    var positionOfCurrent = CGPoint(x: 0, y: 0)
    var slideOffSet = CGFloat(30)
    
    let fadeInAction = SKAction.group([
        SKAction.fadeAlpha(to: 1, duration: 1),
        SKAction.move(by: CGVector(dx: 0, dy: 30), duration: 1)
    ])
    
    let fadeOutAction = SKAction.group([
        SKAction.fadeAlpha(to: 0, duration: 1),
        SKAction.move(by: CGVector(dx: 0, dy: 30), duration: 1)
    ])
    
    override init() {
        super.init()
    }

    init(position: CGPoint, isCurrent: Bool) {
        super.init(fontNamed: defaultFont.main)
        
        fontSize = 100
        self.isCurrent = isCurrent
        self.positionOfCurrent = position
        
        returnToBasestates(newValue: "0")
    }
    
    func animate(newValue: String) {
        if isCurrent {
            self.run(fadeOutAction) {
                self.returnToBasestates(newValue: newValue)
            }
        }else {
            self.run(fadeInAction) {
                self.returnToBasestates(newValue: newValue)
            }
        }
    }
    
    func returnToBasestates(newValue: String) {
        self.fontColor = .white
        self.text = newValue
        if isCurrent {
            self.position = positionOfCurrent
            self.alpha = 1
            
            
        }else {
            self.position = CGPoint(x: positionOfCurrent.x, y: positionOfCurrent.y - slideOffSet)
            self.alpha = 0
        }
        removeAllActions()
        
        if let parentObj = parent as? FlippingLabel {
            if parentObj.usingQueueOnNextCompletion {
                parentObj.queueRun()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
