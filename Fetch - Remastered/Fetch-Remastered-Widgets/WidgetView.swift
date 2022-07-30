//
//  WidgetView.swift
//  Fetch - Remastered
//
//  Created by Brian Masse on 8/24/21.
//  Copyright © 2021 Brian Masse. All rights reserved.
//

import Foundation
import SwiftUI
import WidgetKit

@available(macCatalyst 14.0, *)
struct WidgetView: View {
    
    let inBuildingMode: Bool
    let data: WidgetData
    let size: WidgetFamily
    
    @Binding var activeDataPosition: WidgetData.DataPosition
    
    @ViewBuilder
    static func createWidgetText(_ text: String, with font: ShadowedFont, in size: CGFloat, for data: WidgetData, lineLimit: Int = 1) -> some View {
        
        ShadowFont(text, with: font, in: size, shadowColor: Colors.decodeColor(data.shadowColor), lineLimit: lineLimit, lightShadowColor: Colors.decodeColor(data.shadowColor), darkShadowColor: Colors.decodeColor(data.shadowColor))
            .foregroundColor( Colors.decodeColor(data.fontColor))
    }
    
    @ViewBuilder
    func backGround(_ name: String, at opacity: CGFloat) -> some View {
        Image(name)
            .resizable()
            .interpolation(.none)
            .ignoresSafeArea()
            .opacity(Double(opacity))
            .aspectRatio(contentMode: .fill)
    }
    
    var body: some View {
        GeometryReader { geo in
            switch size {
            case .systemSmall: SingleDataView(data: data, dataPosition: .topLeft, b: inBuildingMode, activePos: $activeDataPosition)
            case .systemMedium: HStack {
                SingleDataView(data: data, dataPosition: .topLeft, b: inBuildingMode, activePos: $activeDataPosition)
                SingleDataView(data: data, dataPosition: .topRight, b: inBuildingMode, activePos: $activeDataPosition)
            }
            case .systemLarge:
                VStack(spacing: 0)  {
                    HStack(spacing: 0) {
                        SingleDataView(data: data, dataPosition: .topLeft, b: inBuildingMode, activePos: $activeDataPosition)
                        SingleDataView(data: data, dataPosition: .topRight, b: inBuildingMode, activePos: $activeDataPosition)
                    }
                    HStack {
                        SingleDataView(data: data, dataPosition: .bottomLeft, b: inBuildingMode, activePos: $activeDataPosition)
                        SingleDataView(data: data, dataPosition: .bottomRight, b: inBuildingMode, activePos: $activeDataPosition)
                    }
                }
            default: Text("empty")
            }
        }.background(
            ZStack {
                Rectangle().foregroundColor(.white).ignoresSafeArea()
                backGround(data.backBackGround, at: data.backBackOpacity)
                backGround(data.background, at: data.backOpacity)
            })
    }
    
    struct SingleDataView: View {
        let data: WidgetData
        let dataPosition: WidgetData.DataPosition
        let b: Bool
        @Binding var activePos: WidgetData.DataPosition
        
        
        var body: some View {
            GeometryReader { geo in
                VStack(alignment: .leading) {
                    if data[dataPosition].dataType != .data  {
                        PixelImage(data[dataPosition].value)
                    }else {
                        Spacer()
                        WidgetView.createWidgetText(data[dataPosition].displayName, with: titleFont, in: geo.size.width * 0.15, for: data, lineLimit: returnNumberOfNeededLines(in: data[dataPosition].displayName))
                            .multilineTextAlignment(.leading)
                            .minimumScaleFactor(0.1)
                        emptySpace(with: 1)
                        WidgetView.createWidgetText(data[dataPosition].value, with: titleFont, in: geo.size.width * 0.15, for: data)
                            .minimumScaleFactor(0.1)
                        Spacer()
                    }
                }
                .padding()
                .modifier(selection(currentPos: $activePos, dataPos: dataPosition, b: b))
            }
        }
    }
    
    struct selection: ViewModifier {
        
        @Binding var currentPos: WidgetData.DataPosition
        let dataPos: WidgetData.DataPosition
        let b: Bool
        
        func body(content: Content) -> some View {
            content
                .overlay(GeometryReader { geo in
                    Rectangle()
                        .opacity(0.01)
                        .onTapGesture { if b { currentPos = dataPos } }
                })
                .overlay(VStack {
                    if b { GeometryReader { geo in
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(dataPos == currentPos && b ? .blue: .clear, lineWidth: 5)
                            .padding(10)
                    }}
                })
                
            
                
        }
    }
}

