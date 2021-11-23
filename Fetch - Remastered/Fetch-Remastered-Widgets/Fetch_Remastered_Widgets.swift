//
//  Fetch_Remastered_Widgets.swift
//  Fetch-Remastered-Widgets
//
//  Created by Brian Masse on 8/24/21.
//  Copyright © 2021 Brian Masse. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider<configType: INIntent>: IntentTimelineProvider where configType: WidgetSelector{

    let configuration: configType
    let accessor: WidgetAcessor.WidgetListsAccessor
    
    
    init( _ configuration: configType, for accessor: WidgetAcessor.WidgetListsAccessor) {
        self.configuration = configuration
        self.accessor = accessor
    }

    //This is what the user sees when they are in the selection menu
    func placeholder(in context: Context) -> SmallEntry {
        SmallEntry(date: Date(), widgetData: widgetAcessor[accessor][min(configuration.index, widgetAcessor[accessor].count - 1)])
    }

    //This should create a quick version of your widget
    func getSnapshot(for configuration: configType, in context: Context, completion: @escaping (SmallEntry) -> ()) {
        let entry = SmallEntry(date: Date(), widgetData: widgetAcessor[accessor][min(configuration.index, widgetAcessor[accessor].count - 1)])
        completion(entry)
    }

    // bulk of the widget handling
    func getTimeline(for configuration: configType, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        var entries: [SmallEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        widgetAcessor.inquiryWidgets()
        
        var entry = SmallEntry(date: Date(), widgetData: widgetAcessor[accessor][ min(configuration.index, widgetAcessor[accessor].count - 1)])
        entry.widgetData.inquiryData()
        entries.append(entry)

        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
}


struct SmallEntry: TimelineEntry {
    let date: Date
    var widgetData: WidgetData
}

@main
struct FetchClassicWidgets: WidgetBundle {
    var body: some Widget {
        FetchClassicWidget( SmallWidgetConfigurationIntent(), ofKind: "FetchClassicSmallWidget", name: "Fetch-Remastered Small Widget", description: "Choose and display any of your customized small widgets!", supportedFamilies: [.systemSmall], accessor: .smallList )
        FetchClassicWidget( MediumWidgetConfigurationIntent(), ofKind: "FetchClassicMediumWidget", name: "Fetch-Remastered Medium Widget", description: "Choose and display any of your customized medium widgets!", supportedFamilies: [.systemMedium], accessor: .mediumList)
        FetchClassicWidget( LargeWidgetConfigurationIntent(), ofKind: "FetchClassicLargeWidget", name: "Fetch-Remastered Large Widget", description: "Choose and display any of your customized large widgets!", supportedFamilies: [.systemLarge], accessor: .largeList)
    }
    
}

struct FetchClassicWidget<configType: INIntent>: Widget where configType: WidgetSelector{
    
    var kind: String = "FetchClassicSmallWidget"
    let widgetAcessor = WidgetAcessor()
    let configuration: configType
    
    var displayName: String = "Fetch-Remastered Widget"
    var displayDescription: String = "Choose and display any of your customized widgets!"
    var supportedFamilies: [WidgetFamily] = []
    var accessor: WidgetAcessor.WidgetListsAccessor = .smallList
    
    
    init() {
        self.configuration = SmallWidgetConfigurationIntent() as! configType
    }
    init(_ config: configType, ofKind kind: String, name: String, description: String, supportedFamilies: [WidgetFamily], accessor: WidgetAcessor.WidgetListsAccessor ) {
        self.configuration = config
        self.kind = kind
        self.displayName = name
        self.displayDescription = description
        self.supportedFamilies = supportedFamilies
        self.accessor = accessor
    }
    
    @State var dud: WidgetData.DataPosition = .topLeft
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: configType.self, provider: Provider(configuration, for: accessor)) { entry in
            WidgetView(inBuildingMode: false, data: entry.widgetData, size: supportedFamilies.first!, activeDataPosition: $dud)
        }
        .configurationDisplayName(displayName)
        .description(displayDescription)
        .supportedFamilies(supportedFamilies)
    }
}

//struct Fetch_Remastered_Widgets_Previews: PreviewProvider {
//    static var previews: some View {
////        Fetch_Remastered_WidgetsEntryView(entry: SmallEntry(date: Date(), widgetData: WidgetData(text: "simulator")))
////            .previewContext(WidgetPreviewContext(family: .systemSmall))
//    }
//}

protocol WidgetSelector {
    var index: Int { get }
}

extension SmallWidgetConfigurationIntent: WidgetSelector {
    
    var index: Int {
        guard let identifier = self.SmallWidget?.identifier else { return 0 }
        guard let index =  Int( identifier ) else { return 0 }
        return index
    }
}

extension MediumWidgetConfigurationIntent: WidgetSelector {
    
    var index: Int {
        guard let identifier = self.MediumWidget?.identifier else { return 0 }
        guard let index =  Int( identifier ) else { return 0 }
        return index
    }
}


extension LargeWidgetConfigurationIntent: WidgetSelector {
    
    var index: Int {
        guard let identifier = self.parameter?.identifier else { return 0 }
        guard let index =  Int( identifier ) else { return 0 }
        return index
    }
}
