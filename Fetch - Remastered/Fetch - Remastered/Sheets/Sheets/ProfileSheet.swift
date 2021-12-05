//
//  ProfileSheet.swift
//  Fetch - Remastered
//
//  Created by Brian Masse on 8/2/21.
//  Copyright © 2021 Brian Masse. All rights reserved.
//

import SwiftUI

struct ProfileSheet: View {

    @EnvironmentObject var game: FetchClassicInterpreter
    
    static let frameColor = Colors.profileLightPink
    
    var body: some View {
        GeometryReader { geo in
            ScrollView(.vertical) {

                VStack(alignment: .leading, spacing: 5) {

                    constants.createStatsText("Profile", with: titleFont, in: 50)
                        .padding(.leading)
//
                    emptySpace(with: 50)
                    throwData(geo: geo)

                    emptySpace(with: 50)
                    goldData(geo: geo)

                    emptySpace(with: 50)
                    modifierData(geo: geo)
                    
                    emptySpace(with: 50)
                    ExtraData(geo: geo)

                    if game.stats.legacyFarthestThrow != 0 {
                        emptySpace(with: 50)
                        legacyData()
                    }
                }
            }
        }
        .background(PixelImage( appearanced("ProfileBack") )
                        .ignoresSafeArea()
                        .aspectRatio(contentMode: .fill))
    }

    struct constants {
        @ViewBuilder
        static func createStatsText(_ text: String, with font: ShadowedFont, in size: CGFloat, lineLimit: Int = 1) -> some View {
            ShadowFont(text, with: font, in: size, shadowColor: Colors.cosmeticsLighShadow, lineLimit: lineLimit, darkShadowColor: Colors.profilePink )
                .modifier(appearancedMod(lightColor: Colors.cosmeticsLightColor, darkColor: .white, colorColor: Colors.profileLightPink))
        }
        
        @ViewBuilder
        static func defaullFrameFill() -> some View {
            Rectangle().foregroundColor( ProfileSheet.constants.returnFillColor() )
        }
        
        static func returnFillColor() -> Color {
            switch GameView.game.preferenceModel.appearance {
            case .dark: return Color(UIColor(red: 0, green: 0, blue: 0, alpha: 0.25))
            default: return Color(UIColor(red: 1, green: 1, blue: 1, alpha: 0.4))
            }
        }
    }
    
    struct legacyData: View {
        @EnvironmentObject var game: FetchClassicInterpreter
        
        var body: some View {
            constants.createStatsText("Legacy Data:", with: titleFont, in: 25)
            
            VStack {
                VStack {
                    constants.createStatsText("Throw Data", with: titleFont, in: 20)
                    emptySpace(with: 5)
                    HStack {
                        VStack(alignment: .leading) {
                            constants.createStatsText("Farthest \nThrow", with: titleFont, in: 20, lineLimit: 2).fixedSize()
                            constants.createStatsText("\(game.stats.legacyFarthestThrow.trimCGFloat(2)) ft.", with: titleFont, in: 20)
                        }
                        VStack(alignment: .leading) {
                            constants.createStatsText("\(game.stats.legacyMapDiscovered.trimCGFloat(2))%", with: titleFont, in: 20)
                            constants.createStatsText("of the map \nwas \ndiscovered", with: titleFont, in: 20, lineLimit: 3).fixedSize()
                        }
                    }
                }.modifier(framify(ProfileSheet.frameColor) { constants.defaullFrameFill() } )
                VStack {
                    constants.createStatsText("Gold Data", with: titleFont, in: 20)
                    emptySpace(with: 5)
                    HStack(spacing: 20) {
                        VStack(alignment: .leading) {
                            constants.createStatsText("Most \ngold", with: titleFont, in: 20, lineLimit: 2).fixedSize()
                            constants.createStatsText("\(Int(game.stats.legacyMostGold))", with: titleFont, in: 20)
                        }
                        
                        VStack(alignment: .leading) {
                            constants.createStatsText("current \ngold", with: titleFont, in: 20, lineLimit: 2).fixedSize()
                            constants.createStatsText("\(Int(game.stats.legacyCurrentGold))", with: titleFont, in: 20)
                        }
                    }
                }.modifier(framify(ProfileSheet.frameColor) { constants.defaullFrameFill() } )
                
                VStack(alignment: .leading) {
                    constants.createStatsText("Modifier Data", with: titleFont, in: 20)
                    emptySpace(with: 5)
                    constants.createStatsText("x \(game.stats.legacyStrength) on all throws!", with: titleFont, in: 20)
                    emptySpace(with: 1)
                    constants.createStatsText("\(game.stats.legacyAero)% slow reduction \n    on all throws!", with: titleFont, in: 20, lineLimit: 2).fixedSize()
                    emptySpace(with: 1)
                    constants.createStatsText("\(game.stats.legacyMagnet)% chance of gold \n    every foot!", with: titleFont, in: 20, lineLimit: 2).fixedSize()
                }.modifier(framify(ProfileSheet.frameColor) { constants.defaullFrameFill() } )
                
                
            }.modifier(framify(ProfileSheet.frameColor))
        }
    }
    
