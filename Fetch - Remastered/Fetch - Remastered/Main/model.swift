//
//  model.swift
//  Fetch - Remastered
//
//  Created by Brian Masse on 6/26/21.
//  Copyright © 2021 Brian Masse. All rights reserved.
//

import Foundation
import SpriteKit
import SwiftUI

struct FetchClassic {
    var rubberBall  = Ball(skin: "Rubber", shouldStretch: true, cost: 0, mouth: 19)
    let clock       = Ball(skin: "Clock", shouldStretch: false, cost: 50, mouth: 20)
    let tennisBall  = Ball(skin: "Tennis", shouldStretch: true, cost: 100, mouth: 22)
    let disk        = Ball(skin: "Disk", shouldStretch: true, cost: 100, mouth: 25)
    let lemon       = Ball(skin: "Lemon", shouldStretch: false, cost: 500, mouth: 27, scale: 0.9)
    let orange      = Ball(skin: "Orange", shouldStretch: true, cost: 500, mouth: 24)
    let baseBall    = Ball(skin: "Base", shouldStretch: true, cost: 500, mouth: 19, scale: 0.9)
    let beachBall   = Ball(skin: "Beach", shouldStretch: true, cost: 700, mouth: 19, scale: 1.8)
    let deathStar   = Ball(skin: "Death", shouldStretch: false, cost: 700, mouth: 30)
    let footBall    = Ball(skin: "Foot", shouldStretch: true, cost: 1000, mouth: 37, scale: 0.9)
    let basketBall  = Ball(skin: "Basket", shouldStretch: true, cost: 2000, mouth: 19, scale: 1.8)
    let moon        = Ball(skin: "Moon", shouldStretch: false, cost: 4000, mouth: 20)
    let spikeBall   = Ball(skin: "Spike", shouldStretch: true, cost: 9000, mouth: 27)
    let apple       = Ball(skin: "Apple", shouldStretch: false, cost: 100000, mouth: 20)
    let disco       = Ball(skin: "Disco", shouldStretch: true, cost: 200000, mouth: 24)
    let saturn      = Ball(skin: "Saturn", shouldStretch: false, cost: 500000, mouth: 27)
    let earth       = Ball(skin: "Earth", shouldStretch: true, cost: 1000000, mouth: 19)
    let puffer      = Ball(skin: "Puffer", shouldStretch: true, cost: 2000000, mouth: 23)
    let rubix       = Ball(skin: "Rubix", shouldStretch: true, cost: 3000000, mouth: 25)
    let air         = Ball(skin: "Air", shouldStretch: false, cost: 9999999, mouth: 30)
    
    let mickey      = Dog(skin: "Mickey", cost: 0, mouth: CGPoint(x: 13, y: 26))
    let space       = Dog(skin: "Space", cost: 100, mouth: CGPoint(x: 17, y: 28))
    let bud         = Dog(skin: "Bud", cost: 200, mouth: CGPoint(x: 14, y: 27))
    let fox         = Dog(skin: "Fox", cost: 10000, mouth: CGPoint(x: 13, y: 23))
    let hound       = Dog(skin: "Hound", cost: 1000000, mouth: CGPoint(x: 17, y: 29))
    let black       = Dog(skin: "Black", cost: 400000, mouth: CGPoint(x: 18, y: 30))
    let poddle      = Dog(skin: "Poodle", cost: 90000, mouth: CGPoint(x: 20, y: 40))
    let bull        = Dog(skin: "Bull", cost: 90000, mouth: CGPoint(x: 13, y: 25))
    let dal         = Dog(skin: "Dal", cost: 90000, mouth: CGPoint(x: 22, y: 42))
    let bot         = Dog(skin: "Bot", cost: 90000, mouth: CGPoint(x: 12, y: 26))
    
    var throwModifier = ThrowModifier()
    var aeroModifier = AeroModifier()
    var goldModifier = GoldModifier()
    
    var modifiers: [Upgradable] = []
    
    //MARK: States
    var currentState: StateEnum = .home
    enum StateEnum {
        case home
        case throwing
        case throwOver
        case caught
        case returning
        case returningPT2
    }

    
    //MARK: Current Dogs and Balls
    var currentBall: CurrentBall!
    var currentDog: CurrentDog!
    
    var dogs: [Dog] {
        didSet { currentDog.type = determineCurrentObjects().0 }
    }
    var balls: [Ball] {
        didSet { currentBall.type = determineCurrentObjects().1 }
    }
    
    //MARK: Modifiers:
    
    struct ThrowModifier: Upgradable {
        let id = "throw"
        var value: CGFloat = 1
        let maxValue: CGFloat = 1000
        var maxxed = false
        
