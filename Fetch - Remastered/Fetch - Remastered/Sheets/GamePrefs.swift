//
//  GamePrefs.swift
//  Fetch - Remastered
//
//  Created by Brian Masse on 8/1/21.
//  Copyright © 2021 Brian Masse. All rights reserved.
//

import Foundation
import SwiftUI
import WidgetKit


struct FetchClassicPrefs {
    
    enum CloudDensity: Double, CaseIterable, Codable {
        case off = 5
        case light = 7
        case medium = 2.5
        case heavy = 0.8
    }
    
    enum Icon: Int, CaseIterable, Codable {
        case primaryIcon
        case secondIcon
        case auto
    }
    
    enum Key: String {
        case appearance = "Appearance"
        case cloud = "CloudKey"
        case particles = "particles"
        case icon = "Icon"
        case distanceLabel = "DistanceLabel"
        case velocityLabel = "velocityLabel"
    }
    
    let sharedDefaults = UserDefaults(suiteName: "group.com.Fetch-Remastered.BrianMasse")
    
    @WidgetWrapper(WidgetData(), for: "smallKey") var smallWidgets: [WidgetData]
    @WidgetWrapper(WidgetData(), for: "mediumKey") var mediumWidgets: [WidgetData]
    @WidgetWrapper(WidgetData(), for: "largeKey") var largeWidgets: [WidgetData]
    
    var appearance: Appearance = .color {
        didSet {
            FetchClassic.saveComplexData(data: appearance, for: Key.appearance.rawValue)
            WidgetAcessor.saveComplexData(data: appearance, for: "AppearanceKey")
        }
    }
    
    var icon: Icon = .primaryIcon {
        didSet { FetchClassic.saveComplexData(data: icon, for: Key.icon.rawValue) }
    }
    
    var cloudDensity: CloudDensity = .medium {
        didSet { FetchClassic.saveComplexData(data: cloudDensity, for: Key.cloud.rawValue) }
    }
    
    var particles = true {
        didSet { FetchClassic.saveComplexData(data: particles, for: Key.particles.rawValue) }
    }
    
    var distanceLabel = true {
        didSet { FetchClassic.saveComplexData(data: distanceLabel, for: Key.distanceLabel.rawValue) }
    }
    var velocityLabel = false {
        didSet { FetchClassic.saveComplexData(data: velocityLabel, for: Key.velocityLabel.rawValue) }
    }
    
    
    init() {
        appearance = FetchClassic.retrieveComplexData(defaultValue: .color, for: Key.appearance.rawValue)
        cloudDensity = FetchClassic.retrieveComplexData(defaultValue: .light, for: Key.cloud.rawValue)
        particles = FetchClassic.retrieveComplexData(defaultValue: true, for: Key.particles.rawValue)
        icon = FetchClassic.retrieveComplexData(defaultValue: .primaryIcon, for: Key.icon.rawValue)
        distanceLabel = FetchClassic.retrieveComplexData(defaultValue: true, for: Key.distanceLabel.rawValue)
        velocityLabel = FetchClassic.retrieveComplexData(defaultValue: false, for: Key.velocityLabel.rawValue)

        
        sendWidgets(in: .systemSmall)
        sendWidgets(in: .systemMedium)
        sendWidgets(in: .systemLarge)
    }
    
    func returnActiveListOfWidgets(in size: WidgetFamily) -> [WidgetData] {
        switch size {
        case .systemSmall: return smallWidgets
        case .systemMedium: return mediumWidgets
        case .systemLarge: return largeWidgets
        default: return []
        }
    }
    
    func sendWidgets(in size: WidgetFamily) {
        WidgetAcessor.saveComplexData(returnActiveListOfWidgets(in: size), for: "WidgetList\(size.rawValue)")
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    mutating func saveNewWidget(_ newData: WidgetData, at index: Int, in size: WidgetFamily) {
        switch size {
        case .systemSmall: smallWidgets[index] = newData
        case .systemMedium: mediumWidgets[index] = newData
        case .systemLarge: largeWidgets[index] = newData
        default: break
        }
        sendWidgets(in: size)
    }
    
    mutating func deleteWidget(in size: WidgetFamily, for index: Int) {
        switch size {
        case .systemSmall: smallWidgets.remove(at: index)
        case .systemMedium: mediumWidgets.remove(at: index)
        case .systemLarge: mediumWidgets.remove(at: index)
        default: break
        }
        sendWidgets(in: size)
    }
    
    mutating func addWidget(in size: WidgetFamily, for index: Int) {
        switch size {
        case .systemSmall: smallWidgets.append(WidgetData(in: .systemSmall, for: "small \(index)"))
        case .systemMedium: mediumWidgets.append(WidgetData(in: .systemMedium, for: "medium \(index)"))
        case .systemLarge: largeWidgets.append(WidgetData(in: .systemLarge, for: "large \(index)"))
        default: break
        }
        sendWidgets(in: size)
    }
    
    mutating func chooseNewApperance(_ apperance: Appearance) {
        self.appearance = apperance
    }
    
    mutating func chooseNewCloudDensity(_ density: FetchClassicPrefs.CloudDensity) {
        cloudDensity = density
    }
    
    mutating func changeIcon(_ newIcon: Icon) {
        icon = newIcon
        if newIcon != .auto { UIApplication.shared.setAlternateIconName( newIcon == .primaryIcon ? nil: "\(newIcon.rawValue)", completionHandler: nil) }
        else { UIApplication.shared.setAlternateIconName( max((appearance.rawValue - 1), 0) == 0 ? nil: "1", completionHandler: nil) }
    }

}

@propertyWrapper

struct WidgetWrapper {
    
    var key: String
    var widgetData: [ WidgetData ]
    
    var wrappedValue: [WidgetData] {
        get { return widgetData }
        set { widgetData = newValue
            FetchClassic.saveComplexData(data: widgetData, for: key)
        }
    }
    
    init(_ defaultValue: WidgetData, for key: String ) {
        self.widgetData = FetchClassic.retrieveComplexData(defaultValue: [defaultValue], for: key)
//        self.widgetData = [WidgetData(in: .systemSmall, for: "small widget 0")]
        FetchClassic.saveComplexData(data: widgetData, for: key)
        self.key = key
        
    }
    
}


