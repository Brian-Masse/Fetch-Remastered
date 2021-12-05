//
//  Sheets.swift
//  Fetch - Remastered
//
//  Created by Brian Masse on 6/25/21.
//  Copyright © 2021 Brian Masse. All rights reserved.
//

import SwiftUI

struct CosmeticsSheet: View {
    
    @EnvironmentObject var game: FetchClassicInterpreter
    
    @ViewBuilder
    static func createCosmeticsText(_ text: String, with font: ShadowedFont, in size: CGFloat, lineLimit: Int = 1) -> some View {
        ShadowFont(text, with: font, in: size, shadowColor: Colors.cosmeticsShadow, lineLimit: lineLimit, lightShadowColor: Colors.cosmeticsLighShadow, darkShadowColor: Colors.darkShadow)
            .modifier(appearancedMod(lightColor: Colors.cosmeticsLightColor, darkColor: .white))
    }
    
    @ViewBuilder
    static func createGlow() -> some View {
        PixelImage(appearanced("glow"))
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading) {
                
                CosmeticsSheet.createCosmeticsText("Cosmetics:", with: titleFont, in: 40)
                    .padding([.top, .leading])
                            
                GeometryReader() { geometry in
                    ScrollView(.vertical) {
                        VStack {
                            CosmeticsDisplayer(dog: game.model.currentDog.type, ball: game.model.currentBall.type, width: geometry.size.width)
                            SkinSelector(title: "Dog Skins:", objectList: game.model.dogs, inWidth: geo.size.width, costAccessorObject: game.dogs[0])
                            Spacer(minLength: 30)
                            SkinSelector(title: "Ball Skins:", objectList: game.model.balls, inWidth: geo.size.width, costAccessorObject: game.balls[0])
                            
                        }
                        .frame(width: geometry.size.width)
                    }
                }
            }
            .background(Image(appearanced("CosmeticBack")).resizable().ignoresSafeArea())
        }
        
        
    }
    struct constants {
        static let iconsPerRow: CGFloat = 3
        static let verticalCardSpacing: CGFloat = 5
        
        static let cardText: CGFloat = 0.14
        static let tilePadding: CGFloat = 0.008
        static let topPadding: CGFloat = 100
    }
}

struct SkinSelector<objectType: gameObject>: View{
    
    @EnvironmentObject var game: FetchClassicInterpreter
    
    let title: String
    let objectList: [objectType]
    let inWidth: CGFloat
    
    @State var showingAlert = false
    @State var costAccessorObject: objectType

    var body: some View {
        VStack(alignment: .leading) {
            CosmeticsSheet.createCosmeticsText(title, with: titleFont, in: 30)
                .padding(.leading)
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: max(min(((inWidth - 414) + 100), 150), 100), maximum: .infinity), spacing: 0)], spacing: CosmeticsSheet.constants.verticalCardSpacing ) {
                ForEach(objectList) { object in
                    Button(action: {
                        withAnimation {
                            if game.canPruchase(cost: object.cost, for: object.isUnlocked) || object.isUnlocked {
                                game.chooseObject(object: object)
                            }
                            else { showingAlert = true; costAccessorObject = object }
                        }
                    }) {
                        createSelectorContent(object: object)
                            .aspectRatio(contentMode: .fill)
                            .padding(CosmeticsSheet.constants.tilePadding * inWidth)
                            .alert(isPresented: $showingAlert) {
                                Alert(title: Text("Not Enough Gold"), message: Text("\nTry playing with your dog to collect some more :)\n\nYou only need \(costAccessorObject.cost - game.gold) more!"), dismissButton: .default(Text("back to throwing!")))
                            }
                        
                    }
                }
            }
        }
        .modifier(framify(Colors.cosmeticsShadow))
        .padding(5)
    }
    struct createSelectorContent<objectType: gameObject>: View {
    
        @EnvironmentObject var game: FetchClassicInterpreter
        @State var animatingLock: Bool = false
        
        let object: objectType
        let tileBack = animatedImage(fps: 0.05, in: "CosmeticTileBack", repeatCount: 1) {  }
        
        var body: some View {
            GeometryReader { geo in
                ZStack {
                    if object.isCurrent {
                        tileBack
                            .scaledToFill()
                            .zIndex(5)
                    }
                    PixelImage(appearanced("CosmeticTileBack"))
                        .scaledToFill()
                        .zIndex(0)
                    PixelImage(object.skin)
                        .padding()
                        .zIndex(1)
                    VStack {
                        CosmeticsSheet.createCosmeticsText("\(object.skin)", with: lowerFont, in: geo.size.width * CosmeticsSheet.constants.cardText)
                            .padding(.top, -geo.size.height * 0.066)
                            .zIndex(4)
                        Spacer()
                    }
                    if !object.isUnlocked {
                        CosmeticsSheet.createGlow()
                            .zIndex(2)
                        PixelImage( "lock")
                            .frame(maxHeight: geo.size.height / 3)
                            .transition(.identity)
                            .zIndex(3)
                        VStack {
                            Spacer()
                            CosmeticsSheet.createCosmeticsText("\(object.cost)", with: defaultFont, in: geo.size.width * CosmeticsSheet.constants.cardText)
                                .transition(.scale)
                        }
                            .zIndex(4)
                    }else {
                        if animatingLock {
                            animatedImage(fps: 0.1, in: "lock", repeatCount: 1) { animatingLock = false }
                                .transition(AnyTransition.asymmetric(insertion: .identity, removal: .opacity))
                                .zIndex(3)
                        }
                    }
                }.onChange(of: object.isUnlocked, perform: { _ in animatingLock = true} )
            }
        }
    }
            
}

struct CosmeticsDisplayer: View {
    
    @EnvironmentObject var game: FetchClassicInterpreter
    
    let dog: Dog
    let ball: Ball
    let width: CGFloat
    
    var body: some View {
        VStack(alignment: .leading) {
            CosmeticsSheet.createCosmeticsText("Current Look:", with: titleFont, in: 30)
            HStack {
                Spacer()
                ObjectPreview(object: dog, width: width)
                Spacer()
                ObjectPreview(object: ball, width: width)
                Spacer()
            }
        }.modifier(framify(Colors.cosmeticsShadow))
        .padding(5)
    }
}

struct ObjectPreview<objectType: gameObject>: View {
    
    @EnvironmentObject var game: FetchClassicInterpreter
    
    let object: objectType
    let width: CGFloat
    @State var animatingPoof: Bool = false

    var body: some View {
        PixelImage(object.skin)
            .frame(width: width / 3)
            .background( CosmeticsSheet.createGlow() )
            .animation(nil)
            .onChange(of: object) { value in animatingPoof = true }
            .overlay(
                GeometryReader { _ in
                    if animatingPoof {
                        animatedImage(fps: 0.1, in: "Poof", repeatCount: 1, completion: { animatingPoof = false })
                    }
                }
            )
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        CosmeticsSheet()
//    }
//}
//
