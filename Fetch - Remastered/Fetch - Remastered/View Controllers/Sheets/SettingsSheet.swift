//
//  SettingsSheet.swift
//  Fetch - Remastered
//
//  Created by Brian Masse on 8/1/21.
//  Copyright © 2021 Brian Masse. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

struct Settings: View {

    @EnvironmentObject var game: FetchClassicInterpreter
    
    @State var showingWidgetBuilder = false
    
    @ViewBuilder
    
    static func createSettingsText(_ text: String, with font: ShadowedFont, in size: CGFloat, lineLimit: Int = 1) -> some View {
        ShadowFont(text, with: font, in: size, shadowColor: Colors.settingsShadow, lineLimit: lineLimit, lightShadowColor: Colors.settingsShadow, darkShadowColor: Colors.darkTextGrey)
            .modifier(appearancedMod(lightColor: Colors.settingsLightPink, darkColor: .white, colorColor: .white))
    }
    
    static func returnColor() -> Color {
        switch GameView.game.appearance {
        case .light: return .white
        default: return Colors.settingsShadow
        }
    }
    
    var body: some View {
        let appearanceBinding = Binding { game.preferenceModel.appearance } set: { newValue in game.chooseNewApperance(newValue) }
        let cloudDensity = Binding { game.preferenceModel.cloudDensity } set: { newValue in game.chooseNewCloudDensity(newValue) }
        let iconBinding = Binding { game.preferenceModel.icon } set: { newValue in game.changeAppIcon(with: newValue) }
        
        VStack(alignment: .leading) {
            Settings.createSettingsText("Settings", with: titleFont, in: 40).padding(.leading)
            
            emptySpace(with: 1)
            
            ScrollView(.vertical) {
                DesignedButton(accent: .white, design: { Settings.createSettingsText("Widget Builder", with: titleFont, in: 15) }) { showingWidgetBuilder = true }
                    .sheet(isPresented: $showingWidgetBuilder) { WidgetBuilder().environmentObject(GameView.game) }
                    .padding(.horizontal)
                
                
                IconEnumSelector(currentEnumValue: appearanceBinding, title: "Game Appearance", names: [ "Color", "Light", "Dark" ], icons: [ "colorSelector", "lightSelector", "darkSelector"], accent: Colors.settingsShadow) { text, size, lines in Settings.createSettingsText(text, with: titleFont, in: size, lineLimit: lines)  }
                    .modifier(framify(Colors.settingsDarkPink))
                
                EnumSelector(currentEnumValue: cloudDensity, title: "Cloud Density", names: [ "Off", "Light", "Mid", "Heavy" ], accent: Colors.settingsShadow) { text, size, lines in Settings.createSettingsText(text, with: titleFont, in: size, lineLimit: lines) }.modifier(framify(Colors.settingsDarkPink))
                
                EnumSelector(currentEnumValue: iconBinding, title: "Icon Picker", names: [ "Primary", "Second", "Auto"], accent: Colors.settingsShadow) { text, size, lines in
                    VStack {
                        Settings.createSettingsText(text, with: titleFont, in: size, lineLimit: lines)
                        if text != "Icon Picker" {
                            PixelImage(text)
                                .cornerRadius(10)
                                .frame(maxHeight: 50)
                        }
                    }
                }.modifier(framify(Colors.settingsDarkPink))
                
                UIAppearance()
                
                DataManagementView()
                Spacer()
            }
            
        }.background(PixelImage( appearanced( "settingsBack") ).ignoresSafeArea().aspectRatio(contentMode: .fill))
    }
    
    struct UIAppearance: View {
        
        let particlesBinding = Binding { GameView.game.preferenceModel.particles } set: { newValue in GameView.game.toggleParticles() }
        let distanceLabelBinding = Binding { GameView.game.preferenceModel.distanceLabel } set: { newValue in GameView.game.toggleDistanceLabel() }
        let velocityLabelBinding = Binding { GameView.game.preferenceModel.velocityLabel } set: { newValue in GameView.game.toggleVelocityLabel() }
        
