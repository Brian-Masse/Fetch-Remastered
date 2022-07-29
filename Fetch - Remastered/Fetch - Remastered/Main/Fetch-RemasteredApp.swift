//
//  Fetch-RemasteredApp.swift
//  Fetch - Remastered
//
//  Created by Brian Masse on 6/24/21.
//  Copyright © 2021 Brian Masse. All rights reserved.
//

import SwiftUI

let gameView = GameView()

@main

struct FetchRemastered: App {
    var body: some Scene {
        WindowGroup {
            gameView
                .onAppear() {
                    UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.forEach { windowScene in
                        windowScene.sizeRestrictions?.minimumSize = CGSize(width: 220, height: 440)
                    }
                }
        }
    }
    
    
    
}