        var title = "Arm Day"
        var description: String { "x \(value) on all throWs!" }
        var buttonText: String { "+ \(returnCurrentIncriment()) for \(returnCurrentPrice()) gold!" }
        func saveSelf() { }
        
        var iteration = 0
        func returnCurrentPrice() -> Int { (iteration * 3) + 5 }
        func returnCurrentIncriment() -> CGFloat { (CGFloat(iteration) * 2) + 1 }
        
        let shadowColor = UpgradesSheet.constants.throwShadowGreen
        let baseColor = UpgradesSheet.constants.throwGreen
        
    }
    
    struct AeroModifier: Upgradable {
        let id = "aero"
        var value: CGFloat = 0
        let maxValue: CGFloat = 4.5
        var friction: CGFloat { 5 - value }
        var maxxed = false
        
        let title = "Aero-Dynamics:"
        var description: String { "\(Int(value * 100)) % slow reduction!" }
        var buttonText: String { "+ \(Int(returnCurrentIncriment().trimCGFloat(2) * 100)) % for \(returnCurrentPrice()) gold!" }
        func saveSelf() { GameView.game.updateAeroModifier() }
        
        var iteration = 0
        func returnCurrentPrice() -> Int { (iteration * 3) + 5 }
        func returnCurrentIncriment() -> CGFloat { (CGFloat(iteration) * 0.02) + 0.01 }
        
        let shadowColor = UpgradesSheet.constants.aeroShadowPink
        let baseColor = UpgradesSheet.constants.aeroPink
        
    }
    
    struct GoldModifier: Upgradable {
        let id = "gold"
        var value: CGFloat = 1
        let maxValue: CGFloat = 100
        var maxxed = false
        
        var title = "Gold Magnet"
        var description: String { "\(value.trimCGFloat(2)) % chance of gold every yard!" }
        var buttonText: String { "+ \(returnCurrentIncriment().trimCGFloat(2))% for \(returnCurrentPrice()) gold!" }
        func saveSelf() { }
        
        var iteration = 0
        func returnCurrentPrice() -> Int { (iteration * 3) + 5 }
        func returnCurrentIncriment() -> CGFloat { (CGFloat(iteration) * 0.2) + 0.2 }
        
        let shadowColor = UpgradesSheet.constants.goldShadowTangerine
        let baseColor = UpgradesSheet.constants.goldTengerine
    }
    
    //MARK: gold
    
    @Graphable(0, for: "goldKey") var gold: CGFloat
    var previousGold: Int = 0
    
    var speed = 1
    
    var stats = Stats()
    
    
    @Graphable(0, for: "testKey") var testGraph: CGFloat
    
    
    //MARK: init
    
    init() {
        modifiers = [throwModifier, aeroModifier, goldModifier]
        dogs = [ mickey, space, bud, fox, hound, black, poddle, bull, dal, bot ]
        balls = [ rubberBall, tennisBall, clock, disk, lemon, orange, baseBall, beachBall, deathStar, footBall, basketBall, moon, spikeBall, apple, disco, saturn, earth, puffer, rubix, air ]

        loadDogsAndBalls(in: &dogs)
        loadDogsAndBalls(in: &balls)

        for dog in dogs { if dog.isCurrent { currentDog = CurrentDog(dog: dog) } }
        for ball in balls { if ball.isCurrent { currentBall = CurrentBall(ball: ball) } }
        
        if currentDog == nil {
            currentDog = CurrentDog(dog: dogs[0])
            dogs[0].isCurrent = true
        }
        if currentBall == nil {
            currentBall = CurrentBall(ball: balls[0])
            balls[0].isCurrent = true
        }
        
        for enumeration in modifiers.enumerated() {
            modifiers[enumeration.offset].value = FetchClassic.retrieveData(defaultValue: CGFloat(0), for: enumeration.element.id + "value")
            modifiers[enumeration.offset].iteration = FetchClassic.retrieveData(defaultValue: 0, for: enumeration.element.id + "iteration")
            modifiers[enumeration.offset].maxxed = FetchClassic.retrieveData(defaultValue: false, for: enumeration.element.id + "maxxed")
        }
        updateAeroModifier()
        
        gold = FetchClassic.retrieveData(defaultValue: 0, for: "gold")
        previousGold = FetchClassic.retrieveData(defaultValue: 0, for: "gold")
        
//        defaults.removeObject(forKey: "aerovalue")
//        defaults.removeObject(forKey: "aeromaxxed")
//        defaults.removeObject(forKey: "aeroiteration")
        
//        defaults.removeObject(forKey: "throwiteration")
//        defaults.removeObject(forKey: "throwvalue")
//        defaults.removeObject(forKey: "throwmaxxed")
    }