    struct ExtraData: View {
        let geo: GeometryProxy
        @EnvironmentObject var game: FetchClassicInterpreter
        
        // number of unlocked, total number in list, percent
        func returnCosmeticData<objectType: gameObject>(_ objectList: [objectType]) -> (Int, Int, CGFloat) {
            var returningTuple: ( Int, Int, CGFloat ) = ( 0, objectList.count, 0 )
            for object in objectList {
                if object.isUnlocked { returningTuple.0 += 1 }
            }
            returningTuple.2 = (CGFloat(returningTuple.0) / CGFloat(returningTuple.1) * 100)
            return returningTuple
        }
        
        var body: some View {
            constants.createStatsText("Extra data:", with: titleFont, in: 25)
            
            VStack {
                
                let dogData = returnCosmeticData(GameView.game.model.dogs)
                constants.createStatsText("Dogs Unlocked:", with: titleFont, in: 20)
                constants.createStatsText("\(dogData.0) / \(dogData.1), \(dogData.2)%", with: titleFont, in: 20)
                
                emptySpace(with: 1)
                
                let ballData = returnCosmeticData(GameView.game.model.balls)
                constants.createStatsText("Balls Unlocked:", with: titleFont, in: 20)
                constants.createStatsText("\(ballData.0) / \(ballData.1), \(ballData.2)%", with: titleFont, in: 20)
                
                emptySpace(with: 1)
                
                constants.createStatsText("Map Discovered:", with: titleFont, in: 20)
                constants.createStatsText("\(game.model.stats[.farthestThrow].trimCGFloat(2)) ft., \(((game.model.stats[.farthestThrow] / 76202.46) * 100).trimCGFloat(2))%", with: titleFont, in: 20)
                
                
            }.modifier(framify(ProfileSheet.frameColor))
        }
        
        struct modifierDisplayer<someView: View>: View {
            
            let name: String
            let modifier: FetchClassicInterpreter.ModifierSubscriptAcessor
            
            let grapher: () -> someView
            @EnvironmentObject var game: FetchClassicInterpreter
            
            var body: some View {
                VStack(alignment: .leading) {
                    constants.createStatsText(name, with: titleFont, in: 25)
                    constants.createStatsText( game[modifier].description, with: titleFont, in: 21, lineLimit: 2).fixedSize()
                    emptySpace(with: 10)
                    grapher()
                    constants.createStatsText("current cost: \(game[modifier].returnCurrentPrice())", with: titleFont, in: 20)
                }
            }
        }
    }
    
    
    struct modifierData: View {
        let geo: GeometryProxy
        @EnvironmentObject var game: FetchClassicInterpreter
        
