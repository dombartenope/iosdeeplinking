//
//  AppIntent.swift
//  pts
//
//  Created by dominick bartenope on 4/29/24.
//

import WidgetKit
import AppIntents
import OneSignalFramework

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("This is an example widget.")

    // An example configurable parameter.
    @Parameter(title: "Favorite Emoji", default: "😃")
    var favoriteEmoji: String
}

