//
//  UniversalFunctions.swift
//  Fetch - Remastered
//
//  Created by Brian Masse on 6/12/21.
//  Copyright © 2021 Brian Masse. All rights reserved.
//

import Foundation
import SpriteKit
import SwiftUI

let emptyColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
let defaults = UserDefaults.standard

var globalFrame = UIScreen.main.bounds
let globalScene = GameScene(size: UIScreen.main.bounds.size)

//MARK: Modifiers:


var friction = CGFloat(1)

var virtualCamera: CameraObject!

var velocity = CGFloat(0)
var velocityLabel: FlippingLabel?

var pixelSize: CGFloat = 2.3




func findFirstAbove(_ target: CGFloat, middleIndex: Int, in list: [CGFloat], extremum: (Int, Int)) -> (Int, CGFloat)? {
    
    var newMin = 0
    var newMax = list.count - 1
    
    if target < list[0] { return (0, list[0]) }
    if target > list[newMax] { return nil }
    
    let middle = list[middleIndex]
    let left = middleIndex > 0 ? list[middleIndex - 1] : list.first!
    let right = middleIndex < newMax ? list[middleIndex + 1]: list.last!
    
    let rightIndex = min(newMax, middleIndex + 1)
    let leftIndex = max(0, middleIndex - 1)
    
    newMin = extremum.0
    newMax = extremum.1
    
    if middle == target {  return (rightIndex, right)}
    if middle > target {
        if left <= target { return (middleIndex, middle) }
        else { newMax = leftIndex }
    }
    if middle < target {
        if right > target { return (rightIndex , right)}
        else { newMin = rightIndex }
    }

    let newMiddle = Int((CGFloat(newMax - newMin) / 2).rounded(.up)) + newMin
    return findFirstAbove(target, middleIndex: newMiddle, in: list, extremum: (newMin, newMax))
}




func findLastUnder(_ target: CGFloat, middleIndex: Int, in list: [CGFloat], extremum: (Int, Int)) -> (Int, CGFloat)? {
    
    var newMin = 0
    var newMax = list.count - 1
    
    if target < list[0] { return nil }
    if target > list[newMax] { return (newMax, list[newMax]) }
    
    let middle = list[middleIndex]
    let left = middleIndex > 0 ? list[middleIndex - 1] : list.first!
    let right = middleIndex < newMax ? list[middleIndex + 1]: list.last!
    
    let rightIndex = min(newMax, middleIndex + 1)
    let leftIndex = max(0, middleIndex - 1)
    
    newMin = extremum.0
    newMax = extremum.1
    
    if middle == target { return (leftIndex, left)}
    if middle > target {
        if left < target { return(leftIndex, left)}
        else { newMax = leftIndex }
    }
    if middle < target {
        if right >= target { return (middleIndex, middle)}
        else {newMin = rightIndex}
    }
    
    let newMiddle = Int((CGFloat(newMax - newMin) / 2).rounded(.up)) + newMin
    return findLastUnder(target, middleIndex: newMiddle, in: list, extremum: (newMin, newMax))
    
}





func scaleToPixels(node: SKSpriteNode, modifier: CGFloat) -> CGSize? {
    guard let texture = node.texture else { return nil }
    let textureSize = texture.size()
    let size = CGSize(width: textureSize.width * pixelSize * modifier, height:  textureSize.height * pixelSize * modifier)
    return size
}

func scalingTextures(texture: String) -> SKTexture{
    let tempTexture = SKTexture(imageNamed: texture)
    tempTexture.filteringMode = .nearest
    return tempTexture
}

func createTextureAtlas(atlasName: String) -> [SKTexture] {
    var returningAtlas: [SKTexture] = []
    let tempAtlas = SKTextureAtlas(named: atlasName)
    for index in tempAtlas.textureNames.enumerated() {
        let name = atlasName + "\(index.offset + 1)"
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

extension CaseIterable where Self: Equatable{
    
    func next() -> Self {
        let all = Self.allCases
        let myIndex = all.firstIndex(of: self)!
        return all[ all.index(after: myIndex) == all.endIndex ? all.startIndex: all.index(after: myIndex) ]
    }
}

func findDistance(_ firstPoint: CGPoint, _ secondPoint: CGPoint = CGPoint(x: 0, y: 0)) -> CGFloat {
    let xDis = firstPoint.x - secondPoint.x
    let yDis = firstPoint.y - secondPoint.y
    
    let distance = sqrt(Double( pow(xDis, 2) + pow(yDis, 2)) )
    return CGFloat(distance)
}

protocol Upgradable {
    var value: CGFloat { get set }
    var maxValue: CGFloat { get }
    var id: String { get }
    var maxxed: Bool  { get set }
    
    var title: String { get }
    var description: String { get }
    var buttonText: String { get }
    
    func saveSelf() -> Void // cannot be self mutating: it will be called on a copy of the modifier
    
    var shadowColor: Color { get }
    var baseColor: Color { get }
    
    var iteration: Int { get set }
    func returnCurrentPrice() -> Int
    func returnCurrentIncriment() -> CGFloat
    
}

protocol gameObject: Identifiable, Equatable, Codable {
    
    var skin: String {get}
    var cost: Int {get}
    var UIPreview: UIImage? {get}
    
    var isUnlocked: Bool {get set}
    var isCurrent: Bool {get set}
}

protocol CurrentObject: Equatable {
    
    associatedtype currentType: gameObject
    
    var type: currentType { get set }
    func defineTextureAndSize() -> Void
    
}