    //MARK: Save Functions
    
    static func saveData<DataType>(data: DataType, for key: String) {
        defaults.setValue(data, forKey: key)
    }
    
    static func retrieveData<DataType>(defaultValue: DataType, for key: String) -> DataType {
        guard let value = defaults.value(forKey: key) as? DataType else {return defaultValue}
        return value
    }
    
    static func saveComplexData<DataType>(data: DataType, for key: String) where DataType: Codable {
        let encodedData = try! JSONEncoder().encode(data)
        defaults.setValue(encodedData, forKey: key)
    }

    static func retrieveComplexData<DataType>(defaultValue: DataType, for key: String) ->  DataType where DataType: Codable {
        guard let retrievedData = defaults.value(forKey: key) as? Data else { return defaultValue}
        let decodedData = try! JSONDecoder().decode(DataType.self, from: retrievedData)
        return decodedData

    }
    
    func loadDogsAndBalls<objectType: gameObject>(in list: inout [objectType])  {
        for index in list.indices {
            loadObjects(object: &list[index])
        }
        func loadObjects(object: inout objectType) {
            if let dummyObjectData = defaults.value(forKey:"\(object.id)") as? Data {
                guard let dummyObject = try? JSONDecoder().decode(objectType.self, from: dummyObjectData) else { return }
                object.isCurrent = dummyObject.isCurrent
                object.isUnlocked = dummyObject.isUnlocked
            }
        }
    }
    
    func determineCurrentObjects() -> (Dog, Ball) {
        var currentDog: Dog!
        var currentBall: Ball!
        for dog in dogs {
            if dog.isCurrent { currentDog = dog}
        }
        for ball in balls {
            if ball.isCurrent { currentBall = ball}
        }
        return (currentDog, currentBall)
    }
    
    
    //MARK: Intent Functions
    
    mutating func changeState(_ newState: StateEnum) {
        currentState = newState
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0001) { [self] in
            switch newState {
            case .home:
                currentDog.zPosition = 100
                currentDog.position.y = currentBall.frame.minY - (currentDog.size.height / 2)
            case .throwing: globalScene.updateVelocityLabel()
            case .throwOver:
                globalScene.speed = 1
                currentBall.removeAllActions()
                currentBall.defineTextureAndSize()
                globalScene.checkForGold(distance: Int(currentBall.position.y))
                velocityLabel?.update(newAmount: 0.00, usingQueue: true, speed: 1)
            case .caught:
                globalScene.holdBall()
            case .returning:
                currentBall.beingHeld = false
                currentBall.position = CGPoint(x: 0, y: 500)
                let halfBallHeight = (currentBall.size.height / 2)
                currentDog.position.y = (500 + (currentDog.size.height / 2)) - (currentBall.type.mouthPos * pixelSize) + halfBallHeight
                currentDog.zPosition = 102
            default: break
            }
        }
    }
    
    mutating func updateAeroModifier() {
        guard let index = modifiers.firstIndex(where: {$0.id == "aero" }) else { return }
        currentBall.physicsBody!.linearDamping = (modifiers[index] as! AeroModifier).friction
    }
    
    mutating func changeGold(change: CGFloat) {
        previousGold = Int(gold)
        gold += change
    }
    
    mutating func changeGameSpeed(change: Int) {
        speed = change
        globalScene.speed = CGFloat(speed)
    }
    
    mutating func incrementModifier(_ modifier: Upgradable, with increment: CGFloat) {
        guard let index = modifiers.firstIndex(where: {$0.id == modifier.id }) else { return }
        modifiers[index].value = min(modifiers[index].value + increment, modifiers[index].maxValue)
        modifiers[index].iteration += 1
        if modifiers[index].value >= modifiers[index].maxValue {modifiers[index].maxxed = true; FetchClassic.saveData(data: modifiers[index].maxxed, for: modifiers[index].id + "maxxed") }
    }

    mutating func chooseActiveObjects<objectType: gameObject>(newObject: objectType, in list: inout [objectType]) {
        for enumeration in list.enumerated() {
            if enumeration.element == newObject {
                list[enumeration.offset].isCurrent = true
                list[enumeration.offset].isUnlocked = true
            }else { list[enumeration.offset].isCurrent = false }
            guard let encodedData = try? JSONEncoder().encode(list[enumeration.offset]) else { return }
            FetchClassic.saveData(data: encodedData, for: "\(enumeration.element.id)")
        }
    }
}
