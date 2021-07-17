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

struct ShadowedFont {
    let main: String
    let shadow: String
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

struct ShadowFont: View {
    let text: String
    let fontStruct: ShadowedFont
    let fontSize: CGFloat
    
    let opacity: CGFloat = 0.5
    
    var body: some View {
        ZStack {
            Text(text)
                .font(Font.custom(fontStruct.shadow, size: fontSize))
                .foregroundColor(Color(UIColor(red: 0, green: 0, blue: 0, alpha: opacity)))
            Text(text)
                .font(Font.custom(fontStruct.main, size: fontSize))
        }
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
