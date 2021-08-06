//
//  UIUniversals.swift
//  Fetch - Remastered
//
//  Created by Brian Masse on 6/30/21.
//  Copyright © 2021 Brian Masse. All rights reserved.
//

import SwiftUI
import Combine
import SpriteKit


let defaultFont = ShadowedFont(font:   "FetchDefaultText", shadowPadding: 20)
let lowerFont = ShadowedFont(font:   "FetchLowerFont", shadowPadding: 25)
let titleFont = ShadowedFont(font: "fetchTitleFont", shadowPadding: 19)
let boldDefaultFont = ShadowedFont(font: "FetchBoldDefault", shadowPadding: 19)

struct ShadowedFont {
    let font: String
    let shadowPadding: CGFloat
}

struct PixelImage: View {
    let image: Image
    
    init(_ name: String) {
        image = Image(name)
    }
    
    init(_ uiImage: UIImage) {
        image = Image(uiImage: uiImage)
    }
    
    var body: some View {
        image
            .resizable()
            .interpolation(.none)
            .aspectRatio(contentMode: .fit)
    }
}

struct UIConstants {
    static let majorTitleSize: CGFloat = 0.10
    static let minorTitleSize: CGFloat = 0.066

    static let darkGrey = Color(UIColor(red: 69 / 255, green: 69 / 255, blue: 69 / 255, alpha: 1))
    static let darkTextGrey = Color(UIColor(red: 31 / 255, green: 31 / 255, blue: 31 / 255, alpha: 1))
    
    static let goldShadow = Color(UIColor(red: 256 / 255, green: 100 / 255, blue: 92 / 255, alpha: 1))
    
    static let darkShadow = Color(UIColor(red: 0 , green: 0, blue: 0, alpha: 0.22))
    static let lightShadow = Color(UIColor(red: 1 , green: 1, blue: 1, alpha: 0.22))


}


struct ShadowFont: View {
    static let nullColor = Color(UIColor(red: 111.1 / 255, green: 111.1 / 255, blue: 111.1 / 255, alpha: 1))
    
    let text: String
    let fontStruct: ShadowedFont
    let fontSize: CGFloat

    let shadowColor: Color
    let lightShadow: Color
    let darkShadow: Color
    
    let lineLimit: Int
    
    init(_ text: String, with fontStruct: ShadowedFont, in size: CGFloat = 2000, shadowColor: Color = Color(UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)), lineLimit: Int = 1, lightShadowColor: Color = nullColor, darkShadowColor: Color = nullColor ) {
        self.text = text
        self.fontStruct = fontStruct
        self.fontSize = size
        
        self.shadowColor = shadowColor
        
        self.lineLimit = lineLimit
        
        if lightShadowColor == ShadowFont.nullColor { lightShadow = shadowColor } else { lightShadow = lightShadowColor }
        if darkShadowColor == ShadowFont.nullColor { darkShadow = shadowColor } else { darkShadow = darkShadowColor }
    }
    
    var textStruct: some View {
        Text(text)
            .lineLimit(lineLimit)
            .minimumScaleFactor(1)
            .font(Font.custom(fontStruct.font, size: fontSize))
    }
    var body: some View {
        textStruct
            .background(
                GeometryReader { reducedGeo in
                    textStruct
                        .offset(x:0, y: reducedGeo.size.height * (0.1431 / CGFloat(lineLimit)))
                        .modifier(appearancedMod(lightColor: lightShadow, darkColor: darkShadow, colorColor: shadowColor))
                        
                }
            )
    }
}

struct animatedImage: View {
    
    let completion: () -> Void
    let size: CGSize
    
    let repeatCount: Int
    @State var iteration: Int = 0
    
    let frames: [PixelImage]
    @State var index = 0
    
    var timer = Timer.publish(every: 0.2, on: .main, in: .common)
    var cancellableObject: Cancellable
    
    static func createImages(_ rootName: String) -> [PixelImage] {
        var returningList: [PixelImage] = []
        let atlas = SKTextureAtlas(named: rootName)
        for index in 0..<atlas.textureNames.count {
            let name = rootName + "\(index + 1)"
            returningList.append(PixelImage(name))
        }
        return returningList
    }
    
    init(fps: Double, in name: String, repeatCount: Int = -1, boundTo size: CGSize = CGSize(width: 1000000, height: 1000000), completion: @escaping () -> Void ) {
        self.size = size
        
        
        self.frames = animatedImage.createImages(name)
        self.completion = completion
        self.repeatCount = repeatCount
        timer = Timer.publish(every: fps, on: .main, in: .common)
        cancellableObject = timer.connect()
    }
    
    var body: some View {
        frames[index]
            .frame(maxWidth: size.width, maxHeight: size.height)
            .onReceive(timer) { _ in
                withAnimation {
                    index = index < (frames.count - 1) ? index + 1: 0
                    if index == 0 {
                        iteration += 1
                        if iteration >= repeatCount && repeatCount > 0 {
                            index = frames.count - 1
                            cancellableObject.cancel()
                            completion()
                        }
                    }
                }
            }
    }
}

struct RollingNumber: View {
    @State var number: Int
    let newNumber: Int
    let incriment: Int
    
    let font: ShadowedFont
    let size: CGFloat
    let shadowColor: Color
    let shadowed: Bool
    
    let completion: () -> Void //used for turning off an animating property in a parent class
    
    @ViewBuilder func decideTheFontStyle() -> some View {
        if shadowed { ShadowFont("\(number)", with: font, in: size, shadowColor: shadowColor ) }
        else { Text("\(number)").font(Font.custom(font.font, size: size)).foregroundColor(.white) }
    }
    