        var body: some View {
            
            VStack {
                Settings.createSettingsText("UI Appearance", with: titleFont, in: 20)
                emptySpace(with: 1)
                
                Toggle(displayName: "Particles", currentValue: particlesBinding, design: { text, size, lines in Settings.createSettingsText(text, with: titleFont, in: size, lineLimit: lines) }, accent: Colors.settingsShadow, hasImage: false)
                    .modifier(framify(Colors.settingsDarkPink))
                
                Toggle(displayName: "Distance Label", currentValue: distanceLabelBinding, design: { text, size, lines in Settings.createSettingsText(text, with: titleFont, in: size, lineLimit: lines) }, accent: Colors.settingsShadow, hasImage: false)
                    .modifier(framify(Colors.settingsDarkPink))
                
                Toggle(displayName: "Velocity Label", currentValue: velocityLabelBinding, design: { text, size, lines in Settings.createSettingsText(text, with: titleFont, in: size, lineLimit: lines) }, accent: Colors.settingsShadow, hasImage: false)
                    .modifier(framify(Colors.settingsDarkPink))
            }.modifier(framify(Colors.settingsDarkPink, in: 414, padded: true))
        }
    }
    
    struct DataManagementView: View {
    
        @State var showingSoftWarning = false
        @State var showingHardWarning = false
        @State var showingMergeWarning = false
        
        @EnvironmentObject var game: FetchClassicInterpreter
        
        var body: some View {
            VStack(alignment: .leading) {
                Settings.createSettingsText("Data Management", with: titleFont, in: 20).padding(.bottom)
                
                DesignedButton(accent: returnColor(), design: { Settings.createSettingsText("Merge Legacy Data", with: titleFont, in: 15) }) { showingMergeWarning = true }
                    .alert(isPresented: $showingMergeWarning, content: { Alert(title: Text("Merge Legacy and Current Game?"),
                                                                               message: Text("\nIf you wish to continue from where you left off before you updated, you can merge all of your legacy data, however this is not gaurneteed to be seamless; the game progression may be off, and more importantly less fun! Any data you have collected since updating will be kept in your profile, but all progress will be replaced with your legacy data.\n\n This action cannot be undone."),
                                                                               primaryButton: .destructive(Text("Merge my games")) { game.mergeLegacyData() },
                                                                               secondaryButton: .cancel()) })
                DesignedButton(accent: returnColor(), design: { Settings.createSettingsText("Erase Game Progress", with: titleFont, in: 15) }) { showingSoftWarning = true }
                    .alert(isPresented: $showingSoftWarning, content: { Alert(title: Text("Erase Your Progress?"),
                                                                               message: Text("\nThis will erase all prgress you have made in the game, including all modifiers and gold. Everything else, such as high scores, graphing data, legacy data, and unlocked dogs will be saved in your profile. Do this if you're looking to re-expirience all the great adventure of exploring! \n\n This action cannot be undone."),
                                                                               primaryButton: .destructive(Text("Erase my Progress")) { game.softWipe() },
                                                                               secondaryButton: .cancel()) })
                DesignedButton(accent: returnColor(), design: { Settings.createSettingsText("Erase Game", with: titleFont, in: 15) }) { showingHardWarning = true }
                    .alert(isPresented: $showingHardWarning, content: { Alert(title: Text("Hard Erase Your Game?"),
                                                                               message: Text("\nThis will erase all data associated to your profile except for the legacy data. All progress will be lost, as will be all graphing data, high scores, unlocked dogs, and all other great stuff! Only do this if you are 100% sure you're ready for the fresh start.\n\n This action cannot be undone."),
                                                                               primaryButton: .destructive(Text("Hard Erase my Game")) { game.hardWipe() },
                                                                               secondaryButton: .cancel()) })
            }
            .modifier(framify(Colors.settingsDarkPink, in: 414, padded: true))
                
                
            
        }
    }
}
