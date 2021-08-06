//
//  ProfileSheet.swift
//  Fetch - Remastered
//
//  Created by Brian Masse on 8/2/21.
//  Copyright © 2021 Brian Masse. All rights reserved.
//

import Foundation
import SwiftUI

struct ProfileSheet: View {

    @ObservedObject var observedGame = GameView.game
    
    var body: some View {
        VStack {
            Grapher(graphableData: GameView.game.model.$testGraph  )
            Grapher(graphableData: GameView.game.model.$testGraph  )
            Text("click here to add to a data point to the graph")
                .onTapGesture {
                    GameView.game.temp()
                }
        }
    }
    
    
}


struct Grapher: View {
    
    @State var unit: Calendar.Component = .second
    let graphableData: [GraphablePoint]
    
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
    
    var body: some View {
           
        let combinedDataPoints = createListOfDataPoints(0)
        let extremum = determineExtremum(in: combinedDataPoints)
        
        GeometryReader { topGeo in
            
            let textSize = topGeo.size.height * 0.05
            
            HStack {
                ZStack(alignment: .bottomLeading) {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: CGFloat(("\(extremum.y)".count - 1 ) * 15))
                    ForEach(Int(extremum.x)...Int(extremum.y / 10), id: \.self) { index in
                        ShadowFont("\(index * 10)", with: defaultFont, in: textSize)
                            .offset(x: 0, y: -((CGFloat(index) * 10) / extremum.y) * (topGeo.size.height - 140) - 140)
                            .background(Rectangle()
                                            .frame(width: 1000, height: 1)
                                            .offset(x: 0, y: -((CGFloat(index) * 10) / extremum.y) * (topGeo.size.height - 140) - 140))
                            
                    }
                }
                ScrollView(.horizontal) {
                    
                    HStack {
                        ForEach(combinedDataPoints.indices, id: \.self) { index in
                            
                            let label = combinedDataPoints[index].date.localizeDescription(with: unit)
                            let diagonalLength = CGFloat((label.count - 3) * 15)
                            let height =  sqrt( (pow(diagonalLength, 2) / 2) )
                            
                            Spacer()
                            VStack {
                                Bar(width: topGeo.size.width / CGFloat(combinedDataPoints.count + 1), value: combinedDataPoints[index].value, extrumumValues: extremum)
                                ZStack {
                                    
                                    Text( combinedDataPoints[index].date.localizeDescription(with: unit))
                                        .font(Font.custom(defaultFont.font, fixedSize: 15))
                                        .rotationEffect(Angle(degrees:  45), anchor: UnitPoint(x: 0, y: 1))
                                        .offset(x: diagonalLength / 2, y: -height * 0.5)
                                        .lineLimit(1)
                                        .frame(minWidth: 1000, minHeight: 1000)
                                        .foregroundColor(.blue)
                                        
                                    
                                }.frame(width: 15, height: height)
                            Spacer()
                            }
                        }
                        Rectangle()
                            .frame(width: 100)
                            .foregroundColor(.clear)
                    }.frame(width: max( topGeo.size.width, topGeo.size.width + CGFloat(((combinedDataPoints.count  - 10) * 15))  ))
                }
            }
        }
    }
    
    struct Bar: View {
        
        let width: CGFloat
        let value: CGFloat
        
        let extrumumValues: CGPoint
        
        var height: CGFloat {
            if extrumumValues.y - extrumumValues.x == 0 { return 1 }
            return (value - extrumumValues.x) / (extrumumValues.y - extrumumValues.x)
        }
        
        var body: some View {
            GeometryReader { geo in
                VStack {
                    Spacer()
                    Rectangle()
                        .frame(height: geo.size.height * height)
                }.onTapGesture {
                    print(extrumumValues)
                }
            }
        }
    }
}








extension Date {
    static let calendar = Calendar.current
    static let formatter = DateFormatter()
    
    func getInt( for component: Calendar.Component ) -> Int {
        return Date.calendar.dateComponents([component], from: self).value(for: component)!
    }
    
    func textualize(with name: String) -> String {
        Date.formatter.dateFormat = name
        return Date.formatter.string(from: self)
    }
    
    func localizeDescription( with description: Calendar.Component ) -> String {
        switch description {
        
        case .year: return textualize(with: "YYYY")
        case .month: return textualize(with: "MMMM") + " " + textualize(with: "YYYY")
        default:
            var day = textualize(with: "E")
            let month = textualize(with: "MMMM")
            day += ", \(month) \(self.getInt(for: .day) )"
            return day
        }
    }
    
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSheet()
    }
}

