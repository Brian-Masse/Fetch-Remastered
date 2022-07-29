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
import WidgetKit


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
    let renderingMode: Image.TemplateRenderingMode
    
    init(_ name: String, renderingMode: Image.TemplateRenderingMode = .original) {
        image = Image(name)
        self.renderingMode = renderingMode
    }
    
    init(_ uiImage: UIImage) {
        image = Image(uiImage: uiImage)
        renderingMode = .original
    }
    
    var body: some View {
        image
            .renderingMode(renderingMode)
            .resizable()
            .interpolation(.none)
            .aspectRatio(contentMode: .fit)
    }
}

struct UIConstants {
    static let majorTitleSize: CGFloat = 0.10
    static let minorTitleSize: CGFloat = 0.066
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
            .font(Font.custom(fontStruct.font, size: fontSize))
    }
    var body: some View {
        VStack {
            textStruct
                .background(
                    GeometryReader { reducedGeo in
                        textStruct
                            .offset(x:0, y: reducedGeo.size.height * (0.1431 / CGFloat(lineLimit)))
                            .modifier(appearancedMod(lightColor: lightShadow, darkColor: darkShadow, colorColor: shadowColor))
                            
                    }
                )
        }.minimumScaleFactor(0.01)
    }
}

struct IconEnumSelector< EnumType: CaseIterable, someView: View >: View where EnumType: Equatable {
    @Binding var currentEnumValue: EnumType
    let title: String
    let names: [String]
    let icons: [String]
    let accent: Color
    let design: (String, CGFloat, Int) ->  someView
    
    var body: some View {
        VStack(spacing: 0) {
            design(title, 20, 1)
                
                .padding(.bottom)
            ForEach( EnumType.allCases.indices as! Range<Int>, id: \.self) { index in
            
                HStack {
                    PixelImage(icons[index])
                        .frame(maxHeight: 55)
                        .padding()
                    design( names[index], 15, 1 )
                    Spacer()
                    Rectangle()        
                        .aspectRatio(1, contentMode: .fit)
                        .foregroundColor(EnumType.allCases[index as! EnumType.AllCases.Index] == currentEnumValue ? accent : Colors.darkGrey)
                        .modifier(framify(.white, in: 310.5, padded: false))
                        .frame(maxWidth: 20)
                        .background(Rectangle().offset(x: 0, y: 5).foregroundColor(Colors.darkGrey).opacity(0.5))
                        .padding(.trailing)
                        
                }
//                .modifier(framify(accent, in: 310.5, padded: false))
                .background(Rectangle().foregroundColor( index.isMultiple(of: 2) ? Color(UIColor(red: 1, green: 1, blue: 1, alpha: 0.4)): Color(UIColor(red: 1, green: 1, blue: 1, alpha: 0.001)) ))
                .onTapGesture { currentEnumValue = EnumType.allCases[index as! EnumType.AllCases.Index] }
            }
        }
    }
}

struct DesignedButton<someView: View>: View {
    let accent: Color
    let design: () ->  someView
    let action: () -> Void
    var body: some View {
        
        Button(action: action ) {
            HStack {
                Spacer()
                design()
                Spacer()
            }
                .modifier(framify(.white, in: 414, padded: true) {
                    Rectangle().foregroundColor(accent).opacity(0.3)
                })
        }
    }
}

struct EnumSelector< EnumType: CaseIterable, someView: View >: View where EnumType: Equatable{
    @Binding var currentEnumValue: EnumType
    let title: String
    let names: [String]
    let accent: Color
    let design: (String, CGFloat, Int) ->  someView
    
    var body: some View {
        VStack {
            design(title, 20, 1)
                .padding(.bottom, 3)
            HStack(spacing: 10) {
                Spacer()
            
                ForEach( EnumType.allCases.indices as! Range<Int>, id: \.self ) { index in
                
                    IndividualEnumSelector(displayName: names[index], enumValue: EnumType.allCases[index as! EnumType.AllCases.Index], currentvalue: $currentEnumValue, design: design, accent: accent)
                }
                Spacer()
            }
        }.padding(.vertical, 3).background( Rectangle().foregroundColor(Color(UIColor(red: 1, green: 1, blue: 1, alpha: 0.3))))
    }
}