        var body: some View {
            constants.createStatsText("Modifiers data:", with: titleFont, in: 25)
            
            VStack {
                modifierDisplayer(name: "throw modifier", modifier: .throwModifier) {
                    Grapher(graphableData: game.stats[.throwModifier, true].history, fullWidth: geo.size.width)
                        .frame(height: 250)
                }.modifier(framify(ProfileSheet.frameColor) { constants.defaullFrameFill() })
                modifierDisplayer(name: "aero dynamics", modifier: .aeroModifier) {
                    Grapher(graphableData: game.stats[.aeroModifier, true].history, fullWidth: geo.size.width)
                        .frame(height: 250)
                }.modifier(framify(ProfileSheet.frameColor) { constants.defaullFrameFill() })
                modifierDisplayer(name: "gold magnet", modifier: .goldModifier) {
                    Grapher(graphableData: game.stats[.goldModifier, true].history, fullWidth: geo.size.width)
                        .frame(height: 250)
                }.modifier(framify(ProfileSheet.frameColor) { constants.defaullFrameFill() })
                emptySpace(with: 40)
            }.modifier(framify(ProfileSheet.frameColor))
        }
        
        struct modifierDisplayer<someView: View>: View {
            
            let name: String
            let modifier: FetchClassicInterpreter.ModifierSubscriptAcessor
            
            let grapher: () -> someView
            @EnvironmentObject var game: FetchClassicInterpreter
            
            var body: some View {
                VStack(alignment: .leading) {
                    constants.createStatsText(name, with: titleFont, in: 25)
                    constants.createStatsText( game[modifier].description, with: titleFont, in: 21, lineLimit: 2).fixedSize()
                    emptySpace(with: 10)
                    grapher()
                    constants.createStatsText("current cost: \(game[modifier].returnCurrentPrice())", with: titleFont, in: 20)
                }
            }
        }
    }
    
    struct goldData: View {
        let geo: GeometryProxy
        @EnvironmentObject var game: FetchClassicInterpreter
        
        var body: some View {
            constants.createStatsText("Gold Data", with: titleFont, in: 25)
            
            VStack(alignment: .leading) {
                constants.createStatsText("current gold", with: titleFont, in: 20)
                constants.createStatsText("\( game.model.gold )", with: titleFont, in: 20)
                
                Grapher(graphableData: game.stats[.gold, true].history, fullWidth: geo.size.width  )
                    .frame(minHeight: 200)
                
                HStack {
                    
                    VStack {
                        constants.createStatsText("most Gold:", with: titleFont, in: 18)
                        Grapher(graphableData: game.stats[.mostGold, true].history, fullWidth: geo.size.width / 2 )
                            
                    }
                    .frame(maxHeight: 400)
                    
                    VStack(alignment: .leading) {
                        constants.createStatsText("\(game.stats[.mostGold])", with: titleFont, in: 20)
                        
                        emptySpace(with: 20)
                        
                        constants.createStatsText("most \nexpensive \npruchase:", with: titleFont, in: 20, lineLimit: 3)
                            .fixedSize()
                        constants.createStatsText("\(game.stats[.biggestPruchase])", with: titleFont, in: 20)
                        
                        Spacer()
                    }
                    .frame(maxHeight: 400)
                }.modifier(framify(ProfileSheet.frameColor))
                
                emptySpace(with: 30)
            }.modifier(framify(ProfileSheet.frameColor) { constants.defaullFrameFill() })
        }
        
    }
    
    struct throwData: View {
        
        let geo: GeometryProxy
        @EnvironmentObject var game: FetchClassicInterpreter
        
