//
//  ptsLiveActivity.swift
//  pts
//
//  Created by dominick bartenope on 4/29/24.
//

import ActivityKit
import WidgetKit
import SwiftUI
import AppIntents
import OneSignalFramework
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
                    .activityBackgroundTint(Color.cyan)
                    .activitySystemActionForegroundColor(Color.black)
            }
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

struct RideShareAttributes: OneSignalLiveActivityAttributes {
    public struct ContentState: OneSignalLiveActivityContentState{
        
        // Dynamic stateful properties about your activity go here!
        var progress: Double = 0
        var onesignal: OneSignalLiveActivityContentStateData?
    }
    // Fixed non-changing properties about your activity go here!
    var driverName: String
    var arrivalTime: String
    var onesignal: OneSignalLiveActivityAttributeData
}

struct RideShareActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: RideShareAttributes.self) { context in
            // Lock screen / Banner UI
            VStack(alignment: .leading) {
                // Header: Logo and ETA
                HStack {
                    Text("drivr 🚐") // Simple text logo
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                    Text("ETA \(context.attributes.arrivalTime)")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(.top, 10)
                
                Spacer() // Push title down slightly
                
                // Main Title
                Text("Your driver \(context.attributes.driverName) is on the way!")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.bottom, 15) // Add space before progress bar
                
                // Modern Progress Bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        // Background track
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 8)
                        
                        // Progress indicator
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [.blue, .cyan]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * context.state.progress, height: 8)
                        
                        // Car indicator
                        Image(systemName: "car.fill")
                            .foregroundColor(.white)
                            .offset(x: (geometry.size.width - 20) * context.state.progress)
                            .font(.system(size: 16))
                    }
                }
                .frame(height: 20)
                .padding(.horizontal)

                // Location markers
                HStack {
                    Text("🏢")
                    Spacer()
                    Text("🏠")
                    Spacer()
                    Text("✈️")
                }
                .font(.title3)
                .padding(.horizontal)
                .padding(.bottom, 3)

            }
            .padding(.horizontal)
            .activityBackgroundTint(Color.black) // Dark background like the image
            .activitySystemActionForegroundColor(Color.white) // Make system elements white
            
        } dynamicIsland: { context in
            // Calculate car position and display simplified progress for Dynamic Island
            let progressIndicator: String = {
                switch context.state.progress {
                case ..<0.25: return "🏢.."
                case 0.25..<0.5: return "🚗..🏠"
                case 0.5..<0.75: return "🏠..✈️"
                default: return "✈️ Arrived"
                }
            }()
            
            return DynamicIsland {
                // Expanded UI
                DynamicIslandExpandedRegion(.leading) {
                    Text("Driver")
                        .font(.caption)
                    Text(context.attributes.driverName)
                        .font(.headline)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("ETA")
                        .font(.caption)
                    Text(context.attributes.arrivalTime)
                        .font(.headline)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    // Using the calculated progressIndicator
                    Text(progressIndicator)
                        .font(.caption)
                    
                }
            } compactLeading: {
                // Compact Leading: Show Car
                Text("🚗")
            } compactTrailing: {
                // Compact Trailing: Show ETA
                Text(context.attributes.arrivalTime)
                    .font(.caption)
            } minimal: {
                // Minimal: Show Car
                Text("🚗")
            }
            .keylineTint(Color.blue) // Match progress bar color
        }
    }
}