struct IndividualEnumSelector< EnumType: Equatable, someView: View >: View {
    let displayName: String
    let enumValue: EnumType
    @Binding var currentvalue: EnumType
    let design: (String, CGFloat, Int) ->  someView
    let accent: Color
    
    var body: some View {
        design(displayName, 15, returnNumberOfNeededLines(in: displayName))
            .minimumScaleFactor(0.5)
            .padding(.horizontal)
            .background(
                Rectangle()
                    .cornerRadius(3)
                    .foregroundColor( currentvalue == enumValue ? accent: .clear))

            .onTapGesture {
                withAnimation { currentvalue = enumValue }
            }
    }
}

struct PixelButton: ButtonStyle {
    let root: String
    let appearance: String
    
    func makeBody(configuration: Configuration) -> some View {
        PixelImage( configuration.isPressed ? root+"ButtonDown"+appearance: root+"ButtonUp"+appearance )
    }
    
}

struct Toggle< someView : View >: View {
    let displayName: String
    @Binding var currentValue: Bool
    let design: (String, CGFloat, Int) ->  someView
    let accent: Color
    let hasImage: Bool
    
    var body: some View {
        HStack {
            if hasImage {
                PixelImage( appearanced( displayName+"Icon" ))
                    .frame(maxHeight: 55)
                    .padding()
            }
            design( displayName, 15, 1 )
            Spacer()
            Rectangle()
                .aspectRatio(1, contentMode: .fit)
                .foregroundColor(currentValue ? accent : Colors.darkGrey)
                .modifier(framify(.white, in: 310.5, padded: false))
                .frame(maxWidth: 20)
                .background(Rectangle().offset(x: 0, y: 5).foregroundColor(Colors.darkGrey).opacity(0.5))
                .padding(.trailing)
                
        }
        .background(Rectangle().foregroundColor(Color(UIColor(red: 1, green: 1, blue: 1, alpha: 0.001)) ))
        .onTapGesture { currentValue.toggle() }
    }
}

//MARK: appearanceModifiers

enum Appearance: Int, Codable, CaseIterable {
    case color
    case light
    case dark
}

struct appearancedMod: ViewModifier {
    let lightColor: Color
    let darkColor: Color
    let colorColor: Color
    
    @ObservedObject var accessor = widgetAcessor
    
    init(lightColor: Color = .white, darkColor: Color = Colors.darkTextGrey, colorColor: Color = .white) {
        self.lightColor = lightColor
        self.darkColor = darkColor
        self.colorColor = colorColor
    }
    
    func body(content: Content) -> some View {
        switch accessor.appearance {
        case .light: content.foregroundColor(lightColor)
        case .dark: content.foregroundColor(darkColor)
        case .color: content.foregroundColor(colorColor)
        }
    }
}

func appearanced(_ name: String) -> String {
    switch retrieveApperance() {
        case .color: return name
        case .dark: return name + "Dark"
        case .light: return name + "Light"
    }
}

func retrieveApperance() -> Appearance {
    WidgetAcessor.retrieveComplexData(defaultValue: .color, for: "AppearanceKey")
}

struct ConfettiBurstModifier: ViewModifier {
    let showing: Bool
    let delay: Double
    let repeatCount: Int
    
    func body(content: Content) -> some View {
        if showing {
            content
                .overlay( GeometryReader { geo in
                    HStack {
                        Spacer()
                        ZStack {
                            animatedImage(fps: 0.1, in: "confetti", repeatCount: repeatCount, renderingMode: .template, delay: delay, completion: {})
                                .frame(maxWidth: 75)
                                .offset(x: (-geo.size.width / 2) - 37.5, y: 0)
                            animatedImage(fps: 0.1, in: "confetti", repeatCount: repeatCount, renderingMode: .template, delay: delay, completion: {})
                                .frame(maxWidth: 75)
                                .rotation3DEffect( Angle(degrees: 180), axis: (x: 0.0, y: 1.0, z: 0.0) )
                                .offset(x: (geo.size.width / 2) + 37.5, y: 0)
                        }
                        Spacer()
                    }
                })
        } else { content }
    }
}


struct animatedImage: View {
    
    let delay: Double
    let completion: () -> Void
    
    let repeatCount: Int
    @State var iteration: Int = 0
    
    let frames: [PixelImage]
    @State var index = 0
    @State var requestSent = false
    
