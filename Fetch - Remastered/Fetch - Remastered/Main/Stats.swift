//
//  CurrentThrowAndStats.swift
//  Fetch - Remastered
//
//  Created by Brian Masse on 7/29/21.
//  Copyright © 2021 Brian Masse. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import WidgetKit

extension FetchClassic {
    class Stats {
        
        
        let legacyFarthestThrow: CGFloat
        let legacyMostGold: CGFloat
        let legacyCurrentGold: CGFloat
        let legacyStrength: CGFloat
        let legacyAero: CGFloat
        let legacyMagnet: CGFloat
        let legacyMapDiscovered: CGFloat
        
        var updatingWidgetDataList: [UpdatingWidgetData] {
            willSet { FetchClassic.saveComplexData(data: newValue, for: "updatingWidgetDataList") }
        }
        
        enum SubscriptAcessor: Int, Codable {
            case farthestThrow
            case fastestThrow
            case throwDistance
            case distanceAverage
            
            case mostGold
            case biggestPruchase
            case gold
            
            case throwModifier
            case aeroModifier
            case goldModifier
        
        }
        
        lazy var propertyList: [Test] = [Test(0, for: "GraphableFarthestThrow", with: "Farthest Throw"),
                                         Test(0, for: "GraphableFastestThrow", with: "Fastest Throw"),
                                         Test(0, for: "GraphableThrowDistance", with: "Last Throw"),
                                         Test(0, for: "GraphableDistanceAverage", with: "Average Throw Distance"),
                                         Test(0, for: "GraphableMostGold", with: "Most Gold"),
                                         Test(0, for: "GraphableBiggestPurchasre", with: "Biggest Purchase"),
                                         Test(500, for: "GraphableGoldKey", with: "Current Gold"),
                                         Test(ThrowModifier.defaultValue, for: "throwModifierKey", with: "Throw Strength"),
                                         Test(AeroModifier.defaultValue, for: "aeroModifierKey", with: "Aero Dynamics"),
                                         Test(GoldModifier.defaultValue, for: "goldModifierKey", with: "Gold Magnet")] {
            willSet { sendDataToWidgets() }
        }
        
        func sendDataToWidgets() {
            for data in updatingWidgetDataList {
                if String(data.key.first!) == "\(WidgetData.DataType.data.rawValue)" {
                    WidgetAcessor.saveData(data: "\(self.propertyList[data.accessorIndex].value.trimCGFloat(2))", for: data.key)
                    WidgetAcessor.saveData(data: "\(self.propertyList[data.accessorIndex].displayName)", for: data.key+"1")
                    WidgetCenter.shared.reloadAllTimelines()
                }
            }
        }
        
        subscript( propertyName: SubscriptAcessor ) -> CGFloat {
            get { propertyList[propertyName.rawValue].value }
            set { propertyList[propertyName.rawValue].value = newValue }
        }
        
        subscript( propertyName: SubscriptAcessor, returningStruct: Bool ) -> Test {
            get { propertyList[propertyName.rawValue] }
            set { propertyList[propertyName.rawValue] = newValue }
        }
        
        subscript( returningIndex: Bool, propertyName: SubscriptAcessor) -> Int {
            get { propertyName.rawValue }
        }

        func createWidgetDataIdentifierAndKey(propertyIndex: Int, at dataPosition: WidgetData.DataPosition, in size: WidgetFamily, as dataType: WidgetData.DataType) {
            let newData = UpdatingWidgetData(dataType: dataType, accessorIndex: propertyIndex, widgetSize: size, dataPosition: dataPosition)
            
            func returnRelevantComponents(_ string: String) -> String {
                var stringCopy = string
                stringCopy.removeLast(1)
                return stringCopy
            }
            
            guard let replacingIndex = updatingWidgetDataList.firstIndex(where: { returnRelevantComponents($0.key) == returnRelevantComponents(newData.key) }) else {
                updatingWidgetDataList.append(newData)
                return
            }
            updatingWidgetDataList[replacingIndex] = newData
        }
        
        init() {
            legacyFarthestThrow = FetchClassic.retrieveData(defaultValue: 0, for: "farthestThrow")
            legacyMostGold = FetchClassic.retrieveData(defaultValue: 0, for: "mostGold")
            legacyCurrentGold = FetchClassic.retrieveData(defaultValue: 0, for: "SavedGold")
            legacyStrength = max( FetchClassic.retrieveData(defaultValue: 0, for: "SavedModifier"), 10)
            legacyAero = FetchClassic.retrieveData(defaultValue: 0, for: "friction") / 100
            legacyMagnet = max(FetchClassic.retrieveData(defaultValue: 0, for: "SavedProbability") / 100, 1)
            legacyMapDiscovered = FetchClassic.retrieveData(defaultValue: 0, for: "Discovered")
            
            updatingWidgetDataList = FetchClassic.retrieveComplexData(defaultValue: [UpdatingWidgetData(dataType: .data, accessorIndex: 0, widgetSize: .systemSmall, dataPosition: .topLeft)], for: "updatingWidgetDataList")

        }
    }
}

//tells the stats class how to get what to send how to send it
struct UpdatingWidgetData: Codable {
    let dataType: WidgetData.DataType
    let accessorIndex: Int
    let widgetSize: WidgetFamily
    let dataPosition: WidgetData.DataPosition
    var key: String { "\(dataType.rawValue)\(accessorIndex)" }
}

struct Test: Equatable, Codable {
    
    //To Treat this Struct like a CGFloat
    
    static func + (lhs: Self, rhs: CGFloat) -> Self {
        var copy = lhs
        copy.value += rhs
        return copy
    }
    static func += (lhs: inout Self, rhs: CGFloat) {  lhs.value += rhs }
    static func - (lhs: Self, rhs: CGFloat) -> Self {
        var copy = lhs
        copy.value -= rhs
        return copy
    }
    static func -= (lhs: inout Self, rhs: CGFloat) { lhs.value -= rhs }
    static func == (lhs: Test, rhs: Test) -> Bool { lhs.value == rhs.value }
    
    let displayName: String
    private let key: String
    private(set) var history: [ GraphablePoint ] = [  GraphablePoint(value: 0, date: Date()) ]
    
    //handles saves whenever a change is made
    
    var value: CGFloat {
        get { history.last!.value }
        set {
//            if newValue != history.last!.value {
                history.append( GraphablePoint(value: newValue, date: Date())  )
                FetchClassic.saveComplexData(data: history, for: key)
//            }
        }
    }
    
    mutating func erase() {
        defaults.removeObject(forKey: key)
        history = [  GraphablePoint(value: history.first!.value, date: Date()) ]
        
    }
    
    //handles the retrieving whenever someting is init
    
    init(_ value: CGFloat, for key: String, with displayName: String) {
        history = FetchClassic.retrieveComplexData(defaultValue: [GraphablePoint(value: value , date: Date())], for: key)
        
        self.key = key
        self.displayName = displayName
    }
}

struct GraphablePoint: Codable {
    let value: CGFloat
    let date: Date
}
