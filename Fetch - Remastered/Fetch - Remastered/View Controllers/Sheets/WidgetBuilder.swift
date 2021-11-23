//
//  WidgetBuilder.swift
//  Fetch - Remastered
//
//  Created by Brian Masse on 8/25/21.
//  Copyright © 2021 Brian Masse. All rights reserved.
//

import Foundation
import SwiftUI
import WidgetKit

struct WidgetBuilder: View {
    @State var currentSize: WidgetFamily = .systemSmall
    @State var currentWidget: Int = 0
    @State var currentDataPosition: WidgetData.DataPosition = .topLeft
    @State var activeWidgetData: WidgetData = WidgetData(in: .systemSmall, for: "testingWidget")

    @EnvironmentObject var game: FetchClassicInterpreter
    
    @ViewBuilder
    static func createWidgetBuilderText(_ text: String, with font: ShadowedFont, in size: CGFloat, lineLimit: Int = 1) -> some View {
        ShadowFont(text, with: font, in: size, shadowColor: Colors.builderShadowColor, lineLimit: lineLimit, lightShadowColor: Colors.builderShadowColor, darkShadowColor: Colors.darkTextGrey)
            .modifier( appearancedMod(lightColor: Colors.builderLightColor, darkColor: .white, colorColor: .white) )
    }
    
    static func returnColor() -> Color {
        switch GameView.game.appearance {
        case .light: return .white
        default: return Colors.builderShadowColor
        }
    }

    @State var currentColorOption = ColorSelector.ColorOptions.background
    
    var body: some View {
        GeometryReader { topLevelGeo in
            VStack(alignment: .leading) {
                WidgetBuilder.createWidgetBuilderText("Widget \nBuilder", with: titleFont, in: 40, lineLimit: 2).padding(.leading)
                
                HStack {
                    Spacer()
                    WidgetPreview(width: topLevelGeo.size.height * 0.25, currentSize: currentSize, activeWidgetData: activeWidgetData, activeDataPosition: $currentDataPosition)
                        .frame(maxHeight: topLevelGeo.size.height * 0.25)
                    Spacer()
                }
                .background( Rectangle().foregroundColor(Color(UIColor(red: 1, green: 1, blue: 1, alpha: 0.3))))
        
                ScrollView {
                    VStack(spacing: 0) {
                        EnumSelector(currentEnumValue: $currentSize, title: "Active Size", names: [ "small", "medium", "large" ], accent: Colors.builderShadowColor ) { text, size, lines in WidgetBuilder.createWidgetBuilderText(text, with: titleFont, in: size, lineLimit: lines) }
                            .onChange(of: currentSize) { _ in
                                currentWidget = WidgetBuilder.returnActiveListOfWidgets(in: currentSize).count - 1
                                currentDataPosition = .topLeft
                            }
                        HStack {
                            Spacer()
                            WidetControls(currentWidget: $currentWidget, activeWidgetData: $activeWidgetData, currentSize: $currentSize)
                                .onChange(of: currentWidget) { value in
                                    activeWidgetData = WidgetBuilder.returnActiveListOfWidgets(in: currentSize)[value]
                                }
                            Spacer()
                        }.background( Rectangle().foregroundColor(Color(UIColor(red: 1, green: 1, blue: 1, alpha: 0.3))))
                    }
                    
            
                    ColorSelector(width: topLevelGeo.size.width, currentColorOption: $currentColorOption, activeWidgetData: $activeWidgetData)
                    
                    DataPicker(" Dogs ", in: game.dogs, for: .dog, width: topLevelGeo.size.width, unlockedGetter: { i in game.dogs[i].isUnlocked}, displayNameGetter: { i in game.dogs[i].skin})
                        { i in "\(game.dogs[i].skin)" }
                    
                    DataPicker(" Balls ", in: game.balls, for: .ball, width: topLevelGeo.size.width, unlockedGetter: { i in game.balls[i].isUnlocked}, displayNameGetter: { i in game.balls[i].skin})
                        { i in "\(game.balls[i].skin)1" }
//
                    DataPicker(" Statistics ", in: game.stats.propertyList, for: .data, width: topLevelGeo.size.width, displayNameGetter: { index in game.stats.propertyList[index].displayName})
                        {index in "\(game.stats.propertyList[index].value.trimCGFloat(2))" }
                    
                }
            }
        }
        .background(PixelImage( appearanced("WidgetBuilderBack")).ignoresSafeArea().aspectRatio(contentMode: .fill))
    }
    
    struct WidetControls: View {
        @Binding var currentWidget: Int
        @Binding var activeWidgetData: WidgetData
        @Binding var currentSize: WidgetFamily
        
        @EnvironmentObject var game: FetchClassicInterpreter

