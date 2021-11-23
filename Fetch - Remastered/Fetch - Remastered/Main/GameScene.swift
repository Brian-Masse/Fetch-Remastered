//
//  GameScene.swift
//  Fetch - Remastered
//
//  Created by Brian Masse on 7/30/20.
//  Copyright © 2020 Brian Masse. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation
import SwiftUI
import Combine


class GameScene: SKScene {
    
//    var swipeList = Array([CGPoint()])
    var UI = Array([SKSpriteNode()])
    var ballFrames = [SKTexture]()
    var runFrames = [SKTexture]()
    var sitFrames = [SKTexture]()
    var cloudAnchor = SKSpriteNode(color: .red, size: CGSize(width: 0, height: 0))
    var clouds = [SKEmitterNode()]
    var lights = Array<SKLightNode>()
     
    var goldCount = CGFloat(1000)
    var distance = CGFloat(0)
//    var swipeCounter = CGFloat(0)
    var initGold = CGFloat(0)
    var Probability = CGFloat(200)
    var mostGold = CGFloat(0)
    var farthestThrow = CGFloat(0)
    var heightMod = CGFloat(1)
    var discoveredPerc = CGFloat(0)
    var addedGold = CGFloat(0)
    
//    var swipe = false
    var throwing = false
    var throwComplete = false
    var dogRotate = false
    var cloudsOff = false
    var soundOff = false
    var tutorialComplete = false
    var throwisReady = false
    var throwisReady2 = true
    
    var ball = SKSpriteNode(color: UIColor.red, size: CGSize(width: 50, height: 50))
    let dog = SKSpriteNode(color: .orange, size: CGSize(width: 50, height: 50))
    var tick = SKSpriteNode(color: UIColor.gray, size: CGSize(width: 30, height: 10))
    
    let ballLight = SKLightNode()
    let background = SKSpriteNode(color: UIColor.red, size: CGSize(width: 414, height: 71516.25))
    let background2 = SKSpriteNode(color: UIColor.red, size: CGSize(width: 414, height: 71516.25))
    let background3 = SKSpriteNode(color: UIColor.red, size: CGSize(width: 414, height: 71516.25))
    let backGrad = SKSpriteNode()
    let backGrad2 = SKSpriteNode()
    
    let GameModifiersButton = SKSpriteNode(color: .green, size: CGSize(width: 122, height: 122))
    let profileButton = SKSpriteNode(color: .green, size: CGSize(width: 122, height: 122))
    let GoldButton = SKSpriteNode(color: .green, size: CGSize(width: 122, height: 122))
    let hiddenButton = SKSpriteNode(color: UIColor(red: 1, green: 1, blue: 1, alpha: 0), size: CGSize(width: 1, height: 1))
    let hiddenButton2 = SKSpriteNode(color: UIColor(red: 1, green: 1, blue: 1, alpha: 0), size: CGSize(width: 1, height: 1))
    let hiddenButton3 = SKSpriteNode(color: UIColor(red: 1, green: 1, blue: 1, alpha: 0), size: CGSize(width: 1, height: 1))
    let header = SKSpriteNode(color: .green, size: CGSize(width: 0 , height: 0))
    let header2 = SKSpriteNode(color: .green, size: CGSize(width: 0 , height: 0))
    let returnButton = SKSpriteNode(color: .green, size: CGSize(width: 0 , height: 0))
    let audioPlayer = SKAudioNode(fileNamed: "gold1")
    let audioPlayer2 = SKAudioNode(fileNamed: "gold1")
    var currentSlide = SKSpriteNode(texture: SKTexture(imageNamed: "welcome"))
    
    var cameraObject = SKCameraNode()
//    var velocityLabel = SKLabelNode(text: "Velocity: ")
    var goldLabel = SKLabelNode(text: "Gold: ")
    var distanceLabel = SKLabelNode(text: "Gold: ")
    var addedGoldLabel = SKLabelNode(text: "")
    
    let savedGoldKey = "SavedGold"
    let savedModifierKey = "SavedModifier"
    let ProbabilityKey = "SavedProbability"
    let mostGoldKey = "mostGold"
    let farthestThrowKey = "farthestThrow"
    let frictionKey = "friction"
    let ballKey = "ballKey"
    let dogKey = "dogKey"
    let cloudKey = "cloudKey"
    let soundKey = "soundKey"
    let discoveredKey = "Discovered"
    let tutorialKey = "Tutorial"
    let throwReadyKey = "throwReady"
    var ballSkin = "Tennis"
    var dogSkin = "Mickey"
    
    let firePit = SKLightNode()
    let grave1 = SKLightNode()
    let grave2 = SKLightNode()
    let camp1 = SKLightNode()
    let camp2 = SKLightNode()
    
    
    let speedLines = SKEmitterNode(fileNamed: "speedLines")!
    
    var markerManager: LoadingManager<SKNode>!
    
    var list: [CGFloat] = []
    
    var dateOfThrow = Date.init()
    var firstSwipePositon = CGPoint(x: -444, y: -444)
    let anchor = SKSpriteNode(texture: nil, color: .clear, size: CGSize(width: 0, height: 0))
    
    
    var cloudSpawner: CloudSpawner!
    
    
    
    enum ZLayer: CGFloat {
        case background
        case belowBall
        case ball
        case aboveBall
        case seperator
        case highGround
        case UI
    }
    
    var wind: AVAudioPlayer? = {
        let url = Bundle.main.url(forResource: "wind", withExtension: "wav")
        do {
            let BGmusic = try AVAudioPlayer(contentsOf: url!)
            return BGmusic
        } catch {
            return nil }
    }()
    

    override func didMove(to view: SKView) {
        view.ignoresSiblingOrder = true
        setup()
    }
    
    override func update(_ currentTime: TimeInterval) {
//        checks()
        updates()
    }
    
    
//    func checks() {
//        checkForBallStop()
//    }
    
    func updates() {
        
//        updateBools()
//        updateSwipeCount()
//        updateVelocityLabel()
//        chaseBall()
//        updateGoldLabel()
//        updateUI()
//        animateBall()
//        animateDog()
//        animateClouds()
//        animateCoinParticles()
//        updateWind()
//        unloadLights()
//        checkRemoveCoinParticles()
        

        GameView.game.duringThrowCheckStats() 
        GameView.game.model.currentBall.monitorSelf()
    }
    
    override func didSimulatePhysics() {
        if !GameView.game.model.currentBall.beingHeld {
            virtualCamera.update()
            camera = virtualCamera
        }
    
        anchor.position = virtualCamera.position
        
        GameView.game.model.currentDog.update()
        markerManager.targetDidChange()
    }
    
