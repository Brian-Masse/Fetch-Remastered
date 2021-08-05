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
            Text("click here to add to a data point to the graph")
                .onTapGesture {
                    GameView.game.temp()
                }
        }
    }
    
    
}


struct Grapher: View {
    
    let graphableData: [GraphablePoint]
    
    static func canCombine(_ firstPoint: GraphablePoint, and secondPoint: GraphablePoint, for scaling: Spacing) -> Bool {
        
        if firstPoint.date.getYearInt() == secondPoint.date.getYearInt() {
            if scaling == .year { return true }
            else if firstPoint.date.getMonthInt() == secondPoint.date.getMonthInt(){
                if scaling == .month { return true }
                else if firstPoint.date.getDayInt() == secondPoint.date.getDayInt() {
                    return true
                }else { return false}
            }else { return false }
        }else { return false }
        
    }
    
    func createListOfDataPoints(_ startingIndex: Int, in fullList: [GraphablePoint]) -> [GraphablePoint] {

        var returningList: [GraphablePoint] = []
        if startingIndex == fullList.count - 1 { return [fullList.last!] }
        
        for index in startingIndex + 1...fullList.count - 1 {
            
            if !Grapher.canCombine(fullList[index], and: fullList[index - 1], for: scalingSize) {
                returningList.append( fullList[index] )
                returningList += createListOfDataPoints(index, in: fullList)
                return returningList
            }else if fullList.count - 1 == index { return [fullList.last!] }
        }
        return returningList
    }
    
    enum Spacing {
        case day
        case month
        case year
    }
    
    @State var scalingSize: Spacing = .day
    
    var body: some View {
           
        let combinedDataPoints = createListOfDataPoints(0, in: graphableData)
        
        GeometryReader { topGeo in
            ScrollView(.horizontal) {
                HStack {
                    
                    
                    ForEach(combinedDataPoints.indices, id: \.self) { index in
                        Spacer()
                        Text("\(Int(combinedDataPoints[index].value))")
                        Spacer()
                    }
                }
            }.frame(width: min( topGeo.size.width, topGeo.size.width + CGFloat(((combinedDataPoints.count  - 30) * 10))  ))
        }
    }
    
}

extension Date {
    static let calendar = Calendar.current
    
    func getYearInt() -> Int {
        let components = Date.calendar.dateComponents([.year], from: self)
        return components.year!
        
    }
    
    func getMonthInt() -> Int {
        let components = Date.calendar.dateComponents([.month], from: self)
        return components.month!
        
    }
    
    func getDayInt() -> Int {
        let components = Date.calendar.dateComponents([.day], from: self)
        return components.day!
        
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
////        ProfileSheet()
//        Text("hello world")
//    }
//}

