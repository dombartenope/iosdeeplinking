//
//  SuperCharge.swift
//  pushtostart
//
//  Created by dominick bartenope on 4/8/25.
//


import AppIntents
import OneSignalFramework

struct SuperCharge: AppIntent {
    static var title: LocalizedStringResource = "Super Charge"

    // You can add parameters here if you need input from the user,
    // but a simple "no-parameters" intent is also perfectly fine.

    func perform() async throws -> some IntentResult {
        // This line is what you want to run when the button is tapped
        OneSignal.Session.addUniqueOutcome("Click")

        // Return a success result
        return .result()
    }
}