    var timer = Timer.publish(every: 0.2, on: .main, in: .common)
    var cancellableObject: Cancellable
    
    static func createImages(_ rootName: String, renderingMode: Image.TemplateRenderingMode) -> [PixelImage] {
        var returningList: [PixelImage] = []
        let atlas = SKTextureAtlas(named: rootName)
        for index in 0..<atlas.textureNames.count {
            let name = rootName + "\(index + 1)"
            returningList.append(PixelImage(name, renderingMode: renderingMode))
        }
        return returningList
    }
    
    init(fps: Double, in name: String, repeatCount: Int = -1, renderingMode: Image.TemplateRenderingMode = .original, delay: Double = 0, completion: @escaping () -> Void ) {
        self.frames = animatedImage.createImages(name, renderingMode: renderingMode)
        self.completion = completion
        self.repeatCount = repeatCount
        self.delay = delay
        timer = Timer.publish(every: fps, on: .main, in: .common)
        cancellableObject = timer.connect()
    }
    
    var body: some View {
        frames[index]
            .onReceive(timer) { _ in
                withAnimation {
//                    index = index < (frames.count - 1) ? index + 1: 0
                    if index >= (frames.count - 1) {
                        if iteration + 1 >= repeatCount && repeatCount > 0 {
                            index = frames.count - 1
                            cancellableObject.cancel()
                            completion()
                        }else {
                            if !requestSent { DispatchQueue.main.asyncAfter(deadline: .now() + delay) { index = 0; iteration += 1; requestSent = false }; requestSent = true }
                        }
                    }else {
                        index += 1
                    }
                }
            }
    }
}

struct RollingNumber<someView: View>: View {
    @State var number: Int
    @State var incriment: Int
    
    @Binding var nextNumber: Int

    let completion: () -> Void //used for turning off an animating property in a parent class
    let text: (String) -> someView
    
    
    func calculateIncriment() -> Int {
        let possiblyZero: CGFloat = (CGFloat(nextNumber) - CGFloat(number)) / 91
        if possiblyZero != 0 {
            let direction = possiblyZero / abs(possiblyZero)
            let notZero = abs(possiblyZero).rounded(.up)
            return Int(notZero * direction)
        }else { return 1 }
    }
//
    init(newNumber: Binding<Int>, completion: @escaping () -> Void = {}, text: @escaping (String) -> someView ) {
        
        self.number = newNumber.wrappedValue
        self._nextNumber = newNumber
        self.incriment = 1
        self.completion = completion
        self.text = text
    }
    
    var body: some View {
        text("\(number)")
            .onChange(of: nextNumber) { [nextNumber] newValue in
                number = nextNumber
                incriment = calculateIncriment()
                addToTheRollingNumber()
                
            }
    }
    
