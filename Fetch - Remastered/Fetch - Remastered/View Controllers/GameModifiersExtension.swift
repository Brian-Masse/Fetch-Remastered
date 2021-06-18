//
//  GameModifiersExtension.swift
//  Fetch - Remastered
//
//  Created by Brian Masse on 8/4/20.
//  Copyright © 2020 Brian Masse. All rights reserved.
//

import Foundation
import UIKit


extension GameModifiersViewController {
    
//    859
    
   
    func setupRects() {
        tennisBallRect = CGRect(x: globalScene.width(c: 12), y: globalScene.width(c: 859), width: globalScene.width(c: 122), height: globalScene.width(c: 122))
        clockRect = CGRect(x: globalScene.width(c: 146), y: globalScene.width(c: 859), width: globalScene.width(c: 122), height: globalScene.width(c: 122))
        rubberBallRect = CGRect(x: globalScene.width(c: 280), y: globalScene.width(c: 859), width: globalScene.width(c: 122), height: globalScene.width(c: 122))
        diskRect = CGRect(x: globalScene.width(c: 12), y: globalScene.width(c: 993), width: globalScene.width(c: 122), height: globalScene.width(c: 122))
        lemonRect = CGRect(x: globalScene.width(c: 146), y: globalScene.width(c: 993), width: globalScene.width(c: 122), height: globalScene.width(c: 122))
        orangeRect = CGRect(x: globalScene.width(c: 280), y: globalScene.width(c: 993), width: globalScene.width(c: 122), height: globalScene.width(c: 122))
        baseBallRect = CGRect(x: globalScene.width(c: 12), y: globalScene.width(c: 1127), width: globalScene.width(c: 122), height: globalScene.width(c: 122))
        beachRect = CGRect(x: globalScene.width(c: 146), y: globalScene.width(c: 1127), width: globalScene.width(c: 122), height: globalScene.width(c: 122))
        deathRect = CGRect(x: globalScene.width(c: 280), y: globalScene.width(c: 1127), width: globalScene.width(c: 122), height: globalScene.width(c: 122))
        footBallRect = CGRect(x: globalScene.width(c: 12), y: globalScene.width(c: 1261), width: globalScene.width(c: 122), height: globalScene.width(c: 122))
        basketBallRect = CGRect(x: globalScene.width(c: 146), y: globalScene.width(c: 1261), width: globalScene.width(c: 122), height: globalScene.width(c: 122))
        moonRect = CGRect(x: globalScene.width(c: 280), y: globalScene.width(c: 1261), width: globalScene.width(c: 122), height: globalScene.width(c: 122))
        spikeRect = CGRect(x: globalScene.width(c: 12), y: globalScene.width(c: 1395), width: globalScene.width(c: 122), height: globalScene.width(c: 122))
        appleRect = CGRect(x: globalScene.width(c: 146), y: globalScene.width(c: 1395), width: globalScene.width(c: 122), height: globalScene.width(c: 122))
        discoBallRect = CGRect(x: globalScene.width(c: 280), y: globalScene.width(c: 1395), width: globalScene.width(c: 122), height: globalScene.width(c: 122))
        saturnRect = CGRect(x: globalScene.width(c: 12), y: globalScene.width(c: 1529), width: globalScene.width(c: 122), height: globalScene.width(c: 122))
        earthRect = CGRect(x: globalScene.width(c: 146), y: globalScene.width(c: 1529), width: globalScene.width(c: 122), height: globalScene.width(c: 122))
        pufferRect = CGRect(x: globalScene.width(c: 280), y: globalScene.width(c: 1529), width: globalScene.width(c: 122), height: globalScene.width(c: 122))
        rubixRect = CGRect(x: globalScene.width(c: 12), y: globalScene.width(c: 1663), width: globalScene.width(c: 122), height: globalScene.width(c: 122))
        airRect = CGRect(x: globalScene.width(c: 146), y: globalScene.width(c: 1663), width: globalScene.width(c: 122), height: globalScene.width(c: 122))
        
        mickeyRect = CGRect(x: globalScene.width(c: 12), y: globalScene.width(c: 1847), width: globalScene.width(c: 122), height: globalScene.width(c: 122))
        bullRect = CGRect(x: globalScene.width(c: 146), y: globalScene.width(c: 1847), width: globalScene.width(c: 122), height: globalScene.width(c: 122))
        poodleRect = CGRect(x: globalScene.width(c: 280), y: globalScene.width(c: 1847), width: globalScene.width(c: 122), height: globalScene.width(c: 122))
        blackRect = CGRect(x: globalScene.width(c: 12), y: globalScene.width(c: 1981), width: globalScene.width(c: 122), height: globalScene.width(c: 122))
        dalRect = CGRect(x: globalScene.width(c: 146), y: globalScene.width(c: 1981), width: globalScene.width(c: 122), height: globalScene.width(c: 122))
        houndRect = CGRect(x: globalScene.width(c: 280), y: globalScene.width(c: 1981), width: globalScene.width(c: 122), height: globalScene.width(c: 122))
        foxRect = CGRect(x: globalScene.width(c: 12), y: globalScene.width(c: 2115), width: globalScene.width(c: 122), height: globalScene.width(c: 122))
        botRect = CGRect(x: globalScene.width(c: 146), y: globalScene.width(c: 2115), width: globalScene.width(c: 122), height: globalScene.width(c: 122))
        budRect = CGRect(x: globalScene.width(c: 280), y: globalScene.width(c: 2115), width: globalScene.width(c: 122), height: globalScene.width(c: 122))
        spaceRect = CGRect(x: globalScene.width(c: 12), y: globalScene.width(c: 2249), width: globalScene.width(c: 122), height: globalScene.width(c: 122))

        
        armDayRect = CGRect(x: globalScene.width(c: 12), y: globalScene.width(c: 170), width: globalScene.width(c: 390), height: globalScene.width(c: 122))
        dynamicBallRect = CGRect(x: globalScene.width(c: 12), y: globalScene.width(c: 354), width: globalScene.width(c: 390), height: globalScene.width(c: 122))
        goldMagnetRect = CGRect(x: globalScene.width(c: 12), y: globalScene.width(c: 538), width: globalScene.width(c: 390), height: globalScene.width(c: 122))
        settingsRect = CGRect(x: globalScene.width(c: 12), y: globalScene.width(c: 672), width: globalScene.width(c: 390), height: globalScene.width(c: 122))
        titleRect = CGRect(x: globalScene.width(c: 10), y: 0, width: frame.width, height: globalScene.width(c: 100))
        titelRect2 = CGRect(x: globalScene.width(c: 10), y: globalScene.width(c: 35), width: frame.width, height: globalScene.width(c: 100))
        titelRect3 = CGRect(x: globalScene.width(c: 10), y: globalScene.width(c: 806), width: frame.width, height: globalScene.width(c: 35))
        titelRect4 = CGRect(x: globalScene.width(c: 10), y: globalScene.width(c: 1797), width: frame.width, height: globalScene.width(c: 35))
        
    }
    