        @State var showingSelector = false
        
        var body: some View {
            VStack(spacing: 7) {
                
                WidgetBuilder.createWidgetBuilderText("Widget Controls", with: titleFont, in: 20)
                    .padding(.bottom, 3)
                    .padding(.top)
                
                DesignedButton(accent: WidgetBuilder.returnColor(), design: { WidgetBuilder.createWidgetBuilderText("Switch Current Widget", with: titleFont, in: 15) }) { showingSelector = true }
                    .sheet(isPresented: $showingSelector) {
                        switch currentSize {
                        case .systemSmall: widgetSelector(title: "Small \nWidgets", size: $currentSize, currentWidget: $currentWidget).environmentObject(GameView.game)
                        case .systemMedium: widgetSelector(title: "Medium \nWidgets", size: $currentSize, currentWidget: $currentWidget).environmentObject(GameView.game)
                        case .systemLarge: widgetSelector(title: "Large \nWidgets", size: $currentSize, currentWidget: $currentWidget).environmentObject(GameView.game)
                        default: Text("This widget is not implimented")
                        }
                    }
                
                DesignedButton(accent: WidgetBuilder.returnColor(), design: { WidgetBuilder.createWidgetBuilderText("Save Current Widget", with: titleFont, in: 15) }) {
                        game.saveNewWidget(activeWidgetData, at: currentWidget, in: currentSize)
                        game.stats.sendDataToWidgets()
                        game.model.sendDataToWidgets()
                }
            }
        }
    }
    
    struct ColorSelector: View {
        
        enum ColorOptions: Int, CaseIterable {
            case background
            case fontColor
            case shadowColor
            case backBackGround
        }
        