    func recursiveAddition() {
        number = number + incriment
        let direction = incriment / abs(incriment)
        if number * direction < nextNumber * direction { DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) { if (number * direction < nextNumber * direction) { recursiveAddition() } }}
        else { completion() }
    }
    
    func addToTheRollingNumber() {    
        let steps = (nextNumber - number) / incriment
        let remainder = nextNumber - ( steps * incriment ) - number
        
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

struct emptySpace: View {
    var with: CGFloat
    
    var body: some View {
        Rectangle()
            .foregroundColor(.clear)
            .frame(height: with)
    }
}

@ViewBuilder var defaultFill: some View {
    Rectangle().foregroundColor(.clear)
}

func returnNumberOfNeededLines(in text: String) -> Int {
    var numberOfSpaces = 1
    for charachter in text {
        if String(charachter) == " " { numberOfSpaces += 1}
    }
    return numberOfSpaces
}

struct framify<someView: View>: ViewModifier{

    let padded: Bool
    let color: Color
    let width: CGFloat
    let changeForegroundColor: Bool
    let opacity: CGFloat
    
    @ViewBuilder var fill: () -> someView
    @ObservedObject var acessor = widgetAcessor
    
    init(_ color: Color, in width: CGFloat = 414, padded: Bool = true, @ViewBuilder and fill: @escaping () -> someView = { defaultFill as! someView }, changeForegroundColor: Bool = true, opacity: CGFloat = 1 ) {
        self.color = color
        self.fill = fill
        self.padded = padded
        self.width = width
        self.changeForegroundColor = changeForegroundColor
        self.opacity = opacity
    }
    
    func body(content: Content) -> some View {
        
        let lightColor = opacity == 1 ? (changeForegroundColor ? .white: color) : Color(UIColor(red: 0, green: 0, blue: 0, alpha: 0))
        let darkColor = opacity == 1 ? (changeForegroundColor ? Colors.darkTextGrey: color) : Color(UIColor(red: 0, green: 0, blue: 0, alpha: 0))
        let colorColor = opacity == 1 ? color : Color(UIColor(red: 0, green: 0, blue: 0, alpha: 0))
        
        content
            .opacity(1)
            .padding(padded ? width * (10 / 414): 0)
            .background( GeometryReader { geo in
                fill()
            })
            .overlay(Rectangle()
                    .strokeBorder(style: StrokeStyle(lineWidth: min(width * (5 / 414), 10), lineCap: .square, lineJoin: .miter, miterLimit: 5))
                    .modifier(appearancedMod(lightColor: lightColor, darkColor:  darkColor, colorColor: colorColor)))
                    
        
                        
    }
}

extension framify where someView == SwiftUI.ModifiedContent<SwiftUI.Rectangle, SwiftUI._EnvironmentKeyWritingModifier<Swift.Optional<SwiftUI.Color>>> {
    init(_ color: Color, in width: CGFloat = 414, padded: Bool = true, opacity: CGFloat = 1, changeForegroundColor: Bool = true) {
        self.init(color, in: width, padded: padded, and: { Rectangle().foregroundColor(.clear) as! ModifiedContent<Rectangle, _EnvironmentKeyWritingModifier<Optional<Color>>> }, changeForegroundColor: changeForegroundColor, opacity: opacity)
    }
}


//MARK: Notifications

struct notification<someView: View>: View {
    
    let duration: Double
    
    @Binding var binding: Bool
    @State var showing = false
    
    @ViewBuilder let content: () -> someView
    
    var body: some View {
        ZStack {
            if showing {
                content()
                    .modifier(Bounce(currentOffSet: 25))
                    .transition(.asymmetric(insertion: .FallAwayTransition(offSet: 70), removal: .FallAwayTransition(offSet: -70)))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { withAnimation { showing = false } }
                    }
            }
        }
        .onAppear() { if binding { showing = binding }}
        .onChange(of: binding) { _ in withAnimation { if binding { showing = binding } } }
    }
}

//MARK: Transitions

extension AnyTransition {
    static func FallAwayTransition(offSet: CGFloat) -> AnyTransition {
        return AnyTransition.modifier(active: FallAway(offSet: offSet), identity:  FallAway(offSet: 0)).combined(with: .opacity)
    }
}

extension AnyTransition {
    static func xScale(_ anchor: UnitPoint) -> AnyTransition {
        return AnyTransition.modifier(active: xScaleModifier(xScale: 0, anchorPoint: anchor), identity: xScaleModifier(xScale: 1, anchorPoint: anchor))
    }
}

//MARK: shapes

struct WidgetShape: View {
    
    let height: CGFloat
    let size: WidgetFamily
    
    var body: some View {
        VStack {
            switch size {
            case .systemSmall: RoundRectShape(radius: height * 0.15, aspectRatio: 1)
            case .systemMedium: RoundRectShape(radius: height * 0.15, aspectRatio:  360 / 169)
            case .systemLarge: RoundRectShape(radius: height * 0.15, aspectRatio: 360 / 376)
            default: Text("Widget Size Not implimented: Shape not able to generate")
            }
        }.foregroundColor(.white)
    }
}

struct RoundRectShape: Shape {
    let radius: CGFloat
    let aspectRatio: CGFloat // ( width / height )
    
