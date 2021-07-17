//
//  FetchClassicInterpreter.swift
//  Fetch - Remastered
//
//  Created by Brian Masse on 6/25/21.
//  Copyright © 2021 Brian Masse. All rights reserved.
//

import Foundation
import SwiftUI

class FetchClassicInterpreter: ObservableObject {
    
    @Published private(set) var model = FetchClassic()
    var currentState: FetchClassic.StateEnum {
        model.currentState
    }
    var dogs: [Dog] {
        get { model.dogs }
        set { model.dogs = newValue
            print("this list is being set")
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
        model.gold
    }
    
    
    func isCurrentType<objectType: gameObject >(_ object: objectType) -> Bool {
        object as? Dog == currentDog.type || object as? Ball == currentBall.type
    }
    
    // MARK: Intent Functions:
    
    func changeGold(with change: Int) {
        model.changeGold(change: change)
    }
    
    func changeState(_ newState: FetchClassic.StateEnum) {
        model.changeState(newState)
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
}

