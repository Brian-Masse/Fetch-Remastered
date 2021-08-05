//
//  Sheets.swift
//  Fetch - Remastered
//
//  Created by Brian Masse on 6/25/21.
//  Copyright © 2021 Brian Masse. All rights reserved.
//

import SwiftUI

struct CosmeticsSheet: View {
    @ObservedObject var viewModel: FetchClassicInterpreter = GameView.game
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading) {
                
                ShadowFont("Cosmetics:", with: titleFont, in: geo.size.width * UIConstants.majorTitleSize, lightShadowColor: constants.shadowColor, darkShadowColor: UIConstants.darkShadow)
                    .padding([.top, .leading])
                            
                GeometryReader() { geometry in
                    ScrollView(.vertical) {
                        VStack {
                            CosmeticsDisplayer(dog: viewModel.model.currentDog.type, ball: viewModel.model.currentBall.type, width: geometry.size.width)
                            SkinSelector(title: "Dog Skins:", objectList: viewModel.model.dogs, inWidth: geo.size.width)
                            Spacer(minLength: 30)
                            SkinSelector(title: "Ball Skins:", objectList: viewModel.model.balls, inWidth: geo.size.width)
                            
                        }
                        .frame(width: geometry.size.width)
                    }
                }
            }
            .modifier(appearancedMod( lightColor: constants.fontColor ))
            .background(Image(appearanced("CosmeticBack")).resizable().ignoresSafeArea())
        }
        
        
    }
    struct constants {
        static let iconsPerRow: CGFloat = 3
        static let verticalCardSpacing: CGFloat = 5
        
        static let cardText: CGFloat = 0.14
        static let tilePadding: CGFloat = 0.008
        
        static let fontColor: Color = Color(UIColor(red: 255 / 255, green: 190 / 255, blue: 189 / 255, alpha: 1))
        static let shadowColor: Color = Color(UIColor(red: 255 / 255, green: 137 / 255, blue: 139 / 255, alpha: 1))
        
        static let topPadding: CGFloat = 100
    }
}

struct SkinSelector<objectType: gameObject>: View{
    let title: String
    let objectList: [objectType]
    let inWidth: CGFloat

    var body: some View {
        VStack(alignment: .leading) {
            ShadowFont(title, with: titleFont, in: inWidth * UIConstants.minorTitleSize, lightShadowColor: CosmeticsSheet.constants.shadowColor, darkShadowColor: UIConstants.darkShadow)
                .padding(.leading)
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: inWidth / CosmeticsSheet.constants.iconsPerRow , maximum: .infinity), spacing: 0)], spacing: CosmeticsSheet.constants.verticalCardSpacing ) {
                ForEach(objectList) { object in
                    Button(action: {
                        
                    }) {
                        createSelectorContent(object: object)
                            .aspectRatio(contentMode: .fill)
                            .padding(CosmeticsSheet.constants.tilePadding * inWidth)
                    }
                }
            }
        }
    }
    struct createSelectorContent<objectType: gameObject>: View {
        
        let object: objectType
        let tileBack = animatedImage(fps: 0.05, in: "CosmeticTileBack", repeatCount: 1) {  }
        
        @State var animatingLock: Bool = false
        @State var showingAlert = false
        
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
                        ShadowFont("\(object.skin)", with: lowerFont, in: geo.size.width * CosmeticsSheet.constants.cardText, lightShadowColor: CosmeticsSheet.constants.shadowColor, darkShadowColor: UIConstants.darkShadow)
                            .padding(.top, -geo.size.height * 0.066)
                            .zIndex(4)
                        Spacer()
                    }
                    if !object.isUnlocked {
                            PixelImage( "lock")
                                .transition(.identity)
                                .zIndex(3)
                        VStack {
                            Spacer()
                            ShadowFont("\(object.cost)", with: defaultFont, in: geo.size.width * CosmeticsSheet.constants.cardText, lightShadowColor: CosmeticsSheet.constants.shadowColor, darkShadowColor: UIConstants.darkShadow)
                                .transition(.scale)
                        }
                            .zIndex(4)
                    }else {
                        if animatingLock {
                            animatedImage(fps: 0.1, in: "Lock", repeatCount: 1) { animatingLock = false }
                                .transition(AnyTransition.asymmetric(insertion: .identity, removal: .opacity))
                                .zIndex(3)
                        }
                    }
                }
            }
            .onTapGesture {
                withAnimation {
                    if GameView.game.canPruchase(cost: object.cost) || object.isUnlocked {
                        GameView.game.chooseObject(object: object)
                        if !object.isUnlocked { animatingLock = true }
                    }
                    else { showingAlert = true }
                }
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Not Enough Gold"), message: Text("\nTry playing with your dog to collect some more :)\n\nYou only need \(object.cost - GameView.game.gold) more!"), dismissButton: .default(Text("back to throwing!")))
            }
        }
    }
            
}

struct CosmeticsDisplayer: View {
    let dog: Dog
    let ball: Ball
    let width: CGFloat
    static let uiImage = UIImage(named: "frame")!
    let aspectRatio = uiImage.size.height / uiImage.size.width
    
    var frameImage: some View {
        PixelImage( GameView.game.preferenceModel.appearance == .light ? "pinkFrame": "frame")
            .padding(.horizontal)
            .frame(minWidth: width,  minHeight: width * aspectRatio)
        
    }
    
    var body: some View {
        
        ZStack {
            frameImage
                
            GeometryReader { geo in
                VStack(alignment: .leading) {
                    ShadowFont("Current Look:", with: titleFont, in: geo.size.width * UIConstants.minorTitleSize, lightShadowColor: CosmeticsSheet.constants.shadowColor, darkShadowColor: UIConstants.darkShadow)
                        .padding(.leading)
                        .zIndex(100)
                    GeometryReader { reducedGeo in
                        withAnimation {
                            HStack {
                                Spacer()
                                createObjectPreviews(object: dog, geo: reducedGeo)
                                Spacer()
                                createObjectPreviews(object: ball, geo: reducedGeo)
                                Spacer()
                            }
                        }
                    }
                }
            }
            .padding()
        }
    }
}

struct createObjectPreviews<objectType: gameObject>: View {
    let object: objectType
    let geo: GeometryProxy
    @State var animatingPoof: Bool = false

    var body: some View {
            ZStack {
                PixelImage(object.skin)
                    .frame(maxHeight: geo.size.height)
                    .background( PixelImage(GameView.game.preferenceModel.appearance == .light ? "pinkGlow": "glow"))
                    .animation(.linear(duration: 0.001))
                    .overlay(
                        GeometryReader { testGeo in
                            if animatingPoof {
                                animatedImage(fps: 0.1, in: "Poof", repeatCount: 1, completion: { animatingPoof = false })
                            }
                        }
                    )

                
            }.onChange(of: object) { value in
                animatingPoof = true
            }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        CosmeticsSheet()
//    }
//}
//
