//
//  GamePrefs.swift
//  Fetch - Remastered
//
//  Created by Brian Masse on 8/1/21.
//  Copyright © 2021 Brian Masse. All rights reserved.
//

import Foundation


struct FetchClassicPrefs {
    
    let appearanceKey = "Appearance"
    
    enum Appearance: Int {
        case light
        case color
        case dark

    }
    
    var appearance: Appearance = .color {
        didSet {
            FetchClassic.saveData(data: appearance.rawValue, for: appearanceKey)
        }
    }
    
    init() {
        let rawValue = FetchClassic.retrieveData(defaultValue: 1, for: appearanceKey)
        appearance = Appearance(rawValue: rawValue)!
    }
    
    mutating func chooseNewApperance(_ apperance: Appearance) {
        self.appearance = apperance
        
    }
}