        var body: some View {
            constants.createStatsText("Throw Data", with: titleFont, in: 25)

            VStack(alignment: .leading) {

                constants.createStatsText("Average Distance: ", with: titleFont, in: 20)
                constants.createStatsText("\(game.stats[.distanceAverage].trimCGFloat(2)) ft.", with: titleFont, in: 20)
                Grapher(graphableData: game.model.stats[.distanceAverage, true].history, fullWidth: geo.size.width  )
                    .frame(height: 200)
            

                HStack(spacing: 0) {
                    VStack(alignment: .leading) {
                        constants.createStatsText("Farthest \nThrows", with: titleFont, in: 20, lineLimit: 2)
                            .fixedSize()
                        Grapher(graphableData: game.stats[.farthestThrow, true].history, fullWidth: geo.size.width / 2 )
                            .frame(height: 250)

                        constants.createStatsText("Best Throw", with: titleFont, in: 18)
                        constants.createStatsText("\(game.stats[.farthestThrow].trimCGFloat(2)) \nft.", with: titleFont, in: 20, lineLimit: 2)
                            .fixedSize()
                        emptySpace(with: 10)
                        constants.createStatsText("Last Throw", with: titleFont, in: 18)
                        constants.createStatsText("\(game.stats[.throwDistance].trimCGFloat(2)) \nft.", with: titleFont, in: 20, lineLimit: 2)
                            .fixedSize()
                    }

                    VStack(alignment: .leading) {
                        constants.createStatsText("Fastest \nThrows", with: titleFont, in: 20, lineLimit: 2)
                            .fixedSize()
                        Grapher(graphableData: game.model.stats[.fastestThrow, true].history, fullWidth: geo.size.width / 2 )
                            .frame(height: 250)

                        constants.createStatsText(":", with: titleFont, in: 20)
                        constants.createStatsText("\(game.stats[.fastestThrow].trimCGFloat(2)) \nft. / s", with: titleFont, in: 20, lineLimit: 2)
                            .fixedSize()
                        emptySpace(with: 10)
                        constants.createStatsText(":", with: titleFont, in: 20)
                        constants.createStatsText("\(game.stats[.throwDistance].trimCGFloat(2)) \nft. / s", with: titleFont, in: 20, lineLimit: 2)
                            .fixedSize()
                    }
                } .modifier(framify(ProfileSheet.frameColor) { constants.defaullFrameFill() })

                emptySpace(with: 20)
                constants.createStatsText("All Distances: ", with: titleFont, in: 20)
                Grapher(graphableData: game.model.stats[.throwDistance, true].history, fullWidth: geo.size.width  )
                    .frame(height: 200)
                
                constants.createStatsText("Total number of throws: ", with: titleFont, in: 20).minimumScaleFactor(0.7)
                constants.createStatsText("\(game.model.stats[.throwDistance, true].history.count - 1)", with: titleFont, in: 20)
            }.modifier(framify(ProfileSheet.frameColor))
            
        }
        
    }
}


struct Grapher: View {
    
    func canCombine(_ firstPoint: GraphablePoint, and secondPoint: GraphablePoint) -> Bool {

        if firstPoint.date.getInt(for: .year) == secondPoint.date.getInt(for: .year) {
            if unit == .year { return true }
            else if firstPoint.date.getInt(for: .month) == secondPoint.date.getInt(for: .month) {
                if unit == .month { return true }
                else if firstPoint.date.getInt(for: .day) == secondPoint.date.getInt(for: .day) {
                    if unit == .day {return true}
                    else if firstPoint.date.getInt(for: .minute) == secondPoint.date.getInt(for: .minute) {
                        if unit == .minute { return true }
                        else if firstPoint.date.getInt(for: .second) == secondPoint.date.getInt(for: .second) {
                            return true
                        } else { return false }
                    }else { return false }
                }else { return false}
            }else { return false }
        }else { return false }

    }

    func createListOfDataPoints(_ startingIndex: Int) -> [GraphablePoint] {

        var returningList: [GraphablePoint] = []
        if startingIndex == graphableData.count - 1 { return [graphableData.last!] }

        for index in startingIndex + 1...graphableData.count - 1 {

            if !canCombine(graphableData[index], and: graphableData[index - 1]) {
                returningList.append( graphableData[index - 1] )
                returningList += createListOfDataPoints(index)
                return returningList
            }else if graphableData.count - 1 == index { return [graphableData.last!] }
        }
        return returningList
    }

    func determineExtremum(in list: [ GraphablePoint ]) -> CGPoint {
        var extrumum: CGPoint = CGPoint(x: 0, y: 0)
        for point in list {
            if point.value > extrumum.y { extrumum.y = point.value }
            else if point.value < extrumum.x { extrumum.x = point.value }
        }
        return extrumum
    }
    
    
    
