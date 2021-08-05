//
//  SettingsSheet.swift
//  Fetch - Remastered
//
//  Created by Brian Masse on 8/1/21.
//  Copyright © 2021 Brian Masse. All rights reserved.
//

import Foundation
import SwiftUI

struct Settings: View {

    var darkBinding = Binding { GameView.game.preferenceModel.appearance == .dark } set: { _ in }
    var lightBinding = Binding { GameView.game.preferenceModel.appearance == .light } set: { _ in }
    var colorBinding = Binding { GameView.game.preferenceModel.appearance == .color } set: { _ in }
    
    var body: some View {
        
        VStack {
            selector(imageNamed: "MickeySit1", text: "dark Mode", toggled: darkBinding) { GameView.game.chooseNewApperance(.dark) }
            
            selector(imageNamed: "MickeySit1", text: "Light Mode", toggled: lightBinding) {  GameView.game.chooseNewApperance(.light) }
            
            selector(imageNamed: "MickeySit1", text: "Default", toggled: colorBinding) { GameView.game.chooseNewApperance(.color) }
        }
        
        
    }
}

struct selector: View {
    
    let imageNamed: String
    let text: String
    @Binding var toggled: Bool
    
    let tapGesture: () -> Void
    
    var body: some View {
        
        HStack {
            PixelImage(imageNamed)
            Text(text)
            Spacer()
            PixelImage( toggled ? "fullSelector" : "openSelector" )
            
        }.onTapGesture {
            tapGesture()
        }
    }
    
    
}
