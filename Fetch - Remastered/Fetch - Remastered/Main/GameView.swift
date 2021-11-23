//
//  File.swift
//  Fetch - Remastered
//
//  Created by Brian Masse on 9/2/20.
//  Copyright © 2020 Brian Masse. All rights reserved.
//

import SpriteKit
import SwiftUI


struct GameView: View {
    
    static let game: FetchClassicInterpreter = FetchClassicInterpreter()
    @StateObject var test = GameView.game
    @State var shouldAnimate = false
    
    var hasLegacyDataBinding = Binding { game.stats.legacyFarthestThrow != 0 && !game.model.askedAboutMerging } set: { _ in }
    var notificationManager = NotificationManager()
    
    @ViewBuilder
    static func createText(_ text: String, with font: ShadowedFont = titleFont, in size: CGFloat, lineLimit: Int = 1) -> some View {
        ShadowFont(text, with: font, in: size, shadowColor: Colors.settingsShadow, lineLimit: lineLimit, lightShadowColor: Colors.settingsShadow, darkShadowColor: Colors.darkTextGrey)
            .modifier(appearancedMod(lightColor: .white, darkColor: .white, colorColor: .white))
            .fixedSize()
    }
    
    var trueBinidng = Binding { true } set: { _ in }
    func createGameScene(in size: CGSize) -> GameScene {
        if size != globalFrame.size {
            globalScene.size = size
            globalScene.sizeDidChange(in: size  )
            globalFrame.size = size
        }
        return globalScene
    }
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                SpriteView(scene: createGameScene(in: geo.size))
                    .ignoresSafeArea()
                
