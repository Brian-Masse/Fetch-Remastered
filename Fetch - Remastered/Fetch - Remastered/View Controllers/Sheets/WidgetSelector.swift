//
//  WidgetSelector.swift
//  Fetch - Remastered
//
//  Created by Brian Masse on 8/30/21.
//  Copyright © 2021 Brian Masse. All rights reserved.
//

import Foundation
import WidgetKit
import SwiftUI

struct widgetSelector: View {
    let title: String
    @Binding var size: WidgetFamily
    @Binding var currentWidget: Int
    @EnvironmentObject var game: FetchClassicInterpreter
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading) {
                
                WidgetBuilder.createWidgetBuilderText(title, with: titleFont, in: geo.size.width * 0.1, lineLimit: 2)
                    .fixedSize()
                    .padding()
                
                HStack {
                    Spacer()
                    DesignedButton( accent: WidgetBuilder.returnColor(), design: { WidgetBuilder.createWidgetBuilderText("Create New Widget", with: titleFont, in: 20) }) {
                        game.addWidget(in: size, for: WidgetBuilder.returnActiveListOfWidgets(in: size).count + 1)
                        currentWidget = WidgetBuilder.returnActiveListOfWidgets(in: size).count - 1
                    }
                    Spacer()
                }
            
                ScrollView(.vertical) {
                    ForEach(WidgetBuilder.returnActiveListOfWidgets(in: size).indices, id: \.self) { index in
                        if index != 0 {
                            IndividualWidgetSelector(geo: geo, title: title, size: $size, currentWidget: $currentWidget, index: index)
                        }
                    }
                }
            }
        }
        .background(PixelImage( appearanced("WidgetBuilderBack")).ignoresSafeArea().aspectRatio(contentMode: .fill))
    }
    
    struct IndividualWidgetSelector: View {
        let geo: GeometryProxy
        let title: String
        @Binding var size: WidgetFamily
        @Binding var currentWidget: Int
        let index: Int
        
        @EnvironmentObject var game: FetchClassicInterpreter
        
        @State var showingDelete = false
        @State var showingDeleteAlert = false
        
        @State var dud: WidgetData.DataPosition = .topLeft
        
        var body: some View {
            ZStack(alignment: .leading) {
                HStack {
                    Spacer()
                    WidgetBuilder.createWidgetBuilderText(title+" \(index)", with: titleFont, in: geo.size.width * 0.05, lineLimit: 2)
                        .multilineTextAlignment(.trailing)
                        .minimumScaleFactor(0.5)
                    
                    WidgetBuilder.WidgetPreview(width: geo.size.width * (1/3) / WidgetBuilder.returnAspectRatioBasedOnSize(in: size), currentSize: size, activeWidgetData: WidgetBuilder.returnActiveListOfWidgets(in: size)[min(index,WidgetBuilder.returnActiveListOfWidgets(in: size).count - 1 )], activeDataPosition: $dud)
                        .frame(maxWidth: geo.size.width * 1/3)
                    Spacer()
                }
                    Rectangle()
                        .frame(maxWidth: geo.size.width * 1/4)
                        .foregroundColor(Color(UIColor(red: 1, green: 63 / 255, blue: 63 / 255, alpha: 1)))
                        .cornerRadius(6)
                        .onTapGesture { showingDeleteAlert = true }
                        .overlay(ShadowFont("Delete \nWidget", with: titleFont, in: 20, shadowColor: Colors.builderDarkRed, lineLimit: 2).padding().minimumScaleFactor(0.5)).foregroundColor(.white)
                        .offset(x: geo.size.width, y: 0)
                
                }.alert(isPresented: $showingDeleteAlert) {
                    Alert(title: Text("Delete Widget"),
                          message: Text("This will delete the current widget, erasing all its customization. This action cannot be undone."),
                          primaryButton: .destructive(Text("delete")) { withAnimation {
                            if WidgetBuilder.returnActiveListOfWidgets(in: size).count > 1 {
                                game.deleteWidget(in: size, for: index)
                                currentWidget = max( currentWidget - 1, 0)
                                showingDelete = false }
                          } }, secondaryButton: .cancel())
            }
            .onTapGesture { currentWidget = index }
            .offset(x: showingDelete ? -geo.size.width * 1/4: 0)
            .background( Rectangle().foregroundColor( index.isMultiple(of: 2) ?  Color(UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)): .clear) )
            .modifier(framify( .white, in: geo.size.width, padded: false))
            .overlay(Rectangle().foregroundColor(.clear).modifier(framify( .white, in: geo.size.width, padded: false, changeForegroundColor: false)).opacity(currentWidget == index ? 1:0 ) )
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local).onEnded { dragGestureValue in
                if dragGestureValue.translation.width < 0 { withAnimation { showingDelete = true } }
                if dragGestureValue.translation.width > 0 { withAnimation { showingDelete = false } }
            })
        }
    }
}
