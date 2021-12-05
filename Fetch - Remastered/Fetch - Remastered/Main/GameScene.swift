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
    var markerManager: LoadingManager<SKNode>!
    
    var cloudSpawner: CloudSpawner!
    let anchor = SKSpriteNode(texture: nil, color: .clear, size: CGSize(width: 0, height: 0))
    
    var dateOfThrow = Date.init()
    var firstSwipePositon = CGPoint(x: -444, y: -444)
    
    enum ZLayer: CGFloat {
        case background
        case belowBall
        case ball
        case aboveBall
        case seperator
        case highGround
        case UI
    }

    override func didMove(to view: SKView) {
        view.ignoresSiblingOrder = true
        setup()
    }
    
    override func update(_ currentTime: TimeInterval) {
        updates()
    }
    
    func updates() {
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
        GameView.game.model.sendAllDataToWidgets()
        GameView.game.updateAeroModifier()
        
        GameView.game.currentDog.setupAnimator()
        GameView.game.currentDog.defineTextureAndSize()
        GameView.game.currentBall.setupAnimator()
        addChild(GameView.game.model.currentBall)
        addChild(GameView.game.model.currentDog)
    
        virtualCamera = CameraObject(GameView.game.model.currentBall)
        addChild(virtualCamera)
        
        addChild(anchor)
        cloudSpawner = CloudSpawner({ scalingTextures(texture: "cloud\(min(Int.random(in: 1...5), 3))")  }, createAccessor(from: 0.5, to: 1), createAccessor(from: 4.5, to: 6), createAccessor(from: 5, to: 20), anchoredTo: anchor, in: { self.size })
        
        createDistanceMarkers()
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
        background.position.y = -835
        background.zPosition = zIndex.rawValue
        
        let white = SKSpriteNode(color: .white, size: CGSize(width: 414, height: 100))
        white.position.y = -840
        white.zPosition = -10000
        
        addChild(background)
        addChild(white)
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
    
    func checkForGold(distance: Int) {
        var collectedGold = 0
        
        let patternRepeatsFor = (CGFloat(distance) / 100)
        for _ in 0...(100) {
            let random = CGFloat.random(in: 0...100)
            if random <= GameView.game.goldModifier.value { collectedGold += 1 }
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

    func width(c: CGFloat) -> CGFloat{
        return UIScreen.main.bounds.width * (c / 414)
    }

    func height(c: CGFloat) -> CGFloat{
        return UIScreen.main.bounds.height * (c / 896)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        GameView.game.currentDog.position.y += 300
//        GameView.game.currentBall.position.y += 300
//        
//        let texture = GameView.game.currentDog.type.runAtlas.first!
//        texture.filteringMode = .nearest
//        
//        GameView.game.currentDog.texture = texture
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
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
}