    @State var unit: Calendar.Component = .second
    @State var showingSelector: Bool = false
    let graphableData: [GraphablePoint]
    let fullWidth: CGFloat
    
    
    var body: some View {
        let combinedDataPoints: [GraphablePoint] = createListOfDataPoints(0)
        let extremum = determineExtremum(in: combinedDataPoints)
        
        ZStack(alignment: .topTrailing) {
            GeometryReader { topGeo in
            
                let textSize = max(min(topGeo.size.height * topGeo.size.width * 0.00007, 15), 10)
                
                let emptySpace = CGSize(width: 100, height: textSize * 6.66)
                let aliveSpace = CGSize(width: topGeo.size.width - emptySpace.width, height: topGeo.size.height - emptySpace.height)
                
                ZStack(alignment: .bottom) {
                    HStack(spacing: 0) {
                        
                        leftLabels(aliveHeight: aliveSpace.height, emptyHeight: emptySpace.height, extremum: extremum, textSize: textSize )
                            .fixedSize()
                        VStack {
                            Rectangle()
                                .frame(width: 5, height: aliveSpace.height)
                                .modifier(appearancedMod(lightColor: .white, darkColor: Colors.darkTextGrey, colorColor: Colors.profilePink))
                            Spacer()
                        }
                        bars(fullWidth: fullWidth, combinedDataPoints: combinedDataPoints, extremum: extremum, textSize: textSize, unit: unit, emptySpace: emptySpace)
                            .background(
                                VStack {
                                    Rectangle()
                                        .foregroundColor( ProfileSheet.constants.returnFillColor() )
                                    Spacer(minLength: emptySpace.height)
                                })
                    }
                    Rectangle()
                        .modifier(appearancedMod(lightColor: .white, darkColor: Colors.darkTextGrey, colorColor: Colors.profilePink))
                        .frame(height: 5)
                        .offset(x: 0, y: -emptySpace.height)
                        .padding(.leading)
                }
                .padding(.horizontal)
            }.zIndex(0)
            .overlay( ZStack(alignment: .topTrailing) {
                Rectangle().foregroundColor(.clear)
                if showingSelector {
                    ViewSelector(unit: $unit, showing: $showingSelector)
                        .padding()
                        .frame(minHeight: 300)
                        .zIndex(2)
                }else {
                    PixelImage("selectorPrompt")
                        .frame(maxWidth: 30)
                        .padding([.trailing, .top])
                        .zIndex(1)
                        .onTapGesture { withAnimation { showingSelector = true } }
                }
            })
        }
    }
    
    struct ViewSelector: View {
        
        @Binding var unit: Calendar.Component
        @Binding var showing: Bool
        
        var body: some View {
            VStack {
                ZStack{
                    HStack{
                        ProfileSheet.constants.createStatsText("viewing \nunit", with: titleFont, in: 17, lineLimit: 2).minimumScaleFactor(0.5)
                        Spacer()
                        ProfileSheet.constants.createStatsText("x", with: boldDefaultFont, in: 34).minimumScaleFactor(0.5)
                            .padding(.bottom)
                            .onTapGesture { withAnimation { showing = false } }
                    }
                   
                }
                ScrollView(.vertical) {
                    VStack {
                    DesignedButton(accent: Colors.profileLightPink, design: { ProfileSheet.constants.createStatsText("second", with: titleFont, in: 15) }, action: { unit = .second })
                    DesignedButton(accent: Colors.profileLightPink, design: { ProfileSheet.constants.createStatsText("Hour", with: titleFont, in: 15) }, action: { unit = .hour })
                    DesignedButton(accent: Colors.profileLightPink, design: { ProfileSheet.constants.createStatsText("Day", with: titleFont, in: 15) }, action: { unit = .day })
                    DesignedButton(accent: Colors.profileLightPink, design: { ProfileSheet.constants.createStatsText("Week", with: titleFont, in: 15) }, action: { unit = .weekOfYear })
                    DesignedButton(accent: Colors.profileLightPink, design: { ProfileSheet.constants.createStatsText("Month", with: titleFont, in: 15) }, action: { unit = .month })
                    DesignedButton(accent: Colors.profileLightPink, design: { ProfileSheet.constants.createStatsText("Year", with: titleFont, in: 15) }, action: { unit = .year })
                    }
                }.frame(height: 150)
            }
            .modifier(framify(ProfileSheet.frameColor) { Image( appearanced("ProfileBack")).resizable().interpolation(.none) } )
            
            .transition(.scale(scale: 0))
        }
    }
    
    
    struct bars: View {
        
        let fullWidth: CGFloat
        
