//
//  appGroup.swift
//  Fetch - Remastered
//
//  Created by Brian Masse on 8/24/21.
//  Copyright © 2021 Brian Masse. All rights reserved.
//

import Foundation

public enum AppGroup: String {
    
    case main = "group.com.Fetch-Remastered.BrianMasse"
    
    public var containerURL: URL {
        switch self {
        case .main:
            return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: self.rawValue)!
        }
        
    }
    
}
