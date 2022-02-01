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
    
    @EnvironmentObject var game: FetchClassicInterpreter
    
    var body: some View {
        
        GeometryReader { topLevelGeo in
            VStack(alignment: .leading) {
                ShadowFont("Upgrades:", with: titleFont, in: 40, lightShadowColor: constants.titleShadow, darkShadowColor: Colors.darkShadow)
                    .padding(.leading)
                    .minimumScaleFactor(0.1)
                    .modifier(appearancedMod(lightColor: constants.titleColor, darkColor: .white))
                    
                
                ScrollView {
                    ForEach(game.modifiers, id: \.id) { modifier in
                        upgradeBox(object: modifier, topLevelGeo: topLevelGeo)
                            .padding(5)
                            .modifier(appearancedMod(lightColor: modifier.lightFontColor, darkColor: .white))
                    }
                    Spacer()
                }
            }
        }
        .background(PixelImage(appearanced("UpgradesBack")).aspectRatio(contentMode: .fill).ignoresSafeArea())
    }
    struct constants {
        static let paddedWidth: CGFloat = 0.93
        
        static let titleColor = Color(UIColor(red: 189 / 255, green: 221 / 255, blue: 246 / 255, alpha: 1))
        static let titleShadow = Color(UIColor(red: 109 / 255, green: 168 / 255, blue: 217 / 255, alpha: 1))
        
        @ViewBuilder
        static func createModifierText(_ modifier: Upgradable, for text: String, with font: ShadowedFont = titleFont, in size: CGFloat, lineLimit: Int = 1) -> some View {
            ShadowFont(text, with: font, in: size, shadowColor: modifier.darkShadow, lineLimit: lineLimit, lightShadowColor: modifier.lightShadow, darkShadowColor: modifier.darkShadow)
                .minimumScaleFactor(0.1)
        }
        
    }
    
    struct upgradeBox: View  {
        
        let object: Upgradable
        let topLevelGeo: GeometryProxy
        
        @State var showingAlert = false
        @EnvironmentObject var game: FetchClassicInterpreter
        
        var body: some View {
            VStack(alignment: .leading) {
                HStack {
                    PixelImage("\(object.id)Icon").frame(maxWidth: 55)
                    constants.createModifierText(object, for: object.title, in: 25)
                }
                constants.createModifierText(object, for: object.description, in: 20, lineLimit: 2)

                PixelImage("sliderGrey")
                    .overlay(
                        GeometryReader { sliderGeo in
                            PixelImage( game.appearance == .light ? object.id+"GradLight": object.id+"Grad" )
                                .clipShape(clippedRectangle(width: (object.value / object.maxValue) * sliderGeo.size.width ))
                        })
                    .frame(maxWidth: topLevelGeo.size.width * constants.paddedWidth)
                    .aspectRatio(contentMode: .fill)
                    .modifier(framify(object.darkShadow, in: 414, padded: false))
            
                Spacer()
                Button(action: {
                    if game.canPruchase(cost: object.returnCurrentPrice(), for: false) { game.incrementModifier(object) }
                    else { showingAlert = true }
                }) {
                    PixelImage(appearanced("\(object.id)ButtonDown")).opacity(0).aspectRatio(contentMode: .fill).frame(maxWidth: topLevelGeo.size.width * constants.paddedWidth)
                }
                .buttonStyle(PushableButton(object: object, topLevelGeo: topLevelGeo))
            }
            .modifier(framify(object.darkShadow, in: 414) { Image( appearanced("\(object.id)Back")).resizable().interpolation(.none)  })
            .alert(isPresented: $showingAlert) { Alert(title: Text("Not Enough Gold"), message: Text("\nTry playing with your dog to collect some :)\n\nYou only need \(object.returnCurrentPrice() - game.gold) more!"), dismissButton: .default(Text("Back to Throwing!"))) }
        }
    
        struct PushableButton: ButtonStyle {
            let object: Upgradable
            let topLevelGeo: GeometryProxy
            
            var description: String {
                if object.maxxed { return "Maxxed Out!"}
                else { return object.buttonText}
            }
            
            func makeBody(configuration: Configuration) -> some View {
//                GeometryReader { geo in
                    let maxxedBinding = Binding { object.maxxed } set: { _ in }
                    ZStack( alignment: configuration.isPressed ? .bottom : .top) {
                        PixelImage(object.id+"ButtonUp").frame(maxWidth: topLevelGeo.size.width * constants.paddedWidth).opacity(configuration.isPressed ? 0 : 1)
                        PixelImage(object.id+"ButtonDown").frame(maxWidth: topLevelGeo.size.width * constants.paddedWidth).overlay(GeometryReader { geo in
                            HStack {
                                Spacer()
                                if object.maxxed { BouncingText(shouldAnimate: maxxedBinding, text: "Maxxed!", stallTime: 5, width: geo.size.width) { text in UpgradesSheet.constants.createModifierText(object, for: text, in: 20) }
                                }else { UpgradesSheet.constants.createModifierText(object, for: "\(object.buttonText)", in: 20).foregroundColor(.white) }
                                Spacer()
                            }
                            .padding(.top, 5)
                            .minimumScaleFactor(0.1)
                            .padding(.horizontal)
                        }.modifier(framify(object.darkShadow, in: 414, padded: false, opacity: configuration.isPressed ? 1: 0)) )
                    }.animation(nil).modifier(framify(object.darkShadow, in: 414, padded: false, opacity: configuration.isPressed ? 0: 1).animation(nil))
//                }
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
//            .environmentObject(GameView.game)
//    }
//}

//
