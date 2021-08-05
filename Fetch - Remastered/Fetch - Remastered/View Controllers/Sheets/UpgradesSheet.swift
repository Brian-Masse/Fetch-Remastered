//
//  UpgradesSheet.swift
//  Fetch - Remastered
//
//  Created by Brian Masse on 7/17/21.
//  Copyright © 2021 Brian Masse. All rights reserved.
//

import Foundation
import SwiftUI

struct UpgradesSheet: View {
    
    @ObservedObject var viewModel: FetchClassicInterpreter = GameView.game
    
    var body: some View {
        
        GeometryReader { topLevelGeo in
            VStack(alignment: .leading) {
                ShadowFont("Upgrades:", with: titleFont, in: topLevelGeo.size.width * UIConstants.majorTitleSize, lightShadowColor: constants.titleShadow, darkShadowColor: UIConstants.darkShadow)
                    .padding(.leading)
                    .modifier(appearancedMod(lightColor: constants.titleColor, darkColor: UIConstants.darkTextGrey))
                
                ScrollView {
                    ForEach(viewModel.modifiers, id: \.id) { modifier in
                        upgradeBox(object: modifier, topLevelGeo: topLevelGeo, shadowColor: modifier.shadowColor)
                            .modifier(appearancedMod(lightColor: modifier.baseColor, darkColor: UIConstants.darkTextGrey))
                    }
                }
            }
            
        }
        .background(PixelImage(appearanced("UpgradesBack")).ignoresSafeArea().aspectRatio(contentMode: .fill))
    }
    struct constants {
        static let buttonBottomPadding: CGFloat = 0.003
        static let horizontalPadding: CGFloat = 0.03
        static let backgroundPadding: CGFloat = 5
        
        static let tileHeading: CGFloat = 5
        static let tileDescription: CGFloat = 7
        static let tileSlider: CGFloat = 4.2
        
        static let titleColor = Color(UIColor(red: 189 / 255, green: 221 / 255, blue: 246 / 255, alpha: 1))
        static let titleShadow = Color(UIColor(red: 109 / 255, green: 168 / 255, blue: 217 / 255, alpha: 1))
        
        static let throwGreen = Color(UIColor(red: 0, green: 203 / 255, blue: 127 / 255, alpha: 1))
        static let throwShadowGreen = Color(UIColor(red: 8 / 255, green: 108 / 255, blue: 68 / 255, alpha: 1))
        static let aeroPink = Color(UIColor(red: 1, green: 129 / 255, blue: 135 / 255, alpha: 1))
        static let aeroShadowPink = Color(UIColor(red: 216 / 255, green: 44 / 255, blue: 92 / 255, alpha: 1))
        static let goldTengerine = Color(UIColor(red: 1, green: 179 / 255, blue: 144 / 255, alpha: 1))
        static let goldShadowTangerine = Color(UIColor(red: 224 / 255, green: 116 / 255, blue: 124 / 255, alpha: 1))
        
        
        
    }
}


struct upgradeBox: View  {
    
    let object: Upgradable
    let topLevelGeo: GeometryProxy
    let shadowColor: Color
    @State var showingAlert = false
    
