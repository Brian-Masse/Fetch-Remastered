//
//  FetchClassicInterpreter.swift
//  Fetch - Remastered
//
//  Created by Brian Masse on 6/25/21.
//  Copyright © 2021 Brian Masse. All rights reserved.
//

import Foundation
import SwiftUI
import WidgetKit
import Combine

class FetchClassicInterpreter: ObservableObject {
    
    @Published private(set) var model = FetchClassic() {
        didSet { onModelChanged(oldValue, model) }
    }
    @Published private(set) var preferenceModel = FetchClassicPrefs()
    
    let onModelChanged: (_ old: FetchClassic, _ new: FetchClassic) -> Void
    
    //MARK: Quick acess to model
    var currentState: FetchClassic.StateEnum {
        model.currentState
    }
    var masterState: FetchClassic.StateEnum {
        model.masterState
    }
    var modifiers: [Upgradable] {
        get { model.modifiers }
        set { model.modifiers = newValue }
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
        get { Int(model.gold) }
        set { model.setGold(with: CGFloat(newValue))}
    }
    
    var stats: FetchClassic.Stats {
        model.stats
    }
    
    var appearance: Appearance {
        get { preferenceModel.appearance }
        set { preferenceModel.appearance = newValue }
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
    
    func dismissLegacyDataFoundAlert(with merging: Bool) {
        FetchClassic.saveData(data: true, for: "askedAboutMerging")
        if merging {
            mergeLegacyData()
        }
    }
    
    func mergeLegacyData() {
        softWipe()
        
        model.mergeLegacyUnlocks()
        model.setupLists()
        
        model.setGold(with: stats.legacyCurrentGold)
        
        self[.throwModifier].value = stats.legacyStrength
        self[.aeroModifier].value = stats.legacyAero
        self[.goldModifier].value = stats.legacyMagnet
    }
    
    //MARK: erasing data
    
    func softWipe() {
        model.setGold(with: 100)
                
        softWipeModifier(.throwModifier, with: FetchClassic.ThrowModifier.defaultValue)
        softWipeModifier(.aeroModifier, with: FetchClassic.AeroModifier.defaultValue)
        softWipeModifier(.goldModifier, with: FetchClassic.GoldModifier.defaultValue)
    }
    
    func hardWipe() {
        
        model.setGold(with: 100)
        
        softWipeModifier(.throwModifier, with: FetchClassic.ThrowModifier.defaultValue, true)
        softWipeModifier(.aeroModifier, with: FetchClassic.AeroModifier.defaultValue, true)
        softWipeModifier(.goldModifier, with: FetchClassic.GoldModifier.defaultValue, true)
        
        for enumeration in model.dogs.enumerated() { eraseGameObject(&model.dogs[enumeration.offset]) }
        model.dogs[model.defaultDog].isCurrent = true
        model.dogs[model.defaultDog].isUnlocked = true
        
        for enumeration in model.balls.enumerated() { eraseGameObject(&model.balls[enumeration.offset]) }
        model.balls[model.defaultBall].isCurrent = true
        model.balls[model.defaultBall].isUnlocked = true
        
        for enumeration in stats.propertyList.enumerated() {
            stats.propertyList[enumeration.offset].erase()
        }
    }
    
    func eraseGameObject<objectType: gameObject>(_ object: inout objectType) {
        object.isCurrent = false
        object.isUnlocked = false
        FetchClassic.saveComplexData(data: object, for: "\(object.id)")
    }

    
    func softWipeModifier(_ modifier: ModifierSubscriptAcessor, with defaultValue: CGFloat, _ hard: Bool = false) {
        
        self[modifier].maxxed = false
        self[modifier].value = defaultValue
        self[modifier].iteration = 0
        self[modifier].saveSelf()
        
        FetchClassic.saveData(data: self[modifier].iteration, for: self[modifier].id + "iteration")
        FetchClassic.saveData(data: self[modifier].maxxed, for: self[modifier].id + "maxxed")
        
        if hard {
            stats[ self[modifier].accessor, true ].erase()
        }
        
    }

    
    
    enum ModifierSubscriptAcessor: Int {
        case throwModifier = 0
        case aeroModifier = 1
        case goldModifier = 2
    }
    
    subscript(_ acessor: ModifierSubscriptAcessor) -> Upgradable {
        get { modifiers[acessor.rawValue] }
        set { modifiers[acessor.rawValue] = newValue }
    }
    
    init( onModelChanged: @escaping (_ old: FetchClassic, _ new: FetchClassic) -> Void = { _, _ in  }  ) {
        self.onModelChanged = onModelChanged
    }
    
    //MARK: Stats:
    
    func findNewAverage(shortened: Bool = true) -> CGFloat {
        if shortened {
            return (stats[.distanceAverage] + model.stats[.throwDistance]) / 2
        }else {
            var sum: CGFloat = 0
            for point in stats[.throwDistance, true].history {
                sum += point.value
            }
            return sum / CGFloat(stats[.throwDistance, true].history.count)
        }
    }
    
    func duringThrowCheckStats() {
        
    }
    
    func updateStatsAtEndOfThrow() {
        if currentBall.position.y > model.stats[.farthestThrow] {
            model.stats[.farthestThrow] = currentBall.position.y
        }
        model.stats[.throwDistance] = currentBall.position.y
        model.stats[.distanceAverage] = findNewAverage()
    }
    
    func updateStatsAtStartOfThrow() {
        
        if currentBall.physicsBody!.velocity.dy > model.stats[.fastestThrow] {
            model.stats[.fastestThrow] = currentBall.physicsBody!.velocity.dy
        }
        
    }
    
    
    // MARK: Intent Functions:
    
    func canPruchase(cost: Int, for unlocked: Bool) -> Bool {
        if cost <= gold && !unlocked {
            changeGold(with: -CGFloat(cost))
            return true
        }else { return false } 
//            showAlert(title: "You do not have enough gold", message: "Try playing with your dog more before spending money :)")
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
        }
        FetchClassic.saveData(data: modifier.iteration + 1, for: modifier.id + "iteration")
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
    
    func returnStringedAppearance(_ appearance: Appearance) -> String {
        switch appearance {
        case .color:
            return ""
        case .light:
            return "Light"
        case .dark:
            return "Dark"
        }
    }
    
    func returnColorFromAppearance() -> Color {
        switch appearance {
        case .color: return Colors.settingsShadow
        case .light: return .white
        case .dark: return .black
        }
    }
    
    
    //MARK: Preference intents
    
    func deleteWidget(in size: WidgetFamily, for index: Int) {
        preferenceModel.deleteWidget(in: size, for: index)
    }
    
    func addWidget(in size: WidgetFamily, for index: Int) {
        preferenceModel.addWidget(in: size, for: index)
    }
    
    func saveNewWidget(_ newData: WidgetData, at index: Int, in size: WidgetFamily) {
        preferenceModel.saveNewWidget(newData, at: index, in: size)
    }
    
    func chooseNewApperance(_ apperance: Appearance) {
        preferenceModel.chooseNewApperance(apperance)
        widgetAcessor.updateAppearance(with: appearance)
        if preferenceModel.icon == .auto { preferenceModel.changeIcon(.auto) }
    }
    
    func chooseNewCloudDensity(_ density: FetchClassicPrefs.CloudDensity) {
        preferenceModel.chooseNewCloudDensity(density)
    }
    
    func toggleParticles() {
        preferenceModel.particles.toggle()
    }
    
    func toggleDistanceLabel() {
        preferenceModel.distanceLabel.toggle()
    }
    func toggleVelocityLabel() {
        preferenceModel.velocityLabel.toggle()
    }
    
    func changeAppIcon(with icon: FetchClassicPrefs.Icon) {
        preferenceModel.changeIcon(icon)
    }
}

