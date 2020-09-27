//
//  BitCoinWidget.swift
//  BitCoinWidget
//
//  Created by Appnap WS01 on 24/9/20.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    
    @AppStorage("savedData", store: UserDefaults(suiteName: "group.com.Appnap.BitCoinUpdate"))
    var data: Data = Data()
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(cur: "USD", rate: 0.00)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(cur: "USD", rate: 0.00)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        DispatchQueue.main.async {
            guard let updatedData = try? JSONDecoder().decode(ExchangeInfo.self, from: data) else { return }
            
            let entries: SimpleEntry = SimpleEntry(cur: updatedData.asset_id_quote, rate: updatedData.rate)
            //print("Data \(updatedData.rate)")
            let timeline = Timeline(entries: [entries], policy: .atEnd)
            completion(timeline)
        }
        
        
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date = Date()
    let cur: String
    let rate: Double
}

struct BitCoinWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            Image("background_2").resizable()
            VStack {
                Image("1024").resizable()
                Text(String(format:"%.2f", entry.rate))
                    .bold()
                    .padding(.top, 10)
                Spacer()
                Text(entry.cur)
                    .bold()
                    .padding(.bottom, 20)
            }
        }
        
    }
}

@main
struct BitCoinWidget: Widget {
    let kind: String = "BitCoinWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            BitCoinWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall])
    }
}

struct BitCoinWidget_Previews: PreviewProvider {
    static var previews: some View {
        BitCoinWidgetEntryView(entry: SimpleEntry(cur: "USD", rate: 0.00))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