    func setup() {
     
//        var list: [CGFloat] = []
//        for i in 0...30 {
//            list.append(CGFloat(i))
//        }
//
//        print(list)
//
//        print(findLastUnder(17.2, middleIndex: 16, in: list, extremum: (0, list.count - 1)))
        
        
        
        
        
        //This initializes the lazy animators in the dog and ball
//        let _ = (GameView.game.model.currentDog.animator.itemObserver)
//        let _ = (GameView.game.model.currentBall.animator.itemObserver)
        
        
        
        GameView.game.model.sendAllDataToWidgets()
        GameView.game.updateAeroModifier()
        
        GameView.game.currentDog.setupAnimator()
        GameView.game.currentDog.defineTextureAndSize()
        GameView.game.currentBall.setupAnimator()
    
        
        virtualCamera = CameraObject(GameView.game.model.currentBall)
        addChild(virtualCamera)
        
        addChild(anchor)
        
        

        
        
        
        cloudSpawner = CloudSpawner({ scalingTextures(texture: "cloud\(min(Int.random(in: 1...5), 3))")  }, createAccessor(from: 0.5, to: 1), createAccessor(from: 4.5, to: 6), createAccessor(from: 5, to: 20), anchoredTo: anchor, in: { self.size })
        createDistanceMarkers()
        
//        checkForSaved()
//        renderParticles()
//        setupLights()
//        setupTextureBallAtlases()
//        setupTextureDogAtlases()
//        setupTextureDogSitAtlases()
//        setupTicks()
//        setupBall()
//        setupBackground()
//        setupGradients()
//        setupDog()
//        setupLabels()
//        setupButtons()
//        setupHeaders()
//        setupMusic()
//        checkShownPerc()
//        runTutorial()

        addChild(GameView.game.model.currentBall)
        addChild(GameView.game.model.currentDog)
       
        setupBackgrounds()
        
        GameView.game.changeState(.home)
    }
    
    func setupBackgrounds() {
        SetupBackground("Bottom", for: .background)
        SetupBackground("Top", for: .seperator)
    }
    
    func SetupBackground(_ root: String, for zIndex: ZLayer ) {
        let backgroundAtlas = createTextureAtlas(atlasName: root)
        let background = SKSpriteNode(texture: backgroundAtlas[0])
        background.size = CGSize(width: 414, height: (backgroundAtlas[0].size().height / backgroundAtlas[0].size().width) * 414)
        background.anchorPoint = CGPoint(x: 0.5, y: 0)
        background.position.y = -800
        background.zPosition = zIndex.rawValue
        
        addChild(background)
        background.run( SKAction.repeatForever( SKAction.animate(with: backgroundAtlas, timePerFrame: 0.25) ))
    }
    
    func sizeDidChange(in size: CGSize) {
        guard let _ = virtualCamera else { return }
        
        virtualCamera.setScale(414 / size.width)
        markerManager.destory()
        createDistanceMarkers()
    }
    
    func holdBall() {
        
        let refBall = GameView.game.model.currentBall!
        let refDog = GameView.game.model.currentDog!
        
        let bottomCornerOfDog = CGPoint(x: refDog.position.x - (refDog.size.width / 2), y:  refDog.position.y - (refDog.size.height / 2))
        
        let scaledMouthPos = CGPoint(x: refDog.type.mouthPos.x * pixelSize * 2, y: refDog.type.mouthPos.y * pixelSize * 2)
        
        let positionOfMouth = CGPoint(x: bottomCornerOfDog.x + scaledMouthPos.x, y: bottomCornerOfDog.y + scaledMouthPos.y)
        
        let anchoredBall = positionOfMouth.y + (refBall.size.height / 2) - (refBall.type.mouthPos * pixelSize * refBall.type.scale)
        
        let positionOfBall = CGPoint(x: positionOfMouth.x, y: anchoredBall)
        
        refBall.position = positionOfBall
        refBall.beingHeld = true
        
    }
    
//    func updateVelocityLabel() {
//        setUpVelocityLabel()
//        if velocityLabel!.parent == nil { anchor.addChild(velocityLabel!) }
//        let referenceToVelocity = GameView.game.model.currentBall.physicsBody!.velocity.dy
//        let trimmedVelocity = referenceToVelocity.trimCGFloat(2)
//
//        velocityLabel?.update(newAmount: trimmedVelocity, usingQueue: false, speed: min(8, max(0.8, referenceToVelocity / 10)))
//        if GameView.game.model.currentState == .throwing {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
//                self.updateVelocityLabel()
//            }
//        }
//    }
//
//    func removeVeclocityLabel() {
//        velocityLabel?.removeFromParent()
//    }
//
//    func setUpVelocityLabel() {
//        if velocityLabel == nil {
//            velocityLabel = FlippingLabel(displayedDigits: 9)
//
//            let velocityText = SKLabelNode(text: "Velocity:")
//            velocityText.fontName = defaultFont.font
//            velocityText.fontSize = 33
//
//
//            velocityLabel!.addChild(velocityText)
//            anchor.addChild(velocityLabel!)
//
//            velocityText.position.y += 50
//            velocityLabel!.position.y -= 300
//            velocityLabel!.zPosition = ZLayer.UI.rawValue
//        }
//    }
    
    func checkForGold(distance: Int) {
        var collectedGold = 0

        let patternRepeatsFor = (CGFloat(distance) / 100)
        for _ in 0...(100) {
            let random = Int.random(in: 0...Int( 100 / GameView.game.goldModifier.value ))
            if random <= 1 { collectedGold += 1 }
        }
        GameView.game.changeGold(with: CGFloat(collectedGold) * patternRepeatsFor)
    }
    
    func createDistanceMarkers() {
        var markerList: [SKNode] = []
        for i in -1000...1000000 {
            if i.isMultiple(of: 10) {
                
                let halfWidth = (size.width / 2) * virtualCamera.xScale
                
                let marker = SKSpriteNode(color: .white, size: CGSize(width: 10, height: 2))
                marker.anchorPoint = CGPoint(x: 1, y: 0.5)
                marker.position = CGPoint(x: halfWidth, y: CGFloat(i))
                marker.zPosition = ZLayer.UI.rawValue
                
                if i.isMultiple(of: 100) {
                    marker.size = CGSize(width: 30, height: 2)
                    
                    let markerNumber = SKLabelNode(text: "\(i)")
                    markerNumber.fontName = defaultFont.font
                    markerNumber.fontSize = 10
                    markerNumber.horizontalAlignmentMode = .right
                    markerNumber.position = CGPoint(x: halfWidth, y: marker.position.y + width(c: 1))
                    markerNumber.zPosition = ZLayer.UI.rawValue
                    
                    markerList.append(markerNumber)
                }
                if !(i - 10).isMultiple(of: 100) { markerList.append(marker) }
            }
        }
        markerManager = LoadingManager(controls: markerList, following: GameView.game.currentBall, in: 1000)
    }
    
    
    
    struct LoadingManager< Subscribers: SKNode > {
        
        var coorespondingPositions: [CGFloat] = []
        var subscribers: [Subscribers]
        var renderedSubscribers: [Subscribers] = []
        
        let target: SKSpriteNode
        let renderRadius: CGFloat
        
        init(controls subscribers: [Subscribers], following target: SKSpriteNode, in renderRadius: CGFloat) {
            self.target = target
            self.renderRadius = renderRadius
            self.subscribers = subscribers
            self.coorespondingPositions = orderSubscribers()
        }
        
        mutating func targetDidChange() {
            
            let bottomBound = target.position.y - renderRadius
            let upperBound = target.position.y + renderRadius

            guard let indexOfTheFirstNodeAbooveCutOff = findFirstAbove(bottomBound, middleIndex: 50, in: coorespondingPositions, extremum: (0, coorespondingPositions.count - 1))
            else {return }

            guard let indexOfTheLastNodeBelowCutOff = findLastUnder(upperBound, middleIndex: 50, in: coorespondingPositions, extremum: (0, coorespondingPositions.count - 1))
            else {return}
            
            let slice = subscribers[indexOfTheFirstNodeAbooveCutOff.0...indexOfTheLastNodeBelowCutOff.0]
            
            for enumeration in renderedSubscribers.enumerated() {
                if enumeration.element.position.y > upperBound || enumeration.element.position.y < bottomBound {
                    enumeration.element.removeFromParent()
                }
            }
            renderedSubscribers.removeAll()
            
            for subscriber in slice {
                if subscriber.parent == nil {
                    globalScene.addChild(subscriber)
                }
                renderedSubscribers.append(subscriber)
            }
        }
        