                if geo.size.width > 500 {
                    wideDisplay(geo: geo)
                }else {
                    narrowDisplay(geo: geo)
                }
                notificationManager
            }
            .ignoresSafeArea()
        }
        .alert(isPresented: hasLegacyDataBinding){
            Alert(title:
                Text("Legacy data has been found"),
                message: Text("\nIt looks like you've played before, so all your great data will be kept and stored in your profile! \n\nIf you wish to continue from where you left off, you can merge all of this data, however this is not gaurneteed to be seamless; the game progression may be off, and more importantly less fun. The recommendation is just to store this data and start fresh, but the choice is all up to you! \n\n( ps. you can always merge later in settings :) )"),
                primaryButton:
                    .cancel(
                        Text("Just Store")) { test.dismissLegacyDataFoundAlert(with: false) },
                    secondaryButton:
                        .destructive(
                            Text("Merge and Store")) { test.dismissLegacyDataFoundAlert(with: true)  })
        }
        .environmentObject(test)
    }
    
    struct narrowDisplay: View {
        @EnvironmentObject var environmentGame: FetchClassicInterpreter
        let geo: GeometryProxy
        
        var body: some View {
            VStack {
                if environmentGame.currentState == .home {
                    Spacer()
                    fade(direction: 0)
                }
            }

            VStack(alignment: .center) {
                goldDisplayer(geo: geo)
                    .padding(.leading, 20)
                    .padding([.top], 50)

                Spacer(minLength: (400 / 869) * geo.size.height)
                HStack {
                    Spacer()
                    returnButton()
                    Spacer()
                }
                Spacer()

                HStack {
                    Spacer()
                    VStack {
                        VelocityLabel()
                        DistanceLabel()
                    }.padding(.bottom, 20)
                    if environmentGame.currentState == .home {
                        menuButton(imageName: "settings", viewToPresent: Settings().environmentObject(GameView.game))
                        Spacer()
                        menuButton(imageName: "upgrades", viewToPresent: UpgradesSheet().environmentObject(GameView.game))
                        Spacer()
                        menuButton(imageName: "cosmetics", viewToPresent: CosmeticsSheet().environmentObject(GameView.game))
                        Spacer()
                        menuButton(imageName: "profile", viewToPresent: ProfileSheet().environmentObject(GameView.game))
                    }
                    Spacer(minLength: 20)
                }
            }
        }
    }
    
    struct wideDisplay: View {
        @EnvironmentObject var environmentGame: FetchClassicInterpreter
        let geo: GeometryProxy
        
        var body: some View {
            
            VStack(alignment: .leading) {
                goldDisplayer(geo: geo).padding(.vertical, 30)
                
                if environmentGame.currentState != .home { emptySpace(with: 55) }
                
                VelocityLabel()
                emptySpace(with: 1)
                DistanceLabel()
                
                if environmentGame.currentState == .home {
                    menuButton(imageName: "profile", viewToPresent: ProfileSheet().environmentObject(GameView.game))
                    menuButton(imageName: "cosmetics", viewToPresent:
                    CosmeticsSheet().environmentObject(GameView.game))
                    menuButton(imageName: "upgrades", viewToPresent:
                    UpgradesSheet().environmentObject(GameView.game))
                    menuButton(imageName: "settings", viewToPresent: Settings().environmentObject(GameView.game))
                }
                Spacer()
            }
            .padding([.vertical, .leading], 20)
            .overlay( VStack {
                emptySpace(with: 150)
                returnButton()
            } )
        }
    }
    
    struct returnButton: View {
        @State var tappable: Bool = true
        @EnvironmentObject var environmentGame: FetchClassicInterpreter
        
        var body: some View {
            if environmentGame.model.masterState == .throwOver {
                DesignedButton(accent: Colors.settingsShadow, design: { GameView.createText("Return Home", with: titleFont, in: 20) }) {
                    if tappable { environmentGame.changeState(.returning) }; tappable = false
                }
                .frame(maxWidth: 200)
                .onAppear { tappable = true }
            }
        }
    }
    
    struct VelocityLabel: View {
        @ObservedObject var observedBall = game.currentBall
        @EnvironmentObject var environmentGame: FetchClassicInterpreter

        var body: some View {
            VStack() {
                if environmentGame.preferenceModel.velocityLabel && environmentGame.currentState == .throwing {
                    GameView.createText("Velocity", in: 33)
                    GameView.createText(correctDigitCount(for: "\(game.currentBall.physicsBody!.velocity.dy.trimCGFloat(2))", with: 2) + " ft / s", in: 33)
                }
            }
        }
    }
    
    struct DistanceLabel: View {
        @ObservedObject var observedBall = game.currentBall
        @EnvironmentObject var environmentGame: FetchClassicInterpreter
        var shouldAnimate = Binding {game.masterState == .throwOver } set: { _ in }
        
        var body: some View {
            VStack() {
                if game.preferenceModel.distanceLabel &&  (game.masterState == .throwing || game.masterState == .throwOver ) {
                    BouncingText(shouldAnimate: shouldAnimate, text: "Distance", stallTime: 2) {  text in GameView.createText(text, with: titleFont, in: 33) }
                    BouncingText(shouldAnimate: shouldAnimate, text: correctDigitCount(for: "\(observedBall.position.y.trimCGFloat(2))", with: 2) + " ft.", stallTime: 2) {  text in GameView.createText(text, with: titleFont, in: 33) }
                }
            }.modifier(ConfettiBurstModifier(showing: GameView.game.preferenceModel.particles && game.masterState == .throwOver, delay: 1.9, repeatCount: -1))
                .modifier(appearancedMod(lightColor: Colors.settingsShadow, darkColor: Colors.darkTextGrey, colorColor: Colors.settingsShadow))
        }
    }
        
    struct NotificationManager: View {
        @ObservedObject var observedBall = game.currentBall
    
        var farthestThrowBinding = Binding { game.model.currentBall.position.y > GameView.game.model.stats[.farthestThrow] && GameView.game.masterState == .throwing} set: { _ in }
        var fastestThrowBinding = Binding {game.model.stats[.fastestThrow, true].history.last!.date > Date() - 1 } set: { _ in }
        var trueBinidng = Binding { true } set: { _ in }
        
        var body: some View {
            GeometryReader { screenGeo in
                ZStack {
                    HStack(alignment: .center, spacing: 0) {
                        notification(duration: 4, placementIndex: -4, binding: fastestThrowBinding ) { GameView.createText("Fastest \nThrow!", with: boldDefaultFont, in: 25, lineLimit: 2) }
                        .frame(width: screenGeo.size.width / 2)
                        notification(duration: 4, placementIndex: -4, binding: farthestThrowBinding ) { GameView.createText("Farthest\n Throw!", with: boldDefaultFont, in: 25, lineLimit: 2) }
                        .frame(width: screenGeo.size.width / 2)
                    }
                    VStack {
                               
                        Spacer(minLength: screenGeo.size.height * 0.75)
                        
                        StateBasedNotifcation(entranceState: .caught, exitState: .returning, triggerEvent: fastestThrowBinding) {
                            BouncingText(shouldAnimate: trueBinidng, text: "Fastest Throw!", stallTime: 2.5) { text in GameView.createText(text, in: 25) } }
                        
                        StateBasedNotifcation(entranceState: .caught, exitState: .returning, triggerEvent: farthestThrowBinding) {
                            BouncingText(shouldAnimate: trueBinidng, text: "Farthest Throw!", stallTime: 2.5) { text in GameView.createText(text, in: 25) } }
                        
                    }.frame(maxHeight: screenGeo.size.height * 0.85)
                }
            }
        }
    }
    
    struct StateBasedNotifcation<someView: View>: View {
        let entranceState: FetchClassic.StateEnum
        let exitState: FetchClassic.StateEnum
        
        @State var showing = false
        @State var inState = false
        @Binding var triggerEvent: Bool
        let content: () -> someView
        var body: some View {
            ZStack {
                if showing && inState {
                    content()
                        .transition(.opacity)
                        .modifier(ConfettiBurstModifier(showing: GameView.game.preferenceModel.particles, delay: 0, repeatCount: 1))
                        .modifier(appearancedMod(lightColor: Colors.settingsShadow, darkColor: Colors.darkTextGrey, colorColor: Colors.settingsShadow))
                }
            }
                .onChange(of: triggerEvent) { _ in showing = true }
                .onChange(of: GameView.game.currentState) { _ in
                    if GameView.game.currentState == entranceState { inState = true }
                    if GameView.game.currentState == exitState { inState = false; showing = false }
                }
        }
    }
    
    
    struct goldDisplayer: View {
        let geo: GeometryProxy
        @EnvironmentObject var test: FetchClassicInterpreter
        var trueBinidng = Binding { GameView.game.masterState == .throwOver } set: { _ in }
        
        var body: some View {
            if test.currentState != .throwing {
                PixelImage(appearanced ("coinIcon" ))
                    .frame(minWidth: geo.size.width, maxHeight: geo.size.height * 0.1, alignment: .leading)
                    .overlay( GeometryReader { coinGeo in
                        HStack(alignment: .center) {
                            Spacer().frame(width: coinGeo.size.height * ( 10 / 11 ))

                            VStack(alignment: .leading) {
                                RollingNumber(newNumber: $test.gold) { text in ShadowFont(text, with: titleFont, in: 30, shadowColor: Colors.goldShadow, lightShadowColor: Colors.goldShadow, darkShadowColor: Colors.darkTextGrey) }
                                    .frame(height: coinGeo.size.height)
                                    .padding(.horizontal)
                                    .modifier(appearancedMod(lightColor: Colors.settingsShadow, darkColor: .white, colorColor: .white))
                                    .background( GeometryReader { textGeo in
                                        VStack {
                                            Spacer()
                                            Image( appearanced("coinBack"))
                                                .resizable()
                                                .interpolation(.none)
                                                .frame(width: textGeo.size.width, height: (7 / 11) * coinGeo.size.height, alignment: .leading)
                                            Spacer()
                                        }
                                    })
                                notification(duration: 4, placementIndex: 0, binding: trueBinidng ) {
                                       let goldPointsCount = test.stats[.gold, true].history.count - 1
                                       GameView.createText("+ \(Int( CGFloat(test.gold) - (test.stats[.gold, true].history[goldPointsCount - 1].value))) gold!", in: 25)
                                }.padding(.leading)
                                .modifier(ConfettiBurstModifier(showing: GameView.game.preferenceModel.particles, delay: 0, repeatCount: 1))
                            }
                        }
                    })
            }
            
        }
    }
    
    struct fade: View {
        let direction: Double
        var body: some View {
            Image("backGrad")
                .resizable()
                .interpolation(.none)
                .ignoresSafeArea()
                .frame(height: 150)
                .rotationEffect(Angle(degrees: direction), anchor: .center)
        }
    }
    
    struct menuButton<someView: View>: View {
        @State var sheetIsPresenting = false
        @EnvironmentObject var environmentGame: FetchClassicInterpreter
        let imageName: String
        let viewToPresent: someView
        
        var body: some View {
            Button(action: { sheetIsPresenting = true }) { }
            .buttonStyle(PixelButton(root: imageName,appearance:  environmentGame.returnStringedAppearance(environmentGame.appearance))  )
                .frame(minWidth: 0, idealWidth: 100, maxWidth: 150, minHeight: 0, idealHeight: 100, maxHeight: 150, alignment: .leading)
                .transition(.FallAwayTransition(offSet: -100))
                .sheet(isPresented: $sheetIsPresenting) { viewToPresent }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}


