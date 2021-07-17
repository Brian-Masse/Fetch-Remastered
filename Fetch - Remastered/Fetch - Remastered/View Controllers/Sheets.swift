//
//  Sheets.swift
//  Fetch - Remastered
//
//  Created by Brian Masse on 6/25/21.
//  Copyright © 2021 Brian Masse. All rights reserved.
//

import SwiftUI

struct CosmeticsSheet: View {
    @ObservedObject var viewModel: FetchClassicInterpreter
    
    var body: some View {
        VStack() {
            ShadowFont(text: "Cosmetics:", fontStruct: titleFont, fontSize: globalFrame.size.width * constants.majorTitleSize)
                .frame(width: globalFrame.width, alignment: .leading)
                .padding([.top, .leading])
                            
            GeometryReader() { geometry in
                ScrollView(.vertical) {
                    VStack {
                        CosmeticsDisplayer(dog: viewModel.model.currentDog.type, ball: viewModel.model.currentBall.type)
                        SkinSelector(title: "Dog Skins:", objectList: viewModel.model.dogs)
                        Spacer(minLength: 30)
                        SkinSelector(title: "Ball Skins:", objectList: viewModel.model.balls)
                        
                    }
                    .frame(width: geometry.size.width)
                }
            }
        }
        .foregroundColor(constants.fontColor)
        .background(Image("CosmeticBack").resizable().ignoresSafeArea())
        
    }
    struct constants {
        static let iconsPerRow: CGFloat = 3
        static let majorTitleSize: CGFloat = 0.15
        static let minorTitleSize: CGFloat = 40
        static let cardTitleScale: CGFloat = 0.5
        static let cardMinorTitleScale: CGFloat = 0.48
        static let cardMinorTitlePadding: CGFloat = 0.1
        static let minorTitlePadding: CGFloat = 3
        static let glowSize: CGFloat = 150
        static let poofSize: CGFloat = 80
        static let fontColor: Color = .white
        static let topPadding: CGFloat = 100
        static let skinPreview: CGFloat = 90
    }
}

struct SkinSelector<objectType: gameObject>: View{
    let title: String
    let objectList: [objectType]

    var body: some View {
        VStack {
            ShadowFont(text: title, fontStruct: titleFont, fontSize: CosmeticsSheet.constants.minorTitleSize)
                .frame(width: globalFrame.width, alignment: .leading)
                .padding(.leading)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: globalFrame.size.width / CosmeticsSheet.constants.iconsPerRow , maximum: .infinity), spacing: 0)], spacing: 0) {
                ForEach(objectList) { object in
                    Button(action: {
                        
                    }) {
                        createSelectorContent(object: object)
                            .aspectRatio(contentMode: .fill)
                            .padding(2)
                    }
                }
            }
        }
    }
    struct createSelectorContent<objectType: gameObject>: View {
        
        let object: objectType
        let tileBack = animatedImage(fps: 0.05, in: "UIBack", repeatCount: 1) {  }
        
        @State var animatingLock: Bool = false
        
        var body: some View {
            GeometryReader { geo in
                ZStack {
                    if object.isCurrent {
                        tileBack
                            .scaledToFill()
                            .zIndex(0)
                    } else {
                        PixelImage("UIBack")
                            .scaledToFill()
                            .zIndex(0)
                    }
                    PixelImage(object.skin)
                        .padding()
                        .zIndex(1)
                    VStack {
                        ShadowFont(text: "\(object.skin)", fontStruct: defaultFont, fontSize: geo.size.width * CosmeticsSheet.constants.cardTitleScale)
                            .padding(.top, -geo.size.height * 0.2)
                            .zIndex(2)
                        Spacer()
                    }
                    if !object.isUnlocked {
                            PixelImage( "lock")
                                .transition(.identity)
                                .zIndex(3)
                        VStack {
                            Spacer()
                            ShadowFont(text: "\(object.cost)", fontStruct: defaultFont, fontSize: geo.size.width * CosmeticsSheet.constants.cardMinorTitleScale)
                                .padding(.bottom, geo.size.height *  CosmeticsSheet.constants.cardMinorTitlePadding)
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
                        GameView.game.chooseObject(object: object)
                        if !object.isUnlocked {
                            animatingLock = true
                        }
                    }
                }
        }
    }
            
}

struct CosmeticsDisplayer: View {
    let dog: Dog
    let ball: Ball
    
    var body: some View {
        VStack(alignment: .leading) {
            ShadowFont(text: "Current Look:", fontStruct: titleFont, fontSize: CosmeticsSheet.constants.minorTitleSize)
                .padding([.top, .leading], CosmeticsSheet.constants.minorTitlePadding)
                .zIndex(100)
            withAnimation {
                HStack {
                    Spacer()
                    createObjectPreviews(object: dog)
                    Spacer()
                    createObjectPreviews(object: ball)
                    Spacer()
                }
            }
        }
        .modifier(framify())
    }
}

struct createObjectPreviews<objectType: gameObject>: View {
    let object: objectType
    @State var animatingPoof: Bool = false

    var body: some View {
        ZStack {
            PixelImage(object.skin)
                .frame(minWidth: CosmeticsSheet.constants.skinPreview)
                .aspectRatio(contentMode: .fill)
                .background(PixelImage("glow").frame(minWidth: CosmeticsSheet.constants.glowSize , minHeight: CosmeticsSheet.constants.glowSize))
                .padding(.bottom, CosmeticsSheet.constants.minorTitlePadding)
                .animation(.linear(duration: 0.001))

            if animatingPoof {
                let size = CGSize(width: CosmeticsSheet.constants.poofSize, height: CosmeticsSheet.constants.poofSize)
                animatedImage(fps: 0.1, in: "Poof", repeatCount: 1, boundTo: size, completion: { animatingPoof = false })
            }
        }.onChange(of: object) { value in
            animatingPoof = true
        }
    }
}

struct framify: ViewModifier {
    static let uiImage: UIImage = UIImage(named: "frame")!
    let aspectRatio = uiImage.size.height / uiImage.size.width
    
    var frameImage: some View {
        PixelImage("frame")
            .padding(.horizontal)
            .frame(minWidth: globalFrame.width)
    }
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(maxWidth: globalFrame.width, maxHeight: globalFrame.width * aspectRatio)
            .overlay(frameImage)
    }
    struct constants {
        static let verticalSafeArea: CGFloat = 10
        static let horizontalSafeArea: CGFloat = 25
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CosmeticsSheet(viewModel: GameView.game)

    }
}