        mutating func orderSubscribers() -> [CGFloat] {
            subscribers.sort {
                $0.position.y < $1.position.y
            }
            let sortedPositions = subscribers.map() { subscriber in
                subscriber.position.y
            }
            return sortedPositions
        }
        
        mutating func destory() {
            for subscriber in renderedSubscribers {
                subscriber.removeFromParent()
            }
            renderedSubscribers.removeAll()
            subscribers.removeAll()
            coorespondingPositions.removeAll()
        }
    }
    
    struct CloudSpawner {
        
        let textureAccessor: () -> SKTexture
        let alphaAccessor: () -> CGFloat
        let scaleAccessor: () -> CGFloat
        let speedAccessor: () -> CGFloat
        let anchor: SKSpriteNode
        let size: () -> CGSize
        
        init( _ textureAccessor: @escaping () -> SKTexture,  _ alphaAccessor: @escaping () -> CGFloat,  _ scaleAccessor: @escaping () -> CGFloat,  _ speedAccessor: @escaping () -> CGFloat, anchoredTo anchor: SKSpriteNode, in size: @escaping () -> CGSize ) {
            self.textureAccessor = textureAccessor
            self.alphaAccessor = alphaAccessor
            self.scaleAccessor = scaleAccessor
            self.speedAccessor = speedAccessor
            self.anchor = anchor
            self.size = size
            
            spawnCloud()
        }
        