    var body: some View {
        decideTheFontStyle()
            .onAppear { addToTheRollingNumber() }
    }
    
    func recursiveAddition() {
        number = number + incriment
        if number < newNumber { DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) { recursiveAddition() } }
        else { completion() }
    }
    
    func addToTheRollingNumber() {
        let steps = newNumber / incriment
        let remainder = newNumber - ( steps * incriment )
        
        number += remainder
        recursiveAddition()
    }
}

func correctDigitCount(for text: String, with count: Int) -> String {
    guard let decmilIndex = text.firstIndex(of: ".") else { return "Decmil not Found"}
    let intDecmilIndex = text.distance(from: text.startIndex, to: decmilIndex)
    let remainder = text.indices.count - intDecmilIndex - 1
    if remainder < count {
        var newText = text
        for _ in (0..<count - remainder) {
            newText += "0"
        }
        return newText
    }else { return text }
}

//MARK: Appearance Functions

func appearanced(_ name: String) -> String {
    switch GameView.game.preferenceModel.appearance {
        case .color: return name
        case .dark: return name + "Dark"
        case .light: return name + "Light"
    }
}

struct appearancedMod: ViewModifier {
    let lightColor: Color
    let darkColor: Color
    let colorColor: Color
    
    init(lightColor: Color = .white, darkColor: Color = UIConstants.darkTextGrey, colorColor: Color = .white) {
        self.lightColor = lightColor
        self.darkColor = darkColor
        self.colorColor = colorColor
    }
    
    func body(content: Content) -> some View {
        switch GameView.game.preferenceModel.appearance {
        case .light: content.foregroundColor(lightColor)
        case .dark: content.foregroundColor(darkColor)
        case .color: content.foregroundColor(colorColor)
        }
    }
}

struct Alternatives<someView: View>: View {
    
    @ViewBuilder let color: () -> someView
    @ViewBuilder let dark: () -> someView
    @ViewBuilder let light: () -> someView
    
    init( @ViewBuilder color: @escaping () -> someView, @ViewBuilder dark: @escaping () -> someView, @ViewBuilder light: @escaping () -> someView ) {
        self.color = color
        self.light = light
        self.dark = dark
        
    }
    
    init( @ViewBuilder dark: @escaping () -> someView, @ViewBuilder light: @escaping () -> someView ) {
        self.color = dark
        self.dark = dark
        self.light = light
    }
    
    var body: some View {
        switch GameView.game.preferenceModel.appearance {
        case .color: color()
        case .dark: dark()
        case .light: light()
        }
    }
}


//MARK: Notifications

struct notification<someView: View>: View {
    
    let duration: Double
    let placementIndex: CGFloat
    
    @Binding var binding: Bool
    @State var showing = false
    
    @ViewBuilder let content: () -> someView
    
    var body: some View {
        VStack {
            if showing {
                content()
                    .modifier(Bounce(currentOffSet: 25))
                    .transition(.asymmetric(insertion: .FallAwayTransition(offSet: 70), removal: .FallAwayTransition(offSet: -70)))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { withAnimation { showing = false } }
                    }
            }
        }
        .onChange(of: binding) { _ in withAnimation { showing = binding } }
        .padding(.bottom, placementIndex * 100)
    }
}

//MARK: Transitions

extension AnyTransition {
    static func FallAwayTransition(offSet: CGFloat) -> AnyTransition {
        return AnyTransition.modifier(active: FallAway(offSet: offSet), identity:  FallAway(offSet: 0)).combined(with: .opacity)
    }
}

//MARK: animations

struct Bounce: AnimatableModifier {
    @State var currentOffSet: CGFloat = 0
    let offSet: CGFloat = 0
    
    var animatableData: CGFloat {
        get { currentOffSet }
        set { currentOffSet = newValue }
    }
    
    func body(content: Content) -> some View {
        content
            .offset(x: 0, y: currentOffSet)
            .onAppear {
                withAnimation(.easeInOut(duration: 1).repeatForever()) {
                    currentOffSet = offSet
                }
            }
    }
    
}

struct FallAway: AnimatableModifier {
    var offSet: CGFloat
    
    var animatableData: CGFloat {
        get { offSet }
        set { offSet = newValue }
    }
    
    func body(content: Content) -> some View {
        content
            .offset(x: 0, y: offSet)
    }
}

struct RotBounceAnimation: AnimatableModifier {
    
    var shouldAnimate: Binding<Bool>
    var rotationAmount: Double
    
    @State var rotation: Angle
    
    var animatableData: Angle {
        get { rotation }
        set { rotation = newValue }
    }
    
    init(_ rotationAmount : Double, shouldAnimate: Binding<Bool> ) {
        self.rotationAmount = rotationAmount
        self.shouldAnimate = shouldAnimate
        self.rotation = Angle(degrees: (rotationAmount / 2))
    }
    
    func body(content: Content) -> some View {
        if shouldAnimate.wrappedValue {
            content
                .padding(.bottom, 100)
                .rotationEffect(rotation, anchor: UnitPoint(x: 0.5, y: 1))
                .onAppear {
                    withAnimation(.easeInOut(duration: 1).repeatForever()) {
                        rotation -= Angle(degrees: rotationAmount)
                    }
                }
        }else { content }
    }
    
}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ShadowFont("Farthest Throw", with: titleFont, in: 80, lineLimit: 2)
//    }
//}

