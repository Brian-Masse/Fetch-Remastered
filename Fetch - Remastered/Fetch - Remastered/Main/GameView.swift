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
    
    let test: SKView = SKView()
    
    func createGameScene(in size: CGSize) -> GameScene {
        
        if size != globalFrame.size {
            globalScene.size = size
            globalScene.sizeDidChange(in: size)
            globalFrame.size = size
        }
        return globalScene
    }
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                
            
                SpriteView(scene: createGameScene(in: geo.size))
                .ignoresSafeArea()
                
            VStack(alignment: .leading) {
                ShadowFont(text: "\(GameView.game.model.currentDog.type.skin)", fontStruct: defaultFont, fontSize: 100)
                    .foregroundColor(.white)
                ShadowFont(text: "Gold: \(GameView.game.model.gold)", fontStruct: defaultFont, fontSize: 100)
                    .foregroundColor(.white)
                Spacer()
                if observedGame.model.currentState == .throwOver || observedGame.model.currentState == .caught {
                    PixelImage("Return")
                        .frame(maxWidth: 100)
                        .onTapGesture {
                            GameView.game.changeState(.returning)
                        }
                }
                Spacer()
                HStack {
                    menuButton(imageName: "GoldShop")
                    menuButton(imageName: "Profile")
                    menuButton(imageName: "ModifierShop")

                }
            }
        }
        }
    }
}

struct menuButton: View {
    
    @State var sheetIsPresenting = false
    let imageName: String
//    var blockToRun: () -> Void
    
    var body: some View {
        Image(imageName)
            .resizable()
            .interpolation(.none)
            .aspectRatio(contentMode: .fit)
            .onTapGesture {
                sheetIsPresenting = true
            }

        .sheet(isPresented: $sheetIsPresenting) {
//                blockToRun()
            CosmeticsSheet(viewModel: GameView.game)
        }
    }
}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        GameView()
//    }
//}


