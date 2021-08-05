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
    @ObservedObject var observedGame = GameView.game
    
    var notificationManager = NotificationManager()
    
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
//                Rectangle()
//                    .foregroundColor(.red)
                
                VStack(alignment: .leading) {
                    goldDisplayer(geo: geo, viewModel: observedGame)
                        .padding([.leading, .top], 20)
                    menuButton(imageName: "MickeySit1", viewToPresent: Settings())
                    

                    if observedGame.currentState == .throwing {
                        fastFowardButton(speed: observedGame.model.speed)
                            .frame(maxWidth: geo.size.width * 0.25)
                    }
                    
            
                    Spacer()
                    if observedGame.model.currentState == .throwOver || observedGame.model.currentState == .caught {
                        PixelImage("Return")
                            .frame(maxWidth: 100)
                            .onTapGesture { GameView.game.changeState(.returning) }
                    }
                    
                    DistanceLabel(observedGame: observedGame)
                    
//
                    Spacer()
                    HStack {
                        if GameView.game.currentState == .home {
                            Spacer()
                            menuButton(imageName: "GoldShop", viewToPresent: ProfileSheet())
                            Spacer()
                            menuButton(imageName: "Profile", viewToPresent: CosmeticsSheet())
                            Spacer()
                            menuButton(imageName: "ModifierShop", viewToPresent: UpgradesSheet())
                            Spacer()
                        }
                    }
                }
                
                notificationManager
                
                
            }
        }
    }
    
    struct DistanceLabel: View {
        let observedGame: FetchClassicInterpreter
        @ObservedObject var observedBall = GameView.game.currentBall
        @State var shouldAnimate: Bool = false
        
        var body: some View {
            GeometryReader { geo in
                if observedGame.currentState == .throwing || observedGame.currentState == .caught || observedGame.model.currentState == .throwOver {
                    VStack(alignment: .center) {
                        ShadowFont("Distance", with: defaultFont, in: 33)
                        ShadowFont(correctDigitCount(for: "\(observedBall.position.y.trimCGFloat(2))", with: 2) + " ft.", with: defaultFont, in: 33)
                            .onChange(of: observedBall.position.y) { _ in if observedGame.currentState == .caught { shouldAnimate = true } else { shouldAnimate = false }}
                        
                    }
                    .transition(.FallAwayTransition(offSet: 100))
                    .modifier(RotBounceAnimation(35, shouldAnimate: $shouldAnimate)  )
                    .frame(width: geo.size.width)
                    .foregroundColor(.white)
                }
            }
        }
    }
        
    struct NotificationManager: View {
        @ObservedObject var observedBall = GameView.game.currentBall
    
        var farthestThrowBinding = Binding { GameView.game.model.currentBall.position.y > GameView.game.model.stats[.farthestThrow] } set: { _ in }
        var fastestThrowBinding = Binding { GameView.game.model.currentBall.physicsBody!.velocity.dy > GameView.game.model.stats[.fastestThrow] } set: { _ in }
    
        var body: some View {
            GeometryReader { screenGeo in
                ZStack {
                    HStack(alignment: .center, spacing: 0) {
                        ZStack {
                            notification(duration: 5, placementIndex: 2, binding: fastestThrowBinding ) {
                                ShadowFont("Fastest\n Throw!", with: boldDefaultFont, in: 80, shadowColor: UIConstants.goldShadow, lineLimit: 2)
                                    .foregroundColor(.white)
                            }
                        }.frame(width: screenGeo.size.width / 2, height: screenGeo.size.height)
                        ZStack {
                            notification(duration: 5, placementIndex: 1, binding: farthestThrowBinding ) {
                                ShadowFont("Farthest\n Throw!", with: boldDefaultFont, in: 80, shadowColor: UIConstants.goldShadow, lineLimit: 2)
                                    .foregroundColor(.white)
                            }
                        }.frame(width: screenGeo.size.width / 2, height: screenGeo.size.height)
                    }
                    
                }
            }
        }

    }
    
    struct goldDisplayer: View {
        let geo: GeometryProxy
        let viewModel: FetchClassicInterpreter
        let shadowColor = UIConstants.goldShadow
        
        @State var animatingGold = false
        
        func calculateIncriment() -> Int {
            let possiblyZero: CGFloat = (CGFloat(viewModel.model.gold) - CGFloat(viewModel.model.previousGold)) / 91
            if possiblyZero != 0 {
                let direction = possiblyZero / abs(possiblyZero)
                let notZero = abs(possiblyZero).rounded(.up)
                return Int(notZero * direction)
            }else { return 1 }
        }
        
        @ViewBuilder func whichTextShouldBeDisplayed() -> some View {
            
            if animatingGold { RollingNumber(number: viewModel.model.previousGold, newNumber: Int(viewModel.model.gold), incriment: calculateIncriment(), font: titleFont, size: 30, shadowColor: shadowColor, shadowed: true, completion: { animatingGold = false })}
            else { ShadowFont("\(viewModel.model.gold)", with: titleFont, in: 30, shadowColor: shadowColor) }
        }
        
        
        var body: some View {
            PixelImage("coinIcon")
                .frame(minWidth: geo.size.width, maxHeight: geo.size.height * 0.1, alignment: .leading)
                .overlay(
                    GeometryReader { coinGeo in
                        HStack(alignment: .center) {
                            Spacer()
                                .frame(width: coinGeo.size.height * ( 10 / 11 ))

                            whichTextShouldBeDisplayed()
                                .frame(height: coinGeo.size.height)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                                .onChange(of: GameView.game.model.gold) { _ in animatingGold = true }
                                .background(
                                    GeometryReader { textGeo in
                                        VStack {
                                            Spacer()
                                            Image("coinBack")
                                                .resizable()
                                                .interpolation(.none)
                                                .frame(width: textGeo.size.width, height: (7 / 11) * coinGeo.size.height, alignment: .leading)
                                            Spacer()
                                        }
                                    })
                        }
                    })
            
        }
    }
    
    struct menuButton<someView: View>: View {
        
        @State var sheetIsPresenting = false
        let imageName: String
        let viewToPresent: someView
        
        var body: some View {
            PixelImage(imageName)
                .frame(maxWidth: 150 )
                .sheet(isPresented: $sheetIsPresenting) { viewToPresent }
                .transition(.FallAwayTransition(offSet: -100))
                .onTapGesture {
                    sheetIsPresenting = true
                }
        }
    }
    
    struct fastFowardButton: View {
        let speed: Int
        @State var currentSpeed = Speed.normal
        
        enum Speed: Int, CaseIterable {
            case normal = 1
            case two = 2
            case five = 5
            case ten = 10
        }
        
        var body: some View {
            Button {
                let next = currentSpeed.next()
                GameView.game.changeGameSpeed(next.rawValue)
                currentSpeed = next
                
            } label: {
                HStack {
                    PixelImage("fastFoward")
                    Text("x \(speed)")
                        .foregroundColor(.white)
                        .font(Font.custom(titleFont.font, size: 40))
                        .minimumScaleFactor(0.001)
                        .lineLimit(1)
                }
            }
            .transition(.scale)
            .onDisappear { GameView.game.changeGameSpeed(1) }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Text("t")
    }
}


