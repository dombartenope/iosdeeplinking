//
//  ControlCenterWidgetControl.swift
//  ControlCenterWidget
//
//  Created by dominick bartenope on 4/23/25.
//

import AppIntents
import SwiftUI
import WidgetKit

struct ControlCenterWidgetControl: ControlWidget {
    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(
            kind: "com.dom.support.ControlCenterWidget"
        ){
            ControlWidgetButton(action: SendNotificationIntent()) {
                Text("Send Notification")
                Image(systemName: "bell.fill")
                    .tint(.blue)
            }
        }
        .displayName("Push Notification")
        .description("Send a push notification")
    }
}

struct SendNotificationIntent : AppIntent {
    static var title: LocalizedStringResource = "Send Notification"
    
    init(){}
    
    func perform() async throws -> some IntentResult {
        ControlManager.shared.sendOneSignalNotification()
        return .result()
    }
}