    var body: some View {
        ZStack(alignment: .center) {
            PixelImage(appearanced("\(object.id)Back"))
                .padding(.horizontal, UpgradesSheet.constants.backgroundPadding)
        }
            .overlay(
                GeometryReader { geo in
                    VStack(alignment: .leading) {
                        HStack {
                            PixelImage("\(object.id)Icon")
                            ShadowFont(object.title, with: titleFont, in: geo.size.width * UIConstants.minorTitleSize, shadowColor: shadowColor, lightShadowColor: UIConstants.lightShadow, darkShadowColor: UIConstants.darkShadow)
                        }
                        .padding(.top)
                        .frame(maxHeight: geo.size.height / UpgradesSheet.constants.tileHeading)

                        ShadowFont(object.description, with: titleFont, in: geo.size.width * UIConstants.minorTitleSize, shadowColor: shadowColor, lightShadowColor: UIConstants.lightShadow, darkShadowColor: UIConstants.darkShadow)
                            .frame(maxHeight: geo.size.height /  UpgradesSheet.constants.tileDescription)

                        ZStack() {
                            PixelImage("sliderGrey")
                                .overlay(
                                    GeometryReader { sliderGeo in
                                        PixelImage(object.id+"Grad")
                                            .clipShape(clippedRectangle(width: (object.value / object.maxValue) * sliderGeo.size.width ))
                                    })
                            PixelImage(GameView.game.preferenceModel.appearance == .dark ?  "sliderFrameDark": "sliderFrame")
                        }
                        .frame(maxHeight: geo.size.height / UpgradesSheet.constants.tileSlider)
                        .aspectRatio(contentMode: .fit )

                        Button(action: {
                                if GameView.game.canPruchase(cost: object.returnCurrentPrice()) {
                                    GameView.game.incrementModifier(object)
                                }else { showingAlert = true }
                            }) { PixelImage(appearanced("\(object.id)ButtonDown")).opacity(0) }
                        .buttonStyle(PushableButton(object: object, shadowColor: shadowColor))
                        .aspectRatio(contentMode: .fit)
                        .padding(.bottom, geo.size.height * UpgradesSheet.constants.buttonBottomPadding)
                    }
                    .padding(.horizontal, geo.size.width * UpgradesSheet.constants.horizontalPadding)
                }
            )
        .alert(isPresented: $showingAlert) { Alert(title: Text("Not Enough Gold"), message: Text("\nTry playing with your dog to collect some :)\n\nYou only need \(object.returnCurrentPrice() - GameView.game.gold) more!"), dismissButton: .default(Text("Back to Throwing!"))) }
    }
    
    struct ButtonLabelWithText: View {
        let pressed: Bool
        let object: Upgradable
        let shadowColor: Color
        
        var description: String {
            if object.maxxed { return "Maxxed Out!"}
            else { return object.buttonText }
        }
        
        var body: some View {
            GeometryReader { geo in
                if pressed {
                    PixelImage(appearanced(object.id+"ButtonDown"))
                        .aspectRatio(contentMode: .fit)
                        .transition(.identity)
                        .overlay(ShadowFont(description, with: titleFont, in: geo.size.width * UIConstants.minorTitleSize, shadowColor: shadowColor, lightShadowColor: UIConstants.lightShadow, darkShadowColor: UIConstants.darkShadow).padding([.top, .leading, .trailing]))
                }else {
                    PixelImage(appearanced(object.id+"ButtonUp"))
                        .aspectRatio(contentMode: .fit)
                        .transition(.identity)
                        .overlay(ShadowFont(description, with: titleFont, in: geo.size.width * UIConstants.minorTitleSize, shadowColor: shadowColor, lightShadowColor: UIConstants.lightShadow, darkShadowColor: UIConstants.darkShadow).padding([.leading, .bottom, .trailing]))
                }
            }
        }
    }
    
    struct PushableButton: ButtonStyle {
        let object: Upgradable
        let shadowColor: Color
        
        func makeBody(configuration: Configuration) -> some View {
            ZStack {
                configuration.label
                withAnimation() {
                    ButtonLabelWithText(pressed: configuration.isPressed, object: object, shadowColor: shadowColor)
                }
            }
        }
    }
}


struct clippedRectangle: Shape {
    let width: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var newPath = Path()
        newPath.move(to: CGPoint(x: rect.minX, y: rect.minY))
        newPath.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        newPath.addLine(to: CGPoint(x: rect.minX + width, y: rect.maxY))
        newPath.addLine(to: CGPoint(x: rect.minX + width, y: rect.minY))
        newPath.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        
        return newPath
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        UpgradesSheet()
//    }
//}
//
//