        func spawnCloud() {
            let node = SKSpriteNode(texture: textureAccessor() )
            
            let computedSize = size()
            node.anchorPoint = CGPoint(x: 1, y: 0.5)
            node.position = CGPoint( x: -(computedSize.width / 2) * virtualCamera.xScale, y:  CGFloat.random(in: -computedSize.height / 2...computedSize.height / 2  )  )
            
            let scale = scaleAccessor()
            node.xScale = scale
            node.yScale = scale
            node.alpha = GameView.game.preferenceModel.cloudDensity == .off ? 0: alphaAccessor()
            
            node.zPosition = ZLayer.highGround.rawValue
            
            let distance = computedSize.width * 1.5
            let speed = speedAccessor()
            
            let adjustedSpeed = (distance / 414) * speed
            
            node.run(SKAction.move(by: CGVector(dx: distance + (100 * scale), dy: 0), duration: Double( adjustedSpeed ) ), completion: { node.removeFromParent() }  )
            
            anchor.addChild(node)
            DispatchQueue.main.asyncAfter(deadline: .now() + GameView.game.preferenceModel.cloudDensity.rawValue ) {
                spawnCloud()
            }
        }
    }
    func createAccessor(from first: CGFloat, to last: CGFloat) -> () -> CGFloat {
        return {
            let random = CGFloat.random(in: first...last)
            return random
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    func throwBall() {
//
//
//        ball.physicsBody!.applyImpulse(CGVector(dx: 0, dy: velocity * throwModifier))
//        states.currentStates = States.throwing
//
//        throwing = true
//        throwisReady2 = false
////        velocity = 0
//        initGold = goldCount
//    }
    
//
//    func checkForSaved() {
//        let savedGold = defaults.integer(forKey: savedGoldKey)
//        if savedGold > 0 {
//            goldCount = CGFloat(savedGold)
//        }
////        let savedModifier = defaults.integer(forKey: savedModifierKey)
////        if savedModifier > 10 {
////            throwModifier = CGFloat(savedModifier)
////        }
//        let savedProbability = defaults.integer(forKey: ProbabilityKey)
//        if savedProbability > 0 {
//            Probability = CGFloat(savedProbability)
//        }
//        let savedMostGold = defaults.integer(forKey: mostGoldKey)
//        if savedMostGold > 0 {
//            mostGold = CGFloat(savedMostGold)
//        }
//        let savedFarthestThrow = defaults.integer(forKey: farthestThrowKey)
//        if savedFarthestThrow > 0 {
//            farthestThrow = CGFloat(savedFarthestThrow)
//        }
//        let savedFriction = defaults.integer(forKey: frictionKey)
//        if savedFriction > 0 {
//            friction = CGFloat(savedFriction) / 1000
//        }
//        let savedBallSkin = defaults.string(forKey: ballKey)
//        if savedBallSkin != nil {
//            ballSkin = savedBallSkin!
//        }
//        let savedDogSkin = defaults.string(forKey: dogKey)
//        if savedDogSkin != nil {
//            dogSkin = savedDogSkin!
//        }
//        let savedClouds = defaults.bool(forKey: cloudKey)
//        if savedClouds {
//            cloudsOff = savedClouds
//        }
//        let savedSounds = defaults.bool(forKey: soundKey)
//        if savedSounds {
//            soundOff = savedSounds
//        }
//        let savedDiscovered = defaults.float(forKey: discoveredKey)
//        if savedDiscovered != 0{
//            discoveredPerc = CGFloat(savedDiscovered)
//        }
//        let savedTutorial = defaults.bool(forKey: tutorialKey)
//        tutorialComplete = savedTutorial
//
//        let savedReady = defaults.bool(forKey: throwReadyKey)
//        throwisReady = savedReady
//
//
//    }
//
//    func saveData() {
//        defaults.set(goldCount, forKey: savedGoldKey)
//        defaults.set(mostGold, forKey: mostGoldKey)
//        defaults.set(farthestThrow, forKey: farthestThrowKey)
//        defaults.set(ballSkin, forKey: ballKey)
//        defaults.set(dogSkin, forKey: dogKey)
//        defaults.set(cloudsOff, forKey: cloudKey)
//        defaults.set(soundOff, forKey: soundKey)
//        defaults.set(discoveredPerc, forKey: discoveredKey)
//        defaults.set(tutorialComplete, forKey: tutorialKey)
//        defaults.set(throwisReady, forKey: throwReadyKey)
//    }
////
//    func saveModifier() {
//        defaults.set(throwModifier, forKey: savedModifierKey)
//        defaults.set(Probability, forKey: ProbabilityKey)
//        defaults.set(friction * 1000, forKey: frictionKey)
//
//
//    }
//
////    func setupDog() {
////        dog.position = CGPoint(x: frame.midX, y: frame.midY - width(c: 150))
////        dog.size = CGSize(width: width(c: 200), height: width(c: 200))
////        addChild(dog)
////
////    }
//
////    func staticBallTexture() {
////        let temptexture = ballFrames[0]
////        temptexture.filteringMode = .nearest
////        ball.texture = temptexture
////    }
//
//    func setupBackground(){
//        background.texture = scalingTextures(texture: "Background")
//        background.anchorPoint = CGPoint(x: 0.5, y: 0)
//        background.position = CGPoint(x: 0, y: -30)
//        background.zPosition = -500
//        background.lightingBitMask = 1
//        background.shadowedBitMask = 0
//        background.shadowCastBitMask = 0
//        background.size = CGSize(width: width(c: 414), height: (5500 / 32) * width(c: 414))
//
//
//        background2.texture = scalingTextures(texture: "Background2")
//        background2.anchorPoint = CGPoint(x: 0, y: 0)
//        background2.position = CGPoint(x: 0, y: -30)
//        background2.zPosition = 500
//        background2.lightingBitMask = 0
//        background2.shadowedBitMask = 0
//        background2.shadowCastBitMask = 0
//        background2.size = CGSize(width: width(c: 414), height: (5500 / 32) * width(c: 414))
//
//        background3.texture = scalingTextures(texture: "Background3")
//        background3.anchorPoint = CGPoint(x: 0, y: 0)
//        background3.position = CGPoint(x: 0, y: -30)
//        background3.zPosition = -499
//        background3.lightingBitMask = 0
//        background3.shadowedBitMask = 0
//        background3.shadowCastBitMask = 0
//        background3.size = CGSize(width: width(c: 414), height: (5500 / 32) * width(c: 414))
//
//        ballLight.categoryBitMask = 1
//        ballLight.position = ball.position
//        ballLight.falloff = 0
//        ballLight.lightColor = UIColor(red: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 0.8)
//        ballLight.ambientColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
//        ballLight.shadowColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
//
//
//        addChild(ballLight)
//        addChild(background)
//        addChild(background2)
//        addChild(background3)
//
//    }
//
////    func setupGradients() {
////        backGrad.texture = scalingTextures(texture: "BackGrad")
////        backGrad.size = CGSize(width: width(c: 414), height: width(c: 300))
////        backGrad.anchorPoint = CGPoint(x: 0, y: 0)
////        backGrad.position.y = profileButton.position.y - 110
////        backGrad.alpha = 0.7
////
////        backGrad2.texture = scalingTextures(texture: "BackGrad")
////        backGrad2.size = CGSize(width: width(c: 414), height: width(c: 450))
////        backGrad2.anchorPoint = CGPoint(x: 0.5, y: 0)
////        backGrad2.position = CGPoint(x: frame.midX, y: frame.height)
////        backGrad2.alpha = 0.8
////        backGrad2.zRotation = CGFloat(Double.pi)
////
////        addChild(backGrad2)
////        addChild(backGrad)
////    }
//
////    func setupBall() {
////        ball.position = CGPoint(x: frame.midX, y: frame.midY)
////        ball.size = CGSize(width: width(c: 50), height: width(c: 50))
////        ball.physicsBody = SKPhysicsBody(rectangleOf: ball.size)
////        ball.physicsBody?.affectedByGravity = false
////        ball.physicsBody?.linearDamping = friction
////        ball.physicsBody!.mass = width(c: 200)
////        staticBallTexture()
////        addChild(ball)
////        addChild(cloudAnchor)
////
////    }
//
////    func setupButtons() {
////
//////        let testButton = UIOverlay(positon: CGPoint(x: 0, y: 0), localTexture: SKTexture(imageNamed: "Coin"), localWidth: 122)
//////        addChild(testButton)
////
////        GameModifiersButton.size = CGSize(width: width(c: 122), height: width(c: 122))
////        profileButton.size = CGSize(width: 122, height: 122)
////        GoldButton.size = CGSize(width: width(c: 122), height: width(c: 122))
////
////        GameModifiersButton.position = CGPoint(x: width(c: 341), y: height(c: 100))
////        profileButton.position = CGPoint(x: width(c: 207), y: height(c: 100))
////        GoldButton.position = CGPoint(x: width(c: 73), y: height(c: 100))
////        hiddenButton.position = CGPoint(x: frame.midX, y: height(c: 100))
////
////        profileButton.texture = scalingTextures(texture: "Profile")
////        GoldButton.texture = scalingTextures(texture: "GoldShop")
////        GameModifiersButton.texture = scalingTextures(texture: "ModifierShop")
////
//////        addChild(GameModifiersButton)
//////        addChild(profileButton)
//////        addChild(GoldButton)
//////        addChild(hiddenButton)
////
////        UI.append(GameModifiersButton)
////        UI.append(profileButton)
////        UI.append(GoldButton)
////
////    }
//
//    func setupTicks() {
//        for i in 0...1000000 {
//            if i.isMultiple(of: 100) {
//                let ticks = SKSpriteNode(color: .gray, size: CGSize(width: width(c:40), height: width(c:5)))
//                let halfHeight = (frame.height / 2)
//                ticks.position = CGPoint(x: frame.width, y: CGFloat(i) + halfHeight)
//                tick.zPosition = 1000
//                addChild(ticks)
//                let tickNumbers = SKLabelNode(text: String(i))
//                tickNumbers.fontName = "PixelEmulator"
//                tickNumbers.fontSize = width(c: 10)
//                tickNumbers.position = CGPoint(x: frame.width - width(c: 20), y: CGFloat(i) + halfHeight + height(c: 5))
//                tickNumbers.zPosition = 1000
//                addChild(tickNumbers)
//            }
//        }
//    }
//
////    func setupLabels() {
//////        velocityLabel.fontName = "PixelEmulator"
//////        velocityLabel.fontSize = height(c: 30)
//////        velocityLabel.zPosition = 1000
//////        addChild(velocityLabel)
////
////        goldLabel.fontName = "PixelEmulator"
////        goldLabel.position = CGPoint(x: frame.midX, y: cameraObject.position.y - height(c: 300) + (frame.height / 2))
////        goldLabel.text = "Gold: \(Int(goldCount))"
////        goldLabel.fontSize = height(c: 30)
////        goldLabel.zPosition = 100
////        goldLabel.fontColor = GoldViewController().darkYellow
////        addChild(goldLabel)
////
////        distanceLabel.fontName = "PixelEmulator"
////        distanceLabel.text = ""
////        distanceLabel.fontSize = height(c: 30)
////        distanceLabel.zPosition = 1000
////        addedGoldLabel.fontName = "PixelEmulator"
////        addedGoldLabel.fontSize = height(c: 50)
////        addedGoldLabel.zPosition = 1000
////        addChild(distanceLabel)
////        addChild(addedGoldLabel)
////
////    }
//
////    func setupHeaders() {
////        header.size = CGSize(width: frame.width - width(c: 50), height: width(c: 100))
////        header.position.x = frame.midX
////
////        header2.size = CGSize(width: (frame.width - width(c: 150)) * 1.5, height: width(c: 75 * 1.5))
////        header2.position.x = frame.midX
////
////        hiddenButton2.position = CGPoint(x: frame.midX, y: frame.height - width(c: 100))
////        hiddenButton3.position = CGPoint(x: frame.midX, y: frame.height - width(c: 165 + ((75 * 1.5) / 2)))
////
////
////        header.texture = scalingTextures(texture: "Title")
////        header2.texture = scalingTextures(texture: "GoldBanner")
////
////        returnButton.position = CGPoint(x: frame.midX, y:   frame.midY + width(c:150))
////        returnButton.texture = scalingTextures(texture: "Return")
////        returnButton.zPosition = 1000
////
////        addChild(header)
////        addChild(header2)
////        addChild(hiddenButton2)
////        addChild(hiddenButton3)
////        addChild(returnButton)
////
////        UI.append(header)
////        UI.append(header2)
////
////    }
//
//    func setupMusic() {
//        wind?.play()
//        wind?.volume = 0
//        wind?.stop()
//
//        audioPlayer.autoplayLooped = false
//        audioPlayer2.autoplayLooped = false
//        addChild(audioPlayer)
//        addChild(audioPlayer2)
//    }
//
////    func setupTextureBallAtlases() {
////        ballFrames = Array([])
////        let tempList = SKTextureAtlas(named: ballSkin)
////        for i in 0..<tempList.textureNames.count{
////            let names = "ball" + String(i + 1)
////            let x = SKTexture(imageNamed: names)
////            x.filteringMode = .nearest
////            ballFrames.append(x)
////        }
////    }
////    func setupTextureDogAtlases() {
////        runFrames = Array([])
////        let tempList = SKTextureAtlas(named: "\(dogSkin)Run")
////        for i in 0..<tempList.textureNames.count{
////            let names = "run" + String(i + 1)
////            let x = SKTexture(imageNamed: names)
////            x.filteringMode = .nearest
////            runFrames.append(x)
////        }
////
////    }
////    func setupTextureDogSitAtlases() {
////        sitFrames = Array([])
////        let tempList = SKTextureAtlas(named: "\(dogSkin)Sit")
////        for i in 0..<tempList.textureNames.count{
////            let names = "sit" + String(i + 1)
////            let x = SKTexture(imageNamed: names)
////            x.filteringMode = .nearest
////            sitFrames.append(x)
////
////
////        }
////    }
//
//    func runTutorial() {
//        if !tutorialComplete {
//            currentSlide.texture = scalingTextures(texture: "welcome")
//            currentSlide.name = "welcome"
//            currentSlide.size = CGSize(width: frame.width, height: propHeight(s: currentSlide, w: frame.width))
//            currentSlide.position = CGPoint(x: frame.midX, y: frame.midY)
//            currentSlide.zPosition = 10000
//            addChild(currentSlide)
//        }
//    }
//
////    func propHeight(s: SKSpriteNode, w: CGFloat) -> CGFloat {
////        let returned = (s.size.height / s.size.width) * w
////        return returned
////
////    }
//
//
//    func animateClouds() {
//        cloudAnchor.position = cameraObject.position
//        if !cloudsOff {
//            for _ in 1...6 {
//                if clouds.count < 10{
//
//                    let cloud = SKEmitterNode(fileNamed: "clouds")
//                    cloud?.zPosition = 1000
//                    cloud?.position.y = CGFloat(Int.random(in: Int(width(c: -400))...Int(width(c: 400))))
//                    cloud?.position.x = CGFloat(Int.random(in: -1000 ... -500))
//
//                    cloudAnchor.addChild(cloud!)
//                    clouds.append(cloud!)
//                }
//            }
//        }
//        if cloudsOff {
//            for i in clouds {
//                i.removeFromParent()
//                clouds.remove(at: clouds.firstIndex(of: i)!)
//            }
//        }
//    }
//
    func playBeepSound() {
        if !soundOff {
            ball.run(SKAction.playSoundFileNamed("beep", waitForCompletion: false))
        }
    }
//
////    func animateBall() {
////        if !throwing {
////            switch ballSkin {
////                case "Foot": ball.size = CGSize(width: width(c: 100), height: width(c: 100))
////                case "Disco": ball.size = CGSize(width: width(c: 75), height: width(c: 75))
////                case "Basket": ball.size = CGSize(width: width(c: 100), height: width(c: 100))
////                case "Earth": ball.size = CGSize(width: width(c: 75), height: width(c: 75))
////                case "Disk": ball.size = CGSize(width: width(c: 100), height: width(c: 100)); heightMod = 2
////                case "Apple": ball.size = CGSize(width: width(c: 75), height: width(c: 75))
////                case "Lemon": ball.size = CGSize(width: width(c: 75), height: width(c: 75))
////                case "Beach": ball.size = CGSize(width: width(c: 100), height: width(c: 100)); heightMod = 2
////                case "Death": ball.size = CGSize(width: width(c: 140), height: width(c: 140))
////                case "Puffer": ball.size = CGSize(width: width(c: 75), height: width(c: 75))
////                case "Spike": ball.size = CGSize(width: width(c: 100), height: width(c: 100))
////                case "Clock": ball.size = CGSize(width: width(c: 75), height: width(c: 75))
////                case "Saturn": ball.size = CGSize(width: width(c: 120), height: width(c: 120))
////                case "Air": ball.size = CGSize(width: width(c: 120), height: width(c: 120))
////                case "Rubix": ball.size = CGSize(width: width(c: 65), height: width(c: 65))
////                default: ball.size = CGSize(width: width(c: 50), height: width(c: 50)); heightMod = 1
////
////            }
////        }
////        if throwing && !throwComplete {
////            if ball.action(forKey: "animated") == nil{
////
////                let time = (1 / ((ball.physicsBody?.velocity.dy)! / 60))
////                let height = (ball.physicsBody?.velocity.dy)! / 140
////
////                if time < 100 {
////                    if width(c: height) >= width(c:50) && ballSkin != "Disco" && ballSkin != "Foot" && ballSkin != "Basket"  && ballSkin != "Earth"  && ballSkin != "Apple"  && ballSkin != "Lemon" && ballSkin != "Death" && ballSkin != "Puffer" && ballSkin != "Spike" && ballSkin != "Clock" && ballSkin != "Saturn"  && ballSkin != "Moon" && ballSkin != "Air" && ballSkin != "Rubix"{
////                        if width(c: height) > width(c:100) {
////                            ball.size.height = width(c:100 * heightMod)
////                        } else {
////                            ball.size.height = width(c: height * heightMod)
////                        }
////                    }
////                    ball.run(SKAction.animate(with: ballFrames, timePerFrame: TimeInterval(time)), withKey: "animated")
////                }
////                else {
////                    ball.run(SKAction.animate(with: ballFrames, timePerFrame: TimeInterval(0.004)), withKey: "animated")
////                }
////            }
////        }
////    }
////    func animateDog() {
////        if throwing{
////            if dog.action(forKey: "animated") == nil {
////                let time = (1 / ((ball.physicsBody?.velocity.dy)! / 60))
////                if time < 100 && time > 0.1 {
////                    dog.run(SKAction.animate(with: runFrames, timePerFrame: TimeInterval(time)), withKey: "animated")
////                }
////                else{
////                    dog.run(SKAction.animate(with: runFrames, timePerFrame: 0.1), withKey: "animated")
////                }
////            }
////        }
////        else if throwComplete{
////            dog.removeAction(forKey: "animated")
////            if Int(dog.position.y) != Int(ball.position.y + width(c: 100)) {
////                if dog.action(forKey: "animated2") == nil {
////                    dog.run(SKAction.animate(with: runFrames, timePerFrame: 0.1), withKey: "animated2")
////                }
////            }
////            else if !dogRotate {
////                dog.zRotation = CGFloat(Double.pi)
////                returnButton.run(SKAction.resize(toWidth: width(c: 214), duration: 0.05))
////                returnButton.run(SKAction.resize(toHeight: width(c: 75), duration: 0.05))
////                dogRotate = true
////            }
////        }
////        else if Int(dog.position.y) != Int(frame.midY - width(c: 150)) {
////            if dog.action(forKey: "animated") == nil {
////                dog.run(SKAction.animate(with: runFrames, timePerFrame: 0.1), withKey: "animated")
////            }
////        }
////        else {
////            if dog.action(forKey: "animated") != nil  {
////                for i in 0...50 {
////                    animateCoins(time: CGFloat(i) / CGFloat(20))
////                }
////            }
////            dog.removeAction(forKey: "animated")
////            if dog.action(forKey: "animatedSit") == nil {
////                dog.run(SKAction.animate(with: sitFrames, timePerFrame: 0.05), withKey: "animatedSit")
////            }
////            dog.zRotation = 0
////            throwisReady2 = true
////            dogRotate = false
////        }
//    }
//    func animateCoins(time: CGFloat) {
//        let temp = SKSpriteNode(imageNamed: "Coin")
//        let distance = abs(cloudAnchor.position.y - (header2.position.y - header2.size.height / 2)) + width(c: 50)
//        temp.name = "temp"
//        temp.zPosition = 100
//        temp.size = CGSize(width: width(c:25), height:   width(c:25))
//        cloudAnchor.addChild(temp)
//
//        temp.run(SKAction.sequence([SKAction.rotate(byAngle: 0, duration: TimeInterval(time)), SKAction.move(to: CGPoint(x: 0 , y: distance), duration: 0.3) ]) )
//
//    }
//
//    func animateCoinParticles() {
//        for i in cloudAnchor.children {
//            if !i.hasActions() && i.name == "temp"{
//                goldCount += (addedGold / 51)
//                let temp = SKEmitterNode(fileNamed: "goldCoins")
//                let random = Int.random(in: 1...2)
//                temp?.position.y = i.position.y
//                temp!.name = "temp2"
//                i.removeFromParent()
//                if !soundOff {
//                    temp?.run(SKAction.playSoundFileNamed("gold\(random)", waitForCompletion: false)) }
//                cloudAnchor.addChild(temp!)
//            }
//        }
//    }
//
//    func coinsInCloud() -> Bool{
//        var returned = false
//        for i in cloudAnchor.children {
//            if i.name == "temp" {
//                returned = true
//            }
//        }
//        return returned
//    }
//
//    func checkRemoveCoinParticles() {
//        let tempVar = "\(goldCount)"
//        var tempList = Array<String>()
//        for i in tempVar {
//            tempList.append(String(i))
//        }
//        let pointIndex = tempList.firstIndex(of: ".")!
//        if tempList.count > pointIndex + 5 {
//            if tempList[pointIndex + 2] == "9" && tempList[pointIndex + 3] == "9" && tempList[pointIndex + 4] == "9" && !coinsInCloud(){
//                goldCount.round()
//            }
//        }
//
//
//    }
//
////    func updateVelocityLabel() {
////        if (ball.physicsBody?.velocity.dy)! > CGFloat(0) {
////            velocityLabel.position = CGPoint(x: frame.midX, y: cameraObject.position.y + width(c: 200) - (frame.height / 2))
////            velocityLabel.text = "Velocity: \(Int((ball.physicsBody?.velocity.dy)!))"
////        }
////        else {
////            velocityLabel.text = ""
////        }
////    }
//
//    func checkForGold(distance: CGFloat) {
//        let initGold = goldCount
//        for _ in 0...Int(distance){
//            let random = Int.random(in: 1...Int(Probability))
//            if random == 1 {
//                goldCount += 1
//            }
//        }
//        addedGold = goldCount - initGold
//        goldCount = initGold
//        if mostGold < goldCount {
//            mostGold = goldCount
//        }
//        saveData()
//    }
//
//    func checkForBallStop() {
//        if ball.physicsBody!.velocity.dy == 0 && CGFloat((ball.position.y).rounded()) != frame.midY && throwing{
//            showDistance()
//        }
//    }
//
//    func slideAway(sprite: SKSpriteNode, xDir: Int, yDir: Int) {
//        sprite.run(SKAction.sequence([SKAction.rotate(byAngle: 0, duration: 0.5), SKAction.move(by: CGVector(dx: -1 * xDir * 40, dy: -1 * yDir * 40), duration: 0.1), SKAction.move(by: CGVector(dx:  xDir * 1000, dy: yDir * 1000), duration: 1000 * (0.08 / 100))]))
//    }
//
//    func slideIntoView(sprite: SKSpriteNode, xDir: Int, yDir: Int) {
//            sprite.run(SKAction.sequence([SKAction.move(by: CGVector(dx:  xDir * 1000, dy: yDir * 1000), duration: 1000 * (0.08 / 100)), SKAction.move(by: CGVector(dx: -1 * xDir * 40, dy: -1 * yDir * 40), duration: 0.1)]))
//    }
//
////    func updateGoldLabel() {
////        goldLabel.text = "\(Int(goldCount))"
////    }
////
////    func updateCamera() {
////        cameraObject.position.y = ball.position.y
////        cameraObject.position.x = frame.midX
////        ballLight.position = ball.position
////       }
//
////    func updateSwipeCount() {
////        if swipe{
////            swipeCounter += 10
////        }
////    }
//
////    func chaseBall() {
////        if throwing{
////            dog.position.y = cameraObject.position.y - width(c: 150)
////        }
////        if throwComplete{
////            checkShownPerc()
////            if dog.action(forKey: "moveToCenter") == nil {
////                dog.run(SKAction.moveTo(y: ball.position.y + width(c: 100), duration: 0.6), withKey: "moveToCenter")
////            }
////        }
////    }
//
//    func checkShownPerc() {
//        var fraction = cameraObject.position.y / ((5500 / 32) * width(c: 414))
//        fraction *= 100
//
//        if fraction > discoveredPerc {
//            discoveredPerc = min(fraction, 100)
//            saveData()
//        }
//
//
//    }
//
//    func renderParticles() {
//        renderFlame(position: CGPoint(x: 64, y: 1400), node: firePit)
//        renderFlame(position: CGPoint(x: 116, y: 13205), node: grave1)
//        renderFlame(position: CGPoint(x: 323, y: 13205), node: grave2)
//        renderFlame(position: CGPoint(x: 116, y: 27252), node: camp1)
//        renderFlame(position: CGPoint(x: 26, y: 44702), node: camp2)
//
//        renderSmoke(position: CGPoint(x: 336, y: 20898))
//        renderSmoke(position: CGPoint(x: 25, y: 20610))
//        renderSmoke(position: CGPoint(x: 38, y: 19105))
//        renderSmoke(position: CGPoint(x: 336, y: 18752))
//        renderSmoke(position: CGPoint(x: 38, y: 33828))
//        renderSmoke(position: CGPoint(x: 323, y: 33502))
//
//
//        let tempSnow = SKEmitterNode(fileNamed: "Snow"); let tempRain = SKEmitterNode(fileNamed: "Rain")
//        tempSnow?.position = CGPoint(x: width(c: 414), y: width(c: 45950)); tempRain?.position = CGPoint(x: width(c: 414), y: width(c: 10600))
//        tempSnow?.zPosition = 1000; tempRain?.zPosition = 1000
//        addChild(tempSnow!); addChild(tempRain!)
//    }
//
//    func renderFlame(position: CGPoint, node: SKLightNode) {
//        let tempFlame = SKEmitterNode(fileNamed: "Fire")
//
//        tempFlame?.position.x = width(c: position.x); tempFlame?.position.y = flameYPos(height: position.y);
//        tempFlame?.zPosition = 100
//        addChild(tempFlame!)
//
//
//    }
//
//    func renderSmoke(position: CGPoint) {
//        let tempSmoke = SKEmitterNode(fileNamed: "Smoke")
//
//        tempSmoke?.position = CGPoint(x: width(c: position.x), y:  width(c: position.y))
//        addChild(tempSmoke!)
//
//    }
//
//    func setupLights() {
//
//        drawLights(position: CGPoint(x: 2, y: 5302), color: UIColor(red: 1, green: 249 / 255, blue: 0 / 255, alpha: 1), fallOff: 2, name: "lamp")
//        drawLights(position: CGPoint(x: 16, y: 3945), color: .red, fallOff: 1, name: "vol")
//        drawLights(position: CGPoint(x: 16, y: 3264), color: .red, fallOff: 1, name: "red")
//        drawLights(position: CGPoint(x: 27, y: 3179), color: UIColor(red: 1, green: 249 / 255, blue: 0 / 255, alpha: 1), fallOff: 2, name: "lamp2")
//        drawLights(position: CGPoint(x: 17, y: 3149), color: UIColor(red: 1, green: 249 / 255, blue: 0 / 255, alpha: 1), fallOff: 2, name: "lamp3")
//        drawLights(position: CGPoint(x: 21, y: 2691), color: UIColor(red: 1, green: 249 / 255, blue: 0 / 255, alpha: 1), fallOff: 2, name: "car1")
//        drawLights(position: CGPoint(x: 21, y: 2683), color: UIColor(red: 1, green: 249 / 255, blue: 0 / 255, alpha: 1), fallOff: 3, name: "car2")
//        drawLights(position: CGPoint(x: 23, y: 2517), color: UIColor(red: 1, green: 249 / 255, blue: 0 / 255, alpha: 1), fallOff: 2, name: "car3")
//        drawLights(position: CGPoint(x: 11, y: 2418), color: UIColor(red: 1, green: 249 / 255, blue: 0 / 255, alpha: 1), fallOff: 2, name: "car4")
//        drawLights(position: CGPoint(x: 6, y: 2418), color: UIColor(red: 1, green: 249 / 255, blue: 0 / 255, alpha: 1), fallOff: 2, name: "car5")
//        drawLights(position: CGPoint(x: 7, y: 2332), color: UIColor(red: 1, green: 249 / 255, blue: 0 / 255, alpha: 1), fallOff: 3, name: "car6")
//        drawLights(position: CGPoint(x: 2, y: 2332), color: UIColor(red: 1, green: 249 / 255, blue: 0 / 255, alpha: 1), fallOff: 3, name: "car7")
//        drawLights(position: CGPoint(x: 29, y: 2290), color: UIColor(red: 1, green: 249 / 255, blue: 0 / 255, alpha: 1), fallOff: 3, name: "car8")
//        drawLights(position: CGPoint(x: 24, y: 2290), color: UIColor(red: 1, green: 249 / 255, blue: 0 / 255, alpha: 1), fallOff: 3, name: "car9")
//        drawLights(position: CGPoint(x: 3, y: 3035), color: UIColor(red: 1, green: 249 / 255, blue: 0 / 255, alpha: 1), fallOff: 3, name: "gold")
//        drawLights(position: CGPoint(x: 4, y: 2878), color: .red, fallOff: 1, name: "lava2")
//        drawLights(position: CGPoint(x: 2, y: 2934), color: .red, fallOff: 1, name: "lava3")
//        drawLights(position: CGPoint(x: 26, y: 3871), color: .red, fallOff: 1, name: "lava4")
//        drawLights(position: CGPoint(x: 4, y: 4007), color: .red, fallOff: 1, name: "lava5")
//        drawLights(position: CGPoint(x: 30, y: 4046), color: .red, fallOff: 1, name: "lava6")
//
//        drawLights(position: CGPoint(x: 5, y: 5389), color: .orange, fallOff: 2, name: "flame1")
//        drawLights(position: CGPoint(x: 9, y: 4476), color: .orange, fallOff: 2, name: "flame2")
//        drawLights(position: CGPoint(x: 25, y: 4476), color: .orange, fallOff: 2, name: "flame3")
//        drawLights(position: CGPoint(x: 9, y: 3391), color: .orange, fallOff: 2, name: "flame4")
//        drawLights(position: CGPoint(x: 2, y: 2047), color: .orange, fallOff: 2, name: "flame5")
//
//
//
//
//
//    }
//
//    func checkLightList(name: String) -> Bool{
//        var returned = false
//        for i in lights {
//            if i.name == name {
//                returned = true
//            }
//        }
//        return returned
//    }
//
//    func flameYPos(height: CGFloat) -> CGFloat {
//        let x = (height / 71156) * ((5500 / 32) * width(c: 414))
//        return x
//    }
//
//    func drawLights(position: CGPoint, color: UIColor, fallOff: CGFloat, name: String) {
//
//
//        var finalY = 5500 - position.y
//        let finalX = (414 * position.x) / 32
//        finalY = (((5500 / 32) * width(c: 414)) * finalY) / 5500
//
//        if finalY > cameraObject.position.y + frame.height || finalY < cameraObject.position.y - frame.height {
//        }else {
//            if lights.count > 0{
//                if !checkLightList(name: name) {
//                    addLight(name: name, color: color, fallOff: fallOff, finalX: finalX, finalY: finalY)
//
//                }
//            }else {
//                addLight(name: name, color: color, fallOff: fallOff, finalX: finalX, finalY: finalY)
//            }
//
//        }
//    }
//
//    func addLight(name: String, color: UIColor, fallOff: CGFloat, finalX: CGFloat, finalY: CGFloat) {
//        let tempLight2 = SKLightNode()
//        tempLight2.name = name
//
//        tempLight2.categoryBitMask = 1
//        tempLight2.ambientColor = UIColor(red: 1, green: 249 / 255, blue: 0 / 255, alpha: 0.0)
//        tempLight2.lightColor = color
//        tempLight2.shadowColor = UIColor(red: 1, green: 249 / 255, blue: 0 / 255, alpha: 0.0)
//
//        tempLight2.falloff = fallOff
//        tempLight2.position = CGPoint(x: finalX, y: finalY)
//        lights.append(tempLight2)
//
//        addChild(tempLight2)
//    }
//
//    func unloadLights() {
//        setupLights()
//        for i in lights {
//            if i.position.y > cameraObject.position.y + frame.height || i.position.y < cameraObject.position.y - frame.height {
//                i.removeFromParent()
//                lights.remove(at: lights.firstIndex(of: i)!)
//            }
//        }
//    }
//
//    func updateUI() {
//
//        for i in cloudAnchor.children {
//            if i.name == "temp2" {
//
//            }
//        }
//        if throwComplete {
//        }
//        else if !returnButton.hasActions() && returnButton.size.width > 0 {
//            returnButton.run(SKAction.resize(toWidth: 0, duration: 0.05))
//            returnButton.run(SKAction.resize(toHeight: height(c: 0), duration: 0.05))
//        }
//
//        if throwing && !hiddenButton.hasActions() && hiddenButton.position.y > 0 {
//            slideAway(sprite: hiddenButton, xDir: 0, yDir: -1)
//            slideAway(sprite: hiddenButton2, xDir: 0, yDir: 1)
//            slideAway(sprite: hiddenButton3, xDir: 0, yDir: 1)
//        }
//        if !throwing && !hiddenButton.hasActions() && hiddenButton.position.y < 0 && !throwComplete{
//            slideIntoView(sprite: hiddenButton, xDir: 0, yDir: 1)
//            slideIntoView(sprite: hiddenButton2, xDir: 0, yDir: -1)
//            slideIntoView(sprite: hiddenButton3, xDir: 0, yDir: -1)
//        }
//        for i in UI {
//            if i == header {
//                i.position.y = hiddenButton2.position.y + (cameraObject.position.y - (frame.height / 2))
//            }
//            else if i == header2 {
//                i.position.y = hiddenButton3.position.y + (cameraObject.position.y - (frame.height / 2))
//            }
//            else {
//                i.position.y = hiddenButton.position.y + (cameraObject.position.y - (frame.height / 2))
//            }
//        }
//        returnButton.position.y = (cameraObject.position.y) + height(c: 150)
//        goldLabel.position.y = header2.position.y + width(c: 10)
//
//        backGrad.position.y = profileButton.position.y - 120
//        backGrad2.position.y = header.position.y + 120
//
//    }
//
//    func updateWind() {
//        if throwing && !soundOff{
//            let temp = (ball.physicsBody?.velocity.dy)! / 1000
//            if temp < 1 {
//                wind?.volume = Float(temp)
//            }
//            else {
//                wind?.volume = 1
//            }
//            wind!.play()
//        }
//        else {
//            wind?.stop()
//        }
//    }
//
//    func returnDog(sprite: SKSpriteNode, pos: CGFloat, startPos: CGFloat) {
//        dog.removeAction(forKey: "moveToCenter")
//        let difference = abs(startPos - pos)
//        sprite.position.y = startPos
//        sprite.run(SKAction.moveTo(y: pos, duration: TimeInterval(difference / 500)))
//    }
//
//    func updateBools() {
//        if (ball.physicsBody?.velocity.dy)! == 0 && throwing && Int(ball.position.y.rounded()) != Int(frame.midY){
//            throwing = false
//            throwComplete = true
//            throwisReady2 = false
//        }
//    }
//
//    func returnBall() {
//        if ball.position.y > farthestThrow {
//            farthestThrow = ball.position.y
//        }
//        saveData()
////        swipeCounter = 0
//        distanceLabel.text = ""
//        addedGoldLabel.text = ""
//        throwComplete = false
////        swipe = false
//        returnDog(sprite: ball, pos: frame.midY, startPos: frame.height)
//        returnDog(sprite: dog, pos: frame.midY - width(c: 150), startPos: frame.height + width(c: 100))
//        ball.removeAction(forKey: "animated")
//    }
//
//    func showDistance() {
//        if !distanceLabel.hasActions() && distanceLabel.text == ""{
//            checkForGold(distance: ball.position.y - (frame.height / 2))
//            distanceLabel.position = CGPoint(x: frame.midX, y: ball.position.y - frame.height / 2 + width(c: 100))
//            distanceLabel.run(SKAction.sequence([SKAction.scale(by: 1.2, duration: 0.3), SKAction.scale(by: (1 / 1.2), duration: 0.3)]))
//            addedGoldLabel.position = CGPoint(x: frame.midX, y: ball.position.y - frame.height / 2 + width(c: 50))
//            addedGoldLabel.run(SKAction.sequence([SKAction.scale(by: 1.2, duration: 0.3), SKAction.scale(by: (1 / 1.2), duration: 0.3)]))
//
//        }
//        if !distanceLabel.hasActions() && distanceLabel.text != "" {
//            distanceLabel.removeAllActions()
//            addedGoldLabel.removeAllActions()
//            throwComplete = true
//        }
//        else {
//            distance = ball.position.y - (frame.height / 2)
//            distanceLabel.text = "Distance: \(Int(distance))!"
//            addedGoldLabel.text = "+\(Int(addedGold)) Gold!"
//
//        }
//
//    }
//
//    func switchTutorialCards(cardName: String, position: CGPoint) {
//        currentSlide.size = scalingTextures(texture: cardName).size()
//        currentSlide.texture = scalingTextures(texture: cardName); currentSlide.name = cardName
//        currentSlide.size = CGSize(width: frame.width, height: propHeight(s: currentSlide, w: frame.width))
//        currentSlide.position = position
//    }
//
//    func updateBallDampening() {
//        ball.physicsBody?.linearDamping = friction
//
//    }
//
    func width(c: CGFloat) -> CGFloat{
        return UIScreen.main.bounds.width * (c / 414)
    }

    func height(c: CGFloat) -> CGFloat{
        return UIScreen.main.bounds.height * (c / 896)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        GameView.game.model.currentBall.position.y += 200
        GameView.game.model.currentDog.position.y += 200
        
//        if !tutorialComplete {
//            if currentSlide.name == "welcome" {
//                switchTutorialCards(cardName: "yard", position: CGPoint(x: frame.midX, y: frame.midY))
//            } else if currentSlide.name == "yard" {
//                currentSlide.anchorPoint = CGPoint(x: 0.5, y: 1)
//                switchTutorialCards(cardName: "gold", position: CGPoint(x: frame.midX, y: header2.position.y))
//            } else if currentSlide.name == "gold" {
//                currentSlide.anchorPoint = CGPoint(x: 0.5, y: 0.5)
//                switchTutorialCards(cardName: "gold2", position: CGPoint(x: frame.midX, y: frame.midY))
//            } else if currentSlide.name == "gold2" {
//                switchTutorialCards(cardName: "swipe", position: CGPoint(x: frame.midX, y: frame.midY))
//            } else if currentSlide.name == "swipe" {
//                currentSlide.anchorPoint = CGPoint(x: 0.5, y: 0)
//                switchTutorialCards(cardName: "shops", position: CGPoint(x: frame.midX, y: profileButton.position.y + profileButton.size.height / 2))
//            }else if currentSlide.name == "shops" {
//                currentSlide.anchorPoint = CGPoint(x: 0.5, y: 0.5)
//                switchTutorialCards(cardName: "letsPlay", position: CGPoint(x: frame.midX, y: frame.midY))
//            }else if currentSlide.name == "letsPlay" {
//                currentSlide.removeFromParent()
//                tutorialComplete = true
//                saveData()
//            }


//        }
//        else {
//            swipe = true
//        }


    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if tutorialComplete && throwisReady && !throwing && !throwComplete && throwisReady2{
//            for t in touches {
//                if ball.physicsBody?.velocity.dy == 0 {
//                    swipeList.append(t.location(in: self))
//                }
//            }
//        }

        if GameView.game.model.currentState == .home {
            if firstSwipePositon == CGPoint(x: -444, y: -444) {
                if let currentTouchPosition = touches.first?.location(in: self) {
                    firstSwipePositon = currentTouchPosition

                    dateOfThrow = Date.init()
                }
            }
        }

    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if GameView.game.model.currentState == .home {
            let currentDate = Date.init()
            let timePassedSinceThrow = currentDate.timeIntervalSince(dateOfThrow)

            if let currentTouchPosition = touches.first?.location(in: self) {
                if firstSwipePositon.y < currentTouchPosition.y && firstSwipePositon != CGPoint(x: -444, y: -444) {
                    velocity = (currentTouchPosition.y - firstSwipePositon.y) / CGFloat(timePassedSinceThrow)
                    
                

                    //reset the firstSwipePosition to arbitrary value:
                    firstSwipePositon = CGPoint(x: -444, y: -444)

                    GameView.game.model.currentBall.throwSelf()
                }
            }
        }
    }



//        if tutorialComplete {
//            if !throwisReady{
//                throwisReady = true
////                saveData()
//            }


//            swipe = false
//
//            if swipeList.count > 2 && !throwing && !throwComplete{
//                if swipeList[0].y < swipeList[swipeList.count - 1].y {
//                    velocity = (swipeList[swipeList.count - 1].y - swipeList[0].y) / swipeCounter
////                    throwBall()
//                    currentBall.throwSelf(velcoity: velocity)
//                }
//            }
//            swipeCounter = 0
//            for i in swipeList{
//                swipeList.remove(at: swipeList.firstIndex(of: i)!)
//            }
//            swipeList = Array([CGPoint()])
//        }
//        }
//    }
}
//