        let combinedDataPoints: [GraphablePoint]
        let extremum: CGPoint
        let textSize: CGFloat
        let unit: Calendar.Component
        let emptySpace: CGSize
        
        
        var body: some View {
            
            GeometryReader { scrollGeo in
                let extraBars = CGFloat(max(combinedDataPoints.count - Int(((scrollGeo.size.width / 282) * 20)), 0 ))
        
                ScrollView(.horizontal) {
                    HStack(spacing: 5) {
                        ForEach(combinedDataPoints.indices, id: \.self) { index in
                            let label = combinedDataPoints[index].date.localizeDescription(with: unit)
                            VStack(alignment: .leading, spacing: 0) {
                                Bar(value: combinedDataPoints[index].value, extrumumValues: extremum)
                                bottomLabel(label: label, emptySpaceHeight: emptySpace.height, textSize: textSize)

                                }
                        }
                    }.frame(width: scrollGeo.size.width + (extraBars * 20))
                }
            }
        }
    }
    
    struct leftLabels: View {
        
        let aliveHeight: CGFloat
        let emptyHeight: CGFloat
        let extremum: CGPoint
        let textSize: CGFloat
        
        var body: some View {
            VStack {
                ZStack(alignment: .bottom) {
                    VStack() {
                        ProfileSheet.constants.createStatsText("\(Int(extremum.y.trimCGFloat(2)))", with: defaultFont, in: textSize)
                        Spacer()
                        ProfileSheet.constants.createStatsText("\(Int(extremum.x.trimCGFloat(2)))", with: defaultFont, in: textSize)
                            .padding(.bottom)
                    }

                    let difference = extremum.y - extremum.x
                    let displayedDigits = (aliveHeight / 1000).rounded(.up)
                    let incriment = difference / ( displayedDigits + 1)

                    if difference > 0 {
                        ForEach(1...Int(displayedDigits), id: \.self) { index in
                            ProfileSheet.constants.createStatsText("\(Int(extremum.x + (CGFloat(index) * incriment)))", with: defaultFont, in: textSize)
                                .offset(x: 0, y: -aliveHeight * ((CGFloat( index ) * incriment) / difference))
                        }
                    }
                }.frame(height: aliveHeight)
                Spacer(minLength: emptyHeight)
            }
        }
    }

    struct bottomLabel: View {
        let label: String
        let emptySpaceHeight: CGFloat
        let textSize: CGFloat
        
        var body: some View {
            Rectangle()
                .foregroundColor(.clear)
                .frame(height: emptySpaceHeight)
                .overlay( GeometryReader { barGeo in
                    Text( label )
                        .lineLimit(1)
                        .font(Font.custom(defaultFont.font, fixedSize: textSize / 1.5 ))
                        .rotationEffect(Angle(degrees:  45), anchor: UnitPoint(x: 0, y: 1))
                        .frame(width: 300, height: 300, alignment: .topLeading)
//                        .offset(x: barGeo.size.width / 2, y: 0)
                        .modifier(appearancedMod(lightColor: Colors.cosmeticsLightColor, darkColor: .white, colorColor: Colors.profilePink))
                }, alignment: .topLeading)
            
        }
    }
    
    struct Bar: View {
        let value: CGFloat

        let extrumumValues: CGPoint

        var height: CGFloat {
            if extrumumValues.y - extrumumValues.x == 0 { return 1 }
            return (value - extrumumValues.x) / (extrumumValues.y - extrumumValues.x)
        }
        
        let graphTopRatio: CGFloat = 5 / 3
        

        var body: some View {
            GeometryReader { geo in
                
                let graphTopHeight = min(geo.size.width * (1 / graphTopRatio), geo.size.height * 0.8)
                let graphTopWidth = graphTopHeight * graphTopRatio
                
                HStack {
                    VStack(spacing: 0) {
                        Spacer()
                        
                        PixelImage("graphTop")
                            .frame(width: graphTopWidth, height: graphTopHeight)
                        
                        Image("graphBar")
                            .resizable()
                            .interpolation(.none)
                            .frame(width: graphTopWidth, height: max((geo.size.height - graphTopHeight - 20) * height, 1))
                    }
                    Spacer()
                }
            }
        }
    }
}



//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileSheet()
//            .environmentObject(GameView.game)
//    }
//}
