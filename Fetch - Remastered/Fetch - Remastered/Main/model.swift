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
import WidgetKit

struct FetchClassic {
    var rubberBall  = Ball(skin: "Rubber", shouldStretch: true, cost: 0, mouth: 19, flipRoll: false)
    var clock       = Ball(skin: "Clock", shouldStretch: false, cost: 2000, mouth: 20, flipRoll: false)
    var tennisBall  = Ball(skin: "Tennis", shouldStretch: true, cost: 100, mouth: 22, flipRoll: false)
    var disk        = Ball(skin: "Disk", shouldStretch: true, cost: 8000, mouth: 25, flipRoll: false)
    var lemon       = Ball(skin: "Lemon", shouldStretch: false, cost: 70000, mouth: 27, scale: 0.9, flipRoll: true)
    var orange      = Ball(skin: "Orange", shouldStretch: true, cost: 20000, mouth: 24, flipRoll: true)
    var baseBall    = Ball(skin: "Base", shouldStretch: true, cost: 300000, mouth: 19, scale: 0.9, flipRoll: true)
    var beachBall   = Ball(skin: "Beach", shouldStretch: true, cost: 1000, mouth: 19, scale: 1.8, flipRoll: true)
    var deathStar   = Ball(skin: "Death", shouldStretch: false, cost: 1000000, mouth: 30, flipRoll: true)
    var footBall    = Ball(skin: "Foot", shouldStretch: true, cost: 5000, mouth: 37, scale: 0.9, flipRoll: false)
    var basketBall  = Ball(skin: "Basket", shouldStretch: true, cost: 100000, mouth: 19, scale: 1.8, flipRoll: true)
    var moon        = Ball(skin: "Moon", shouldStretch: false, cost: 800000, mouth: 20, flipRoll: true)
    var spikeBall   = Ball(skin: "Spike", shouldStretch: true, cost: 200000, mouth: 27, flipRoll: true)
    var apple       = Ball(skin: "Apple", shouldStretch: false, cost: 40000, mouth: 20, flipRoll: true)
    var disco       = Ball(skin: "Disco", shouldStretch: true, cost: 3000000, mouth: 24, flipRoll: false)
    var saturn      = Ball(skin: "Saturn", shouldStretch: false, cost: 5000000, mouth: 27, flipRoll: true)
    var earth       = Ball(skin: "Earth", shouldStretch: true, cost: 10000000, mouth: 19, flipRoll: true)
    var puffer      = Ball(skin: "Puffer", shouldStretch: true, cost: 99000000, mouth: 23, flipRoll: true)
    var rubix       = Ball(skin: "Rubix", shouldStretch: true, cost: 500000, mouth: 25, flipRoll: true)
    var air         = Ball(skin: "Air", shouldStretch: false, cost: 50000000, mouth: 30, flipRoll: false)
    
    var mickey      = Dog(skin: "Mickey", cost: 0, mouth: CGPoint(x: 13, y: 26))
    var space       = Dog(skin: "Space", cost: 99000000, mouth: CGPoint(x: 19, y: 28))
    var bud         = Dog(skin: "Bud", cost: 1000, mouth: CGPoint(x: 14, y: 27))
    var fox         = Dog(skin: "Fox", cost: 1000000, mouth: CGPoint(x: 13, y: 23))
    var hound       = Dog(skin: "Hound", cost: 10000000, mouth: CGPoint(x: 17, y: 29))
    var black       = Dog(skin: "Black", cost: 20000, mouth: CGPoint(x: 18, y: 30))
    var poddle      = Dog(skin: "Poodle", cost: 100000, mouth: CGPoint(x: 20, y: 40))
    var bull        = Dog(skin: "Bull", cost: 500000, mouth: CGPoint(x: 13, y: 25))
    var dal         = Dog(skin: "Dal", cost: 70000, mouth: CGPoint(x: 22, y: 42))
    var bot         = Dog(skin: "Bot", cost: 5000000, mouth: CGPoint(x: 12, y: 26))
    
    let defaultDog = 0
    let defaultBall = 0
    
    var throwModifier = ThrowModifier()
    var aeroModifier = AeroModifier()
    var goldModifier = GoldModifier()
//
    var modifiers: [Upgradable] = []
    
