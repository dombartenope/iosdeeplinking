//
//  ptsLiveActivity.swift
//  pts
//
//  Created by dominick bartenope on 4/29/24.
//

import ActivityKit
import WidgetKit
import SwiftUI
import OneSignalLiveActivities

/* Using Push To Start */
struct ptsAttributes: OneSignalLiveActivityAttributes {
    public struct ContentState: OneSignalLiveActivityContentState{
        
        // Dynamic stateful properties about your activity go here!
        var emoji: String
        var onesignal: OneSignalLiveActivityContentStateData?
    }
    // Fixed non-changing properties about your activity go here!
    var name: String
    var onesignal: OneSignalLiveActivityAttributeData
}


struct ptsLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ptsAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("\(context.attributes.name) \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

/* Manual Button Click Launch */
struct CountDownAttributes: OneSignalLiveActivityAttributes {
    public struct ContentState: OneSignalLiveActivityContentState{
        var dynamicData: String
        public var onesignal: OneSignalLiveActivityContentStateData?
    }
    var staticData: String
    var timer: ClosedRange<Date>
    var onesignal: OneSignalLiveActivityAttributeData
}

struct CountDownActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: CountDownAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("\(context.attributes.staticData) \(context.state.dynamicData)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)
            Text(timerInterval: context.attributes.timer, countsDown: true)
                .multilineTextAlignment(.center)
                .frame(width: 40)
                .font(.caption2).foregroundColor(.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.dynamicData)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.dynamicData)")
            } minimal: {
                Text(context.state.dynamicData)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}
