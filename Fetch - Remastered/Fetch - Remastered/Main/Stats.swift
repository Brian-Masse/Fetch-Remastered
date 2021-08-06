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

extension FetchClassic {
    class Stats {
        
        @Graphable(5, for: "testing") var test
        
        enum SubscriptAcessor: Int {
            case farthestThrow = 0
            case fastestThrow = 1
        }
        
        var propertyList: [CGFloat] = [0, 0]
        
        subscript( propertyName: SubscriptAcessor ) -> CGFloat {
            get { propertyList[propertyName.rawValue] }
            set { propertyList[propertyName.rawValue] = newValue }
        }
        
        
        //MARK: Saving Data
        func retrieveSelf() {
            for index in propertyList.indices {
                propertyList[index] = FetchClassic.retrieveData(defaultValue: 0, for: "\(index)")
            }
        }
        
        func saveSelf() {
            test += 1
            for index in propertyList.indices {
                FetchClassic.saveData(data: propertyList[index], for: "\(index)")
            }
        }
        
        //MARK: General Functions:
        
        func setData(for property: SubscriptAcessor, with value: CGFloat) {
            self[property] = value
            saveSelf()
        }
        
        
        
        init() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                self.retrieveSelf()
            
            }
            
        }
    }
}

@propertyWrapper

struct Graphable {
    
    private let key: String
    var projectedValue: [ GraphablePoint ] = [  GraphablePoint(value: 0, date: Date()) ]
    
    
    
    init(_ wrappedValue: CGFloat, for key: String) {
        projectedValue = FetchClassic.retrieveComplexData(defaultValue: [], for: key)
        if projectedValue.count == 0 { projectedValue.append(GraphablePoint(value: wrappedValue , date: Date())) }
        self.key = key
    }
    
    var wrappedValue: CGFloat {
        get  { projectedValue.last!.value }
        set {
            projectedValue.append( GraphablePoint(value: newValue, date: Date())  )
            FetchClassic.saveComplexData(data: projectedValue, for: key)
        }
    }
}

struct GraphablePoint: Codable {
    let value: CGFloat
    let date: Date
}