    func setupButtonsInitalizers() {
        setupButtons(button: throwUpgrade, image: UIImage(named: "Game Modifiers")!, action: #selector(throwUpgradePressed), rect: armDayRect, name: "ArmDay", label: true, message: "Cost: \(Int(costs[0]))", text: costLabel, imageView: armDay)
       
        setupButtons(button: aroUpgrade, image: UIImage(named: "Game Modifiers")!, action: #selector(aroUpgradePressed), rect: dynamicBallRect, name: "DynamicBall", label: true, message: "Cost: \(Int(costs[2]))", text: costLabel2, imageView: dynamicBall)
       
        setupButtons(button: moneyUpgrade, image: UIImage(named: "Game Modifiers")!, action: #selector(moneyUpgradePressed), rect: goldMagnetRect, name: "GoldMagent", label: true, message: "Cost: \(Int(costs[1]))", text: costLabel3, imageView: goldMagnet)
        
        setupButtons(button: settings, image: UIImage(named: "Game Modifiers")!, action: #selector(settingsTaped), rect: settingsRect, name: "Settings", label: false, message: "Cost: \(Int(costs[1]))", text: costLabel3, imageView: settingsImage)
       
        setupButtons(button: mickey, image: UIImage(named: "Game Modifiers")!, action: #selector(mickeyPressed), rect: mickeyRect, name: "MickeyIcon", label: false, message: "Cost: \(Int(costs[1]))", text: costLabel3, imageView: mickeyImage)
        
        setupButtons(button: tennisBall, image: UIImage(named: "Game Modifiers")!, action: #selector(tennisBallPressed), rect: tennisBallRect, name: "TennisIcon", label: false, message: "Cost: \(Int(costs[1]))", text: costLabel3, imageView: tennisImage)
       
        setupButtons(button: rubberBall, image: UIImage(named: "Game Modifiers")!, action: #selector(rubberTapped), rect: rubberBallRect, name: "RubberIcon", label: false, message: "Cost: \(Int(costs[1]))", text: costLabel3, imageView: rubberImage)
        
        setupButtons(button: discoBall, image: UIImage(named: "Game Modifiers")!, action: #selector(discoTapped), rect: discoBallRect, name: "DiscoIcon", label: false, message: "Cost: \(Int(costs[1]))", text: costLabel3, imageView: discoImage)
        
        setupButtons(button: footBall, image: UIImage(named: "Game Modifiers")!, action: #selector(footTapped), rect: footBallRect, name: "DiscoIcon", label: false, message: "Cost: \(Int(costs[1]))", text: costLabel3, imageView: footImage)
        
        setupButtons(button: baseBall, image: UIImage(named: "Game Modifiers")!, action: #selector(baseTapped), rect: baseBallRect, name: "DiscoIcon", label: false, message: "Cost: \(Int(costs[1]))", text: costLabel3, imageView: baseImage)
        
        setupButtons(button: basketBall, image: UIImage(named: "Game Modifiers")!, action: #selector(basketTapped), rect: basketBallRect, name: "DiscoIcon", label: false, message: "Cost: \(Int(costs[1]))", text: costLabel3, imageView: basketImage)
        
        setupButtons(button: earth, image: UIImage(named: "Game Modifiers")!, action: #selector(earthTapped), rect: earthRect, name: "DiscoIcon", label: false, message: "Cost: \(Int(costs[1]))", text: costLabel3, imageView: earthImage)
        
        setupButtons(button: disk, image: UIImage(named: "Game Modifiers")!, action: #selector(diskTapped), rect: diskRect, name: "DiscoIcon", label: false, message: "Cost: \(Int(costs[1]))", text: costLabel3, imageView: diskImage)
        
        setupButtons(button: orange, image: UIImage(named: "Game Modifiers")!, action: #selector(orangeTapped), rect: orangeRect, name: "DiscoIcon", label: false, message: "Cost: \(Int(costs[1]))", text: costLabel3, imageView: orangeImage)
        
        setupButtons(button: apple, image: UIImage(named: "Game Modifiers")!, action: #selector(appleTapped), rect: appleRect, name: "DiscoIcon", label: false, message: "Cost: \(Int(costs[1]))", text: costLabel3, imageView: appleImage)
        
        setupButtons(button: lemon, image: UIImage(named: "Game Modifiers")!, action: #selector(lemonTapped), rect: lemonRect, name: "DiscoIcon", label: false, message: "Cost: \(Int(costs[1]))", text: costLabel3, imageView: lemonImage)
        
        setupButtons(button: beach, image: UIImage(named: "Game Modifiers")!, action: #selector(beachTapped), rect: beachRect, name: "DiscoIcon", label: false, message: "Cost: \(Int(costs[1]))", text: costLabel3, imageView: beachImage)
        
        setupButtons(button: death, image: UIImage(named: "Game Modifiers")!, action: #selector(deathTapped), rect: deathRect, name: "DiscoIcon", label: false, message: "Cost: \(Int(costs[1]))", text: costLabel3, imageView: deathImage)
        
        setupButtons(button: puffer, image: UIImage(named: "Game Modifiers")!, action: #selector(pufferTapped), rect: pufferRect, name: "DiscoIcon", label: false, message: "Cost: \(Int(costs[1]))", text: costLabel3, imageView: pufferImage)
        
        setupButtons(button: spike, image: UIImage(named: "Game Modifiers")!, action: #selector(spikeTapped), rect: spikeRect, name: "DiscoIcon", label: false, message: "Cost: \(Int(costs[1]))", text: costLabel3, imageView: spikeImage)
        
        setupButtons(button: clock, image: UIImage(named: "Game Modifiers")!, action: #selector(clockTapped), rect: clockRect, name: "DiscoIcon", label: false, message: "Cost: \(Int(costs[1]))", text: costLabel3, imageView: clockImage)
        
        setupButtons(button: saturn, image: UIImage(named: "Game Modifiers")!, action: #selector(saturnTapped), rect: saturnRect, name: "DiscoIcon", label: false, message: "Cost: \(Int(costs[1]))", text: costLabel3, imageView: saturnImage)
        
        setupButtons(button: moon, image: UIImage(named: "Game Modifiers")!, action: #selector(moonTapped), rect: moonRect, name: "DiscoIcon", label: false, message: "Cost: \(Int(costs[1]))", text: costLabel3, imageView: moonImage)
        
        setupButtons(button: air, image: UIImage(named: "Game Modifiers")!, action: #selector(airTapped), rect: airRect, name: "DiscoIcon", label: false, message: "Cost: \(Int(costs[1]))", text: costLabel3, imageView: airImage)
        
        setupButtons(button: rubix, image: UIImage(named: "Game Modifiers")!, action: #selector(rubixTapped), rect: rubixRect, name: "DiscoIcon", label: false, message: "Cost: \(Int(costs[1]))", text: costLabel3, imageView: rubixImage)
        
        setupButtons(button: bull, image: UIImage(named: "Game Modifiers")!, action: #selector(bullTapped), rect: bullRect, name: "DiscoIcon", label: false, message: "Cost: \(Int(costs[1]))", text: costLabel3, imageView: bullImage)
        
        setupButtons(button: poodle, image: UIImage(named: "Game Modifiers")!, action: #selector(poodleTapped), rect: poodleRect, name: "DiscoIcon", label: false, message: "Cost: \(Int(costs[1]))", text: costLabel3, imageView: poodleImage)
        
        setupButtons(button: black, image: UIImage(named: "Game Modifiers")!, action: #selector(blackTapped), rect: blackRect, name: "DiscoIcon", label: false, message: "Cost: \(Int(costs[1]))", text: costLabel3, imageView: blackImage)
        
        setupButtons(button: dal, image: UIImage(named: "Game Modifiers")!, action: #selector(dalTapped), rect: dalRect, name: "DiscoIcon", label: false, message: "Cost: \(Int(costs[1]))", text: costLabel3, imageView: dalImage)
        
        setupButtons(button: hound, image: UIImage(named: "Game Modifiers")!, action: #selector(houndTapped), rect: houndRect, name: "DiscoIcon", label: false, message: "Cost: \(Int(costs[1]))", text: costLabel3, imageView: houndImage)
        
        setupButtons(button: fox, image: UIImage(named: "Game Modifiers")!, action: #selector(foxTapped), rect: foxRect, name: "DiscoIcon", label: false, message: "Cost: \(Int(costs[1]))", text: costLabel3, imageView: foxImage)
        
        setupButtons(button: bot, image: UIImage(named: "Game Modifiers")!, action: #selector(botTapped), rect: botRect, name: "DiscoIcon", label: false, message: "Cost: \(Int(costs[1]))", text: costLabel3, imageView: botImage)
        
        setupButtons(button: bud, image: UIImage(named: "Game Modifiers")!, action: #selector(budTapped), rect: budRect, name: "DiscoIcon", label: false, message: "Cost: \(Int(costs[1]))", text: costLabel3, imageView: budImage)
        
        setupButtons(button: space, image: UIImage(named: "Game Modifiers")!, action: #selector(spaceTapped), rect: spaceRect, name: "DiscoIcon", label: false, message: "Cost: \(Int(costs[1]))", text: costLabel3, imageView: spaceImage)
        
    
       
    }
}