    //MARK: States
    private(set) var currentState: StateEnum = .home
    var masterState: StateEnum = .home
    
    enum StateEnum {
        case home
        case map
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
        didSet { currentDog.type = determineCurrentObjects().0 ?? dogs[defaultDog]; sendDataToWidgets() }
    }
    var balls: [Ball] {
        didSet { currentBall.type = determineCurrentObjects().1 ?? balls[defaultBall]; sendDataToWidgets()}
    }
    
    func sendDataToWidgets() {
        guard let currentDog = determineCurrentObjects().0 else { return }
        guard let currentBall = determineCurrentObjects().1 else { return }
        for data in GameView.game.stats.updatingWidgetDataList {
            if data.dataType == WidgetData.DataType.dog && data.accessorIndex == -1  {
                WidgetAcessor.saveData(data: currentDog.skin, for: data.key)
            }
            if data.dataType == WidgetData.DataType.ball && data.accessorIndex == -1 {
                WidgetAcessor.saveData(data: currentBall.skin+"1", for: data.key)
            }
            
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    func sendAllDataToWidgets() {
        for enumeration in dogs.enumerated() {
            WidgetAcessor.saveData(data: enumeration.element.skin, for: "\(WidgetData.DataType.dog.rawValue)\(enumeration.offset)")
            WidgetAcessor.saveData(data: enumeration.element.skin, for: "\(WidgetData.DataType.dog.rawValue)\(enumeration.offset)1")
        }
        for enumeration in balls.enumerated() {
            WidgetAcessor.saveData(data: enumeration.element.skin+"1", for: "\(WidgetData.DataType.ball.rawValue)\(enumeration.offset)")
            WidgetAcessor.saveData(data: enumeration.element.skin+"1", for: "\(WidgetData.DataType.ball.rawValue)\(enumeration.offset)1")
        }
    }
    
    //MARK: Modifiers:
    
    static func logC(ofBase base: CGFloat, _ value: CGFloat) -> CGFloat {
        return log(value) / log(base)
    }
    
    struct Progression {
        static let maxGold: CGFloat = 50000
        static let avgGold: CGFloat = 38101
        
        static let k = ( 3 * maxGold * logC(ofBase: M_E, ( (maxGold/0.1)-1)) ) / ( avgGold * (30 * 10 * 3) )
        static let a = -logC(ofBase: M_E, ((maxGold / (maxGold - 10)) - 1)) / k
        
        static func returnGoldPrice(_ iteration: Int) -> CGFloat {
            maxGold / (1 + pow(M_E, -k * ( CGFloat(iteration) - a )))
        }
        
        static func returnUpgrade( startingAt start: CGFloat, max: CGFloat) -> CGFloat {
            (max - start) / (2 * a)
        }
    }
    
    struct ThrowModifier: Upgradable {
        let accessor: Stats.SubscriptAcessor = .throwModifier
        static let defaultValue: CGFloat = 50
        var iteration = 0
        var value: CGFloat {
            get { GameView.game.stats[.throwModifier] }
            set { GameView.game.stats[.throwModifier] = newValue}
        }
        let maxValue: CGFloat = 1000
        var maxxed = false
        
        var id = "throw"
        var title = "Arm Day"
        var description: String { "x \(value.trimCGFloat(2)) on all \nthroWs!" }
        var buttonText: String { "+ \(returnCurrentIncriment().trimCGFloat(2)) for \(returnCurrentPrice()) gold!" }
        func saveSelf() { }
    
        func returnCurrentPrice() -> Int { Int(FetchClassic.Progression.returnGoldPrice(iteration)) }
        func returnCurrentIncriment() -> CGFloat { FetchClassic.Progression.returnUpgrade(startingAt: ThrowModifier.defaultValue, max: maxValue)}
        
        let darkShadow = Colors.upgradesThrowDarkColor
        let lightFontColor = Colors.upgradesThrowLightColor
        let lightShadow = Colors.upgradesThrowLightShadow
    }
    
    class AeroModifier: Upgradable {
        let accessor: Stats.SubscriptAcessor = .aeroModifier
        static let defaultValue: CGFloat = 0
        var iteration = 0
        var value: CGFloat {
            get { GameView.game.stats[.aeroModifier] }
            set { GameView.game.stats[.aeroModifier] = newValue }
        }
        let maxValue: CGFloat = 4.5
        var maxxed = false
        var friction: CGFloat { 5 - value }

        let id = "aero"
        let title = "Aero-Dynamics:"
        var description: String { "\((value * 100).trimCGFloat(2)) % slow \nreduction!" }
        var buttonText: String { "+ \((returnCurrentIncriment() * 100).trimCGFloat(2)) % for \(returnCurrentPrice()) gold!" }
        func saveSelf() { GameView.game.updateAeroModifier() }

        func returnCurrentPrice() -> Int { Int(FetchClassic.Progression.returnGoldPrice(iteration)) }
        func returnCurrentIncriment() -> CGFloat { FetchClassic.Progression.returnUpgrade(startingAt: AeroModifier.defaultValue, max: maxValue) }

        let darkShadow = Colors.upgradesAeroDarkColor
        let lightFontColor = Colors.cosmeticsLightColor
        let lightShadow = Colors.cosmeticsLighShadow

    }

    class GoldModifier: Upgradable {
        let accessor: Stats.SubscriptAcessor = .goldModifier
        static let defaultValue: CGFloat = 1
        var iteration = 0
        var value: CGFloat {
            get { GameView.game.stats[.goldModifier] }
            set { GameView.game.stats[.goldModifier] = newValue }
        }
        let maxValue: CGFloat = 100
        var maxxed = false

        let id = "gold"
        var title = "Gold Magnet"
        var description: String { "\(value.trimCGFloat(2)) % chance of \ngold every yard!" }
        var buttonText: String { "+ \(returnCurrentIncriment().trimCGFloat(2))% for \(returnCurrentPrice()) gold!" }
        func saveSelf() { }
        
        func returnCurrentPrice() -> Int { Int(FetchClassic.Progression.returnGoldPrice(iteration)) }
        func returnCurrentIncriment() -> CGFloat { FetchClassic.Progression.returnUpgrade(startingAt: GoldModifier.defaultValue, max: maxValue) }

        let darkShadow = Colors.upgradesGoldDarkColor
        let lightFontColor = Colors.upgradesGoldLightColor
        let lightShadow = Colors.upgradesGoldLightShadow
    }
    
    //MARK: Legacy Data:
    var askedAboutMerging = false

    var gold: CGFloat = 0 {
        willSet { stats[.gold] = newValue }
    }
    
    var stats = Stats()
    
    //MARK: init
    
    init() {
        modifiers = [throwModifier, aeroModifier, goldModifier]
        dogs = [ mickey, space, bud, fox, hound, black, poddle, bull, dal, bot ]
        balls = [ rubberBall, tennisBall, beachBall, disk, clock, footBall, orange, apple, lemon, basketBall, spikeBall, baseBall, rubix, moon, deathStar, disco, saturn, earth, air, puffer ]

        loadDogsAndBalls(in: &dogs)
        loadDogsAndBalls(in: &balls)

//        for dog in dogs { if dog.isCurrent { currentDog = CurrentDog(dog: dog) } }
//        for ball in balls { if ball.isCurrent { currentBall = CurrentBall(ball: ball) } }
        
        let currentDogIndex = dogs.firstIndex(where: { $0.isCurrent }) ?? defaultDog
        dogs[currentDogIndex].isCurrent = true
        currentDog = CurrentDog(dog: dogs[ currentDogIndex ] )
        
        let currentBallIndex = balls.firstIndex(where: { $0.isCurrent }) ?? defaultBall
        balls[currentBallIndex].isCurrent = true
        currentBall = CurrentBall(ball: balls[ currentBallIndex ] )
     
        gold = stats[.gold]
        
        for enumeration in modifiers.enumerated() {
            modifiers[enumeration.offset].iteration = FetchClassic.retrieveData(defaultValue: 0, for: enumeration.element.id + "iteration")
            modifiers[enumeration.offset].maxxed = FetchClassic.retrieveData(defaultValue: false, for: enumeration.element.id + "maxxed")
        }
        
        askedAboutMerging = FetchClassic.retrieveData(defaultValue: false, for: "askedAboutMerging")
        
    }

    mutating func setupLists() {
        dogs = [ mickey, space, bud, fox, hound, black, poddle, bull, dal, bot ]
        balls = [ rubberBall, tennisBall, beachBall, disk, clock, footBall, orange, apple, lemon, basketBall, spikeBall, baseBall, rubix, moon, deathStar, disco, saturn, earth, air, puffer ]
    }
    
    //MARK: Save Functions
    
    static func saveData<testType>(data: testType, for key: String) {
        defaults.setValue(data, forKey: key)
    }
    
    static func retrieveData<testType>(defaultValue: testType, for key: String) -> testType {
        guard let value = defaults.value(forKey: key) as? testType else {return defaultValue}
        return value
    }
    
    static func saveComplexData<testType>(data: testType, for key: String) where testType: Codable {
        let encodedData = try! JSONEncoder().encode(data)
        defaults.setValue(encodedData, forKey: key)
    }

    static func retrieveComplexData<testType>(defaultValue: testType, for key: String) ->  testType where testType: Codable {
        guard let retrievedData = defaults.value(forKey: key) as? Data else { return defaultValue}
        let decodedData = try! JSONDecoder().decode(testType.self, from: retrievedData)
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
    
    func determineCurrentObjects() -> (Dog?, Ball?) {
        var currentDog: Dog?
        var currentBall: Ball?
        
        for dog in dogs { if dog.isCurrent { currentDog = dog} }
        for ball in balls { if ball.isCurrent { currentBall = ball} }
        return (currentDog, currentBall)
    }
    
    
    //MARK: Intent Functions
    
    mutating func changeState(_ newState: StateEnum) {
        currentState = newState
        
        //captures self so that cahnges may be made externally
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0001) { [self] in
            switch newState {
            case .home:
                currentDog.zPosition = GameScene.ZLayer.belowBall.rawValue
                currentDog.position.y = currentBall.frame.minY - (currentDog.size.height / 2)
                
            case .throwing:
//                globalScene.updateVelocityLabel()
//                globalScene.toggleSpeedLines()
                GameView.game.updateStatsAtStartOfThrow()
                
            case .throwOver:
//                globalScene.toggleSpeedLines()
                globalScene.speed = 1
                currentBall.removeAllActions()
                currentBall.defineTextureAndSize()
                globalScene.checkForGold(distance: Int(currentBall.position.y))
                GameView.game.updateStatsAtEndOfThrow()
                
            case .caught:
//                globalScene.removeVeclocityLabel()
                globalScene.holdBall()
                
            case .returning:
                currentBall.beingHeld = false
                currentBall.position.x = 0
                let halfBallHeight = (currentBall.size.height / 2)
                currentBall.position.y = 500
                currentDog.position.y = (currentBall.position.y + (currentDog.size.height / 2)) - (currentBall.type.mouthPos * pixelSize) + halfBallHeight
                currentDog.zPosition = GameScene.ZLayer.aboveBall.rawValue
                
            default: break
            }
        }
        // does not capture self, so self can be mtuated
        switch newState {
        case.home: masterState = .home
        case .throwing: masterState = .throwing
        case .caught: masterState = .throwOver
        case .returning: masterState = .returning
        default: break
        }
    }
    
    mutating func updateAeroModifier() {
        guard let index = modifiers.firstIndex(where: {$0.id == "aero" }) else { return }
        currentBall.physicsBody!.linearDamping = (modifiers[index] as! AeroModifier).friction
    }
    
    mutating func changeGold(change: CGFloat) {
        gold += CGFloat(change.rounded())
        if gold > stats[.mostGold] { stats[.mostGold] = gold }
        if change < -stats[.biggestPruchase] { stats[.biggestPruchase] = -change }
    }
    
    mutating func setGold(with newValue: CGFloat) {
        gold = newValue
    }
    
    mutating func incrementModifier(_ modifier: Upgradable, with increment: CGFloat) {
        
        guard let index = modifiers.firstIndex(where: {$0.id == modifier.id }) else { return }
        
//        mutatingModifier.value = min( mutatingModifier.value + increment, mutatingModifier.maxValue )
//        mutatingModifier.iteration += 1
//        if mutatingModifier.value >= mutatingModifier.maxValue { mutatingModifier.maxxed = true; FetchClassic.saveData(data: mutatingModifier.maxxed, for: mutatingModifier.id + "maxxed") }
    
        modifiers[index].value = min(modifiers[index].value + increment, modifiers[index].maxValue)
        modifiers[index].iteration += 1
        if modifiers[index].value >= modifiers[index].maxValue {modifiers[index].maxxed = true; FetchClassic.saveData(data: modifiers[index].maxxed, for: modifiers[index].id + "maxxed") }
    }
    
    mutating func chooseActiveObjects<objectType: gameObject>(newObject: objectType, in list: inout [objectType]) {
        for enumeration in list.enumerated() {
            if enumeration.element == newObject {
                list[enumeration.offset].isCurrent = true
            }else { list[enumeration.offset].isCurrent = false }
            guard let encodedData = try? JSONEncoder().encode(list[enumeration.offset]) else { return }
            FetchClassic.saveData(data: encodedData, for: "\(enumeration.element.id)")
        }
    }
    
    mutating func mergeLegacyUnlocks() {
        rubberBall.isUnlocked = FetchClassic.retrieveData(defaultValue: true, for: "rubberBallLock")
        disco.isUnlocked =      FetchClassic.retrieveData(defaultValue: false, for: "discoBallLock")
        footBall.isUnlocked =   FetchClassic.retrieveData(defaultValue: false, for: "footBallLock")
        baseBall.isUnlocked =   FetchClassic.retrieveData(defaultValue: false, for: "baseBallLock")
        basketBall.isUnlocked = FetchClassic.retrieveData(defaultValue: false, for: "basketBallLock")
        earth.isUnlocked =      FetchClassic.retrieveData(defaultValue: false, for: "earthLock")
        disk.isUnlocked =       FetchClassic.retrieveData(defaultValue: false, for: "diskLock")
        orange.isUnlocked =     FetchClassic.retrieveData(defaultValue: false, for: "orangeLock")
        apple.isUnlocked =      FetchClassic.retrieveData(defaultValue: false, for: "appleLock")
        lemon.isUnlocked =      FetchClassic.retrieveData(defaultValue: false, for: "lemonLock")
        beachBall.isUnlocked =  FetchClassic.retrieveData(defaultValue: false, for: "beachLock")
        deathStar.isUnlocked =  FetchClassic.retrieveData(defaultValue: false, for: "deathLock")
        puffer.isUnlocked =     FetchClassic.retrieveData(defaultValue: false, for: "pufferLock")
        spikeBall.isUnlocked =  FetchClassic.retrieveData(defaultValue: false, for: "spikeLock")
        clock.isUnlocked =      FetchClassic.retrieveData(defaultValue: false, for: "clockLock")
        saturn.isUnlocked =     FetchClassic.retrieveData(defaultValue: false, for: "saturnLock")
        moon.isUnlocked =       FetchClassic.retrieveData(defaultValue: false, for: "moonLock")
        air.isUnlocked =        FetchClassic.retrieveData(defaultValue: false, for: "airLock")
        rubix.isUnlocked =      FetchClassic.retrieveData(defaultValue: false, for: "rubixLock")

        mickey.isUnlocked =     FetchClassic.retrieveData(defaultValue: true, for: "MickeyLock")
        bull.isUnlocked =       FetchClassic.retrieveData(defaultValue: false, for: "bullLock")
        poddle.isUnlocked =     FetchClassic.retrieveData(defaultValue: false, for: "poodleLock")
        black.isUnlocked =      FetchClassic.retrieveData(defaultValue: false, for: "blackLock")
        dal.isUnlocked =        FetchClassic.retrieveData(defaultValue: false, for: "dalLock")
        hound.isUnlocked =      FetchClassic.retrieveData(defaultValue: false, for: "houndLock")
        fox.isUnlocked =        FetchClassic.retrieveData(defaultValue: false, for: "foxLock")
        bot.isUnlocked =        FetchClassic.retrieveData(defaultValue: false, for: "botLock")
        bud.isUnlocked =        FetchClassic.retrieveData(defaultValue: false, for: "budLock")
        space.isUnlocked =      FetchClassic.retrieveData(defaultValue: false, for: "spaceLock")
    }
}


