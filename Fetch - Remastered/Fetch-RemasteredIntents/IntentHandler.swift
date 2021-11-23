//
//  IntentHandler.swift
//  Fetch-RemasteredIntents
//
//  Created by Brian Masse on 8/24/21.
//  Copyright © 2021 Brian Masse. All rights reserved.
//

import Intents

var widgetAcessor = WidgetAcessor()

class IntentHandler: INExtension, SmallWidgetConfigurationIntentHandling, MediumWidgetConfigurationIntentHandling, LargeWidgetConfigurationIntentHandling {
    
    func provideSmallWidgetOptionsCollection(for intent: SmallWidgetConfigurationIntent, with completion: @escaping (INObjectCollection<SmallWidget>?, Error?) -> Void) {
        
        widgetAcessor.inquiryWidgets()
        var smallWidgets = widgetAcessor[.smallList].indices.map { index in
            SmallWidget(identifier: "\(index)", display: "Small Widget \(index)")
        }
        smallWidgets.remove(at: 0)
        
        let collection  = INObjectCollection(items: smallWidgets)
        completion(collection, nil)
    }
    
    func provideMediumWidgetOptionsCollection(for intent: MediumWidgetConfigurationIntent, with completion: @escaping (INObjectCollection<MediumWidget>?, Error?) -> Void) {
        
        widgetAcessor.inquiryWidgets()
        var mediumWidgets = widgetAcessor[.mediumList].indices.map { index in
            MediumWidget(identifier: "\(index)", display: "Medium Widget \(index)")
        }
        mediumWidgets.remove(at: 0)
        
        let collection  = INObjectCollection(items: mediumWidgets)
        completion(collection, nil)
    }
    
    func provideParameterOptionsCollection(for intent: LargeWidgetConfigurationIntent, with completion: @escaping (INObjectCollection<LargeWidget>?, Error?) -> Void) {
        
        
        widgetAcessor.inquiryWidgets()
        var largeWidgets = widgetAcessor[.largeList].indices.map { index in
            LargeWidget(identifier: "\(index)", display: "Large Widget \(index)")
        }
        largeWidgets.remove(at: 0)
        
        let collection  = INObjectCollection(items: largeWidgets)
        completion(collection, nil)
    }
}
