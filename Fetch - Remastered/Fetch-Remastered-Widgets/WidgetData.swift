//
//  WidgetData.swift
//  Fetch - Remastered
//
//  Created by Brian Masse on 8/31/21.
//  Copyright © 2021 Brian Masse. All rights reserved.
//

import Foundation
import WidgetKit
import SwiftUI

public struct WidgetData: Codable {
    
    enum DataPosition: Int, Codable {
        case topLeft
        case topRight
        case bottomLeft
        case bottomRight
    }
    
    enum DataType: Int, Codable {
        case data
        case ball
        case dog
    }
   
    let size: WidgetFamily
    let name: String
    
    var backOpacity: CGFloat = 1
    var backBackOpacity: CGFloat = 1
    var background: String = "rgba(255,255,255,255)"
    var backBackGround: String = "rgba(255,255,255,255)"
    var fontColor: [ CGFloat ] = [ 0, 0, 0, 255 ]
    var shadowColor: [ CGFloat ] = [ 0, 0, 0, 127.5 ]
    
    var fourDataPoints: [SubData] = [
        SubData(dataType: .data, value: "Default Data", displayName: "Default Widget"),
        SubData(dataType: .data, value: "Default Data", displayName: "Default Widget"),
        SubData(dataType: .data, value: "Default Data", displayName: "Default Widget"),
        SubData(dataType: .data, value: "Default Data",displayName: "Default Widget")]
    
    var listAccessorKeyBuilders: [Int?] = [nil, nil, nil, nil]
    var dataTypeKeyBuilders: [DataType?] = [nil, nil, nil, nil]

    mutating func inquiryData() {
        retrieveData(at: .topLeft)
        retrieveData(at: .topRight)
        retrieveData(at: .bottomLeft)
        retrieveData(at: .bottomRight)
    }
    
    mutating func retrieveData(at position: DataPosition) {
        
        guard let listAccessor = listAccessorKeyBuilders[position.rawValue] else { return }
        guard let dataType  = dataTypeKeyBuilders[position.rawValue] else { return }
        
        let key = "\(dataType.rawValue)\(listAccessor)"
        
        self[position].value = WidgetAcessor.retrieveData(defaultValue: "Place Holder Data", for: key)
        self[position].displayName = WidgetAcessor.retrieveData(defaultValue: "Place Holder Data", for: key+"1")
        self[position].dataType = dataType
    }
    
    mutating func updateKeyBuilders(listAccessor: Int, as dataType: DataType, for dataPosition: DataPosition) {
        listAccessorKeyBuilders[dataPosition.rawValue] = listAccessor
        dataTypeKeyBuilders[dataPosition.rawValue] = dataType
    }
    
    init( in size: WidgetFamily, for name: String) {
        self.size = size
        self.name = name
        self.inquiryData()
    }

    init() {
        self.size = .systemSmall
        self.name = "blank initialization"
    }
    
    subscript(position: DataPosition) -> SubData {
        get { fourDataPoints[position.rawValue] }
        set { fourDataPoints[position.rawValue] = newValue }
    }
    
    struct SubData: Codable {
        var dataType: DataType
        var value: String
        var displayName: String
    }
}


public class WidgetAcessor: ObservableObject {
    
    enum WidgetListsAccessor: Int {
        case smallList
        case mediumList
        case largeList
    }
    
    private(set) var widgetLists: [ [WidgetData] ] = []
    @Published private(set) var appearance: Appearance = .color
    
    private var smallWidgetList: [WidgetData] = []
    private var mediumWidgetList: [WidgetData] = []
    private var largeWidgetList: [WidgetData] = []
    
    subscript(accessor: WidgetListsAccessor) -> [WidgetData] {
        get { widgetLists[accessor.rawValue] }
        set { widgetLists[accessor.rawValue] = newValue }
    }
    
    
    static let sharedDefaults = UserDefaults(suiteName: "group.com.Fetch-Remastered.BrianMasse")!
    
    static func saveData<testType>(data: testType, for key: String) {
        sharedDefaults.setValue(data, forKey: key)
    }
    
    static func retrieveData<testType>(defaultValue: testType, for key: String) -> testType {
        guard let value = sharedDefaults.value(forKey: key) as? testType else {return defaultValue}
        return value
    }
    
    static func saveComplexData<testType>(data: testType, for key: String) where testType: Codable {
        let encodedData = try! JSONEncoder().encode(data)
        WidgetAcessor.sharedDefaults.setValue(encodedData, forKey: key)
    }
    
    static func retrieveComplexData<testType>(defaultValue: testType, for key: String) ->  testType where testType: Codable {
        guard let retrievedData = WidgetAcessor.sharedDefaults.value(forKey: key) as? Data else { return defaultValue}
        let decodedData = try! JSONDecoder().decode(testType.self, from: retrievedData)
        return decodedData
    }
    
    static func saveComplexData<testType>(_ value: testType, for key: String) where testType: Codable {
        guard let encodedData = try? JSONEncoder().encode(value) else { return }
        WidgetAcessor.sharedDefaults.setValue(encodedData, forKey: key)
    }
    
    init() {
        widgetLists = [ smallWidgetList, mediumWidgetList, largeWidgetList ]
        
//        WidgetAcessor.sharedDefaults.removeObject(forKey: "WidgetList\(WidgetFamily.systemSmall.rawValue)")
//        WidgetAcessor.sharedDefaults.removeObject(forKey: "WidgetList\(WidgetFamily.systemMedium.rawValue)")
//        WidgetAcessor.sharedDefaults.removeObject(forKey: "WidgetList\(WidgetFamily.systemLarge.rawValue)")
        
        inquiryWidgets()
        appearance = WidgetAcessor.retrieveComplexData(defaultValue: .color, for: "AppearanceKey")
    }
    
    func updateAppearance(with newAppearance: Appearance) {
        appearance = newAppearance
    }
    
    func inquiryWidgets() {
        self[.smallList] = WidgetAcessor.retrieveComplexData(defaultValue: [WidgetData(in: .systemSmall, for: "small 0")], for: "WidgetList\(WidgetFamily.systemSmall.rawValue)")
        
        self[.mediumList] = WidgetAcessor.retrieveComplexData(defaultValue: [WidgetData(in: .systemMedium, for: "medium 0")], for: "WidgetList\(WidgetFamily.systemMedium.rawValue)")

        self[.largeList] = WidgetAcessor.retrieveComplexData(defaultValue: [WidgetData(in: .systemLarge, for: "large 0")], for: "WidgetList\(WidgetFamily.systemLarge.rawValue)")
    }
}

extension WidgetFamily: Codable, CaseIterable {
    public static var allCases: [WidgetFamily] = [ .systemSmall, .systemMedium, .systemLarge ]
}
