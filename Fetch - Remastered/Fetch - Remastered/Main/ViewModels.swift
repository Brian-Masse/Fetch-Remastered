//
//  FetchClassicInterpreter.swift
//  Fetch - Remastered
//
//  Created by Brian Masse on 6/25/21.
//  Copyright © 2021 Brian Masse. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class FetchClassicInterpreter: ObservableObject {
    
    @Published private(set) var model = FetchClassic()
    @Published private(set) var preferenceModel = FetchClassicPrefs()
    
    
    //MARK: Quick acess to model
    var currentState: FetchClassic.StateEnum {
        model.currentState
    }
    var modifiers: [Upgradable] {
        model.modifiers
    }
    var dogs: [Dog] {
        get { model.dogs }
        set { model.dogs = newValue
        }
    }
    var balls: [Ball] {
        get { model.balls }
        set { model.balls = newValue }
    }
    var currentDog: CurrentDog {
        get { model.currentDog }
        set { model.currentDog = newValue }
    }
    
    var currentBall: CurrentBall {
        get { model.currentBall }
        set { model.currentBall = newValue }
    }

    var gold: Int {
        Int(model.gold)
    }
    
    var stats: FetchClassic.Stats {
        model.stats
    }
    
    var throwModifier: CGFloat {
        guard let index = model.modifiers.firstIndex(where: { $0.id == model.throwModifier.id }) else { return 0 }
        return model.modifiers[index].value
    }
    
    var goldModifier: Upgradable {
        guard let index = model.modifiers.firstIndex(where: { $0.id == model.goldModifier.id }) else { return model.goldModifier }
        return model.modifiers[index]
    }
    
    func isCurrentType<objectType: gameObject >(_ object: objectType) -> Bool {
        object as? Dog == currentDog.type || object as? Ball == currentBall.type
    }
    
    
    
    
    
    
    
    func temp() {
        model.testGraph += 5
    }
    
    
    
    
    //MARK: Stats:
    
    func duringThrowCheckStats() {
        
        if currentBall.position.y > model.stats[.farthestThrow] {
            model.stats.setData(for: .farthestThrow, with: currentBall.position.y)
        }
        
    }
    
    
    // MARK: Intent Functions:
    
    func canPruchase(cost: Int) -> Bool {
        if cost <= gold {
            changeGold(with: -CGFloat(cost))
            return true
        }else { return false } 
//            showAlert(title: "You do not have enough gold", message: "Try playing with your dog more before spending money :)")
    }
    
    func changeGameSpeed(_ speed: Int) {
        if currentState == .throwing { model.changeGameSpeed(change: speed) }
        else { model.changeGameSpeed(change: 1)}
    }
    
    func changeGold(with change: CGFloat) {
        model.changeGold(change: change)
//        FetchClassic.saveData(data: gold, for: "gold")
    }
    
    func changeState(_ newState: FetchClassic.StateEnum) {
        withAnimation(.easeOut) {
            model.changeState(newState)
        }
    }
    
    func updateAeroModifier() {
        model.updateAeroModifier()
    }
    
    func incrementModifier(_ modifier: Upgradable) {
        if !modifier.maxxed {
            model.incrementModifier(modifier, with: modifier.returnCurrentIncriment() )
            modifier.saveSelf()
            FetchClassic.saveData(data: min(modifier.value + modifier.returnCurrentIncriment(), modifier.maxValue), for: modifier.id + "value")
            FetchClassic.saveData(data: modifier.iteration + 1, for: modifier.id + "iteration")
        }
    }
        
    func chooseObject<objectType: gameObject>(object: objectType) {
        if let dog = object as? Dog {
            var cloneDogs = model.dogs
            model.chooseActiveObjects(newObject: dog, in: &cloneDogs)
            model.dogs = cloneDogs
            
        }else if let ball = object as? Ball  { 
            var cloneBalls = model.balls
            model.chooseActiveObjects(newObject: ball, in: &cloneBalls)
            model.balls = cloneBalls
        }
    }
    
    func chooseNewApperance(_ apperance: FetchClassicPrefs.Appearance) {
        preferenceModel.chooseNewApperance(apperance)
        
    }
}