    func path(in rect: CGRect) -> Path {
        var returningPath = Path()
        
        let height = rect.height
        let width = height * aspectRatio
        
        let deadWidth = (rect.width - width) / 2
        
        let tL = CGPoint(x: rect.minX + deadWidth, y: rect.maxY)
        let tR = CGPoint(x: rect.minX + deadWidth + width, y: rect.maxY)
        let bL = CGPoint(x: rect.minX + deadWidth, y: rect.minY)
        let bR = CGPoint(x: rect.minX + deadWidth + width, y: rect.minY)
        
    
        returningPath.move(to: CGPoint(x: bL.x, y: bL.y + radius))
        returningPath.addLine(to: .init(x: tL.x, y: tL.y - radius))
        returningPath.addQuadCurve(to: 
                                    .init(x: tL.x + radius, y: tL.y),
                                    control: tL)
        
        returningPath.addLine(to: .init(x: tR.x - radius, y: tR.y))
        returningPath.addQuadCurve(to:
                                    .init(x: tR.x, y: tR.y - radius),
                                    control: tR)
        
        returningPath.addLine(to: .init(x: bR.x, y: bR.y + radius))
        returningPath.addQuadCurve(to:
                                    .init(x: bR.x - radius, y: bR.y),
                                    control: bR)
        
        returningPath.addLine(to: .init(x: bL.x + radius, y: bL.y))
        returningPath.addQuadCurve(to:
                                    .init(x: bL.x, y: bL.y + radius),
                                    control: bL)
        
        return returningPath
    }
}

//MARK: animations


struct BouncingText<someView: View>: View {
    
    @Binding var shouldAnimate: Bool
    let text: String
    let stallTime: Double
    let width: CGFloat
    let textStyle: (String) -> someView
    

    var body: some View {
//        SubBouncingText(shouldAnimate: $shouldAnimate, text: "a", content: textStyle, offSet: 0, stallTime: 0)
//        GeometryReader { geo in
//            let width = geo.size.width / CGFloat(text.getEnumeration().count)
            HStack(spacing: 0) {
                ForEach(text.getEnumeration(), id: \.0) { enumeration in
                    SubBouncingText(shouldAnimate: $shouldAnimate, text: enumeration.1, content: textStyle, offSet: Double(enumeration.0) / 10, stallTime: stallTime)
                }
            }
            
            .frame(maxWidth: width)
//        }
    }
    
    struct SubBouncingText: View {
        
        @Binding var shouldAnimate: Bool
        @State var shouldBounce: Bool = false
        
        let text: String
        let content: (String) -> someView
        let offSet: Double
        let stallTime: Double
        
        func runSingleBounce() {
            if shouldAnimate {
                shouldBounce = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: { shouldBounce = false })
                DispatchQueue.main.asyncAfter(deadline: .now() + stallTime, execute: { runSingleBounce() })
            }
        }
        
        var body: some View {
            content(text)
                .frame(maxHeight: 40)
                .offset(y: shouldBounce ? -15: 0)
                .animation( shouldAnimate ?  .easeInOut(duration: 0.3 ).delay(offSet): nil  )
                .onAppear() { if shouldAnimate { runSingleBounce() } }
                .onChange(of: shouldAnimate ) { _ in if shouldAnimate { runSingleBounce() } }
        }
    }
}

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

struct xScaleModifier: AnimatableModifier {
    var xScale: CGFloat
    let anchorPoint: UnitPoint
    
    var animatableData: CGFloat {
        get { xScale }
        set { xScale = newValue }
    }
    
    func body(content: Content) -> some View {
        content.scaleEffect(CGSize(width: xScale, height: 1), anchor: anchorPoint)
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
    
    @Binding var shouldAnimate: Bool
    @State var rotation: Angle
    var rotationAmount: Double = 0
    
    var animatableData: Angle {
        get { rotation }
        set { rotation = newValue }
    }
    
    func body(content: Content) -> some View {
        VStack {
            if shouldAnimate {
                content
                    .padding(.bottom, 100)
                    .rotationEffect(rotation, anchor: UnitPoint(x: 0.5, y: 1))
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1).repeatForever()) {
                            rotation -= Angle(degrees: rotationAmount)
                        }
                    }
            }else { content.padding(.bottom, 100) }
        }.onChange(of: shouldAnimate) { _ in if shouldAnimate { rotation = Angle(degrees: (rotationAmount / 2)) } }
    }
    
}

extension String {

    func getEnumeration() -> [(Int, String)] {
        var enumeration: [(Int, String)] = []
        var index = 0
        for character in self {
            enumeration.append(( index, String(character) ))
            index += 1
        }
        return enumeration
    }
}

//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ShadowFont("Farthest Throw", with: titleFont, in: 80, lineLimit: 2)
//    }
//}