        let width: CGFloat
        @Binding var currentColorOption: ColorOptions
        @Binding var activeWidgetData: WidgetData
        @State var opacity: CGFloat = 255
        
        
        var body: some View {
            VStack(alignment: .leading) {
                WidgetBuilder.createWidgetBuilderText("Colors", with: titleFont, in: 20)
                    .padding(.bottom)
                
                EnumSelector(currentEnumValue: $currentColorOption, title: "Color Options", names: [ "Back \nground", "Font \nColor", "Font \nShadow", "Back \nColor"], accent: Colors.builderShadowColor ) { text, size, lines in WidgetBuilder.createWidgetBuilderText(text, with: titleFont, in: size, lineLimit: lines) }
                
                WidgetBuilder.createWidgetBuilderText("Opacity", with: titleFont, in: 20)
                Slider(value: $opacity, in: 0...255, onEditingChanged: { edited in
                    
                    switch currentColorOption {
                    case .background: activeWidgetData.backOpacity = opacity / 255
                    case .fontColor: activeWidgetData.fontColor[3] = opacity
                    case .shadowColor: activeWidgetData.shadowColor[3] = opacity
                    case .backBackGround: activeWidgetData.backBackOpacity = opacity / 255
                    }
                }).accentColor(Colors.builderShadowColor)
                .onChange(of: currentColorOption) { _ in
                    switch currentColorOption {
                    case .background: opacity = activeWidgetData.backOpacity * 255
                    case .fontColor: opacity = activeWidgetData.fontColor[3]
                    case .shadowColor: opacity = activeWidgetData.shadowColor[3]
                    case .backBackGround: opacity = activeWidgetData.backBackOpacity * 255
                    }
                }
                
                
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 80, maximum: 150), spacing: 5)], spacing: 5) {
                    
                    ForEach(Colors.WidgetColors.indices) { i in
                        Button(action: {
                            switch currentColorOption {
                            case .background: activeWidgetData.background = Colors.compressColorData(index: i)
                            case .fontColor: activeWidgetData.fontColor = Colors.WidgetColors[i]
                            case .shadowColor: activeWidgetData.shadowColor = Colors.WidgetColors[i]
                            case .backBackGround: activeWidgetData.backBackGround = Colors.compressColorData(index: i)
                            }
                        }) {
                        Image(Colors.compressColorData(index: i))
                            .resizable()
                            .interpolation(.none)
                            .aspectRatio(2, contentMode: .fit)
                            .modifier(framify(.white, padded: false))
                        }
                    }
                }
            }.modifier(framify(Colors.builderDarkPurple))
        }
    }
    
    //MARK: Content Selectors
    
    @ViewBuilder
    func DataPicker<T>( _ title: String, in list: [T], for type: WidgetData.DataType, width: CGFloat, unlockedGetter: @escaping (Int) -> Bool = { _ in true }, displayNameGetter: @escaping (Int) -> String, valueGetter: @escaping (Int) -> String ) -> some View {

        VStack(alignment: .leading) {
            WidgetBuilder.createWidgetBuilderText(title, with: titleFont, in: 23)
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100, maximum: 150), spacing: 5)], spacing: 5) {
                
                if type == .dog {
                    DataDisplay(for: type, with: "Current \n\(type)", and: game.model.determineCurrentObjects().0!.skin, at: -1)
                }else if type == .ball {
                    DataDisplay(for: type, with: "Current \n\(type)", and: game.model.determineCurrentObjects().1!.skin, at: -1)
                }
                
                ForEach(list.indices) { index in
                    DataDisplay(for: type, with: displayNameGetter(index), and: valueGetter(index), at: index, isUnlocked: unlockedGetter(index))
                }
            }
        }
        .modifier(framify(Colors.builderDarkPurple))
        .padding(.horizontal, 2)
    }
    
    @ViewBuilder
    func DataDisplay(for type: WidgetData.DataType, with displayName: String, and value: String, at index: Int, isUnlocked: Bool = true) -> some View {
        Button(action: { changeDisplayData(at: index, as: type) } ) {
        
            Rectangle()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Color(UIColor(red: 1, green: 1, blue: 1, alpha: 0.1)))
                .overlay( GeometryReader { geo in
                    VStack() {
                        if type == .data {
                            WidgetBuilder.createWidgetBuilderText(displayName, with: titleFont, in: 15, lineLimit: returnNumberOfNeededLines(in: displayName))
                                .multilineTextAlignment(.center)
                                .padding(.top)
                            emptySpace(with: 1)
                            WidgetBuilder.createWidgetBuilderText(value, with: defaultFont, in: 15)
                        } else {
                            ZStack {
                                Rectangle().foregroundColor(.clear)
                                PixelImage( appearanced( "glow" ))
                                PixelImage(value)
                                    .padding()
                            }.overlay(
                                VStack {
                                    Spacer()
                                    WidgetBuilder.createWidgetBuilderText(displayName, with: titleFont, in: 20, lineLimit: returnNumberOfNeededLines(in: displayName))
                                        .multilineTextAlignment(.center)
                                        .minimumScaleFactor(0.5)
                                        .padding([.bottom, .horizontal])
                            })
                        }
                    }
                })
            .modifier(framify(Colors.builderShadowColor, in: 414, padded: false))
        }
    }
    
    func changeDisplayData(at listAccessor: Int, as data: WidgetData.DataType ) {
        game.stats.createWidgetDataIdentifierAndKey(propertyIndex: listAccessor, at: currentDataPosition, in: currentSize, as: data)
        activeWidgetData.updateKeyBuilders(listAccessor: listAccessor, as: data, for: currentDataPosition)
        activeWidgetData.inquiryData()
    }
    
    struct WidgetPreview: View {
        let width: CGFloat
        let currentSize: WidgetFamily
        let activeWidgetData: WidgetData
        @Binding var activeDataPosition: WidgetData.DataPosition
        
        var body: some View {
            Rectangle()
                .aspectRatio(WidgetBuilder.returnAspectRatioBasedOnSize(in: currentSize), contentMode: .fit)
                .foregroundColor(.white)
                .cornerRadius(width * 0.15)
                .padding()
                .shadow(color: .black, radius: 10, x: 0, y: 0)
                .overlay( GeometryReader { geo in
                    WidgetView(inBuildingMode: true, data: activeWidgetData, size: currentSize, activeDataPosition: $activeDataPosition)
                        .padding()
                        .mask( Rectangle()
                                .aspectRatio(WidgetBuilder.returnAspectRatioBasedOnSize(in: currentSize), contentMode: .fit)
                                .foregroundColor(.white)
                                .cornerRadius(width * 0.15)
                                .padding() )
                })
        }
    }
    
    //MARK: Useful funcs
    
    static func returnActiveListOfWidgets(in size: WidgetFamily) -> [WidgetData] {
        switch size {
        case .systemSmall: return GameView.game.preferenceModel.smallWidgets
        case .systemMedium: return GameView.game.preferenceModel.mediumWidgets
        case .systemLarge: return GameView.game.preferenceModel.largeWidgets
        default: return []
        }
    }
    
    static func returnAspectRatioBasedOnSize(in size: WidgetFamily) -> CGFloat {
        switch size {
        case .systemSmall: return 1
        case .systemMedium: return 360 / 169
        case .systemLarge: return 360 / 376
        default: return 1
        }
    }
}

//
//struct ContentView_Previews: PreviewProvider {
//    
//    static var previews: some View {
//        WidgetBuilder()
////        WidgetBuilder.widgetSelector(title: "Small \nWidgets", size: .systemSmall, currentWidget: 0, showingSelector: true)
//            .environmentObject(GameView.game)
//    }
//}
//
//
//
//
