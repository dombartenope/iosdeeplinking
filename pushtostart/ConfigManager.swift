//
//  ConfigManager.swift
//  pushtostart
//
//  Created by dominick bartenope on 8/28/24.
//

import Foundation

struct ConfigManager {
    static func getValue(for key: String) -> String? {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] else {
            return nil
        }
        return dict[key] as? String
    }
    
    static var mixpanelToken: String {
        return getValue(for: "MixpanelToken") ?? ""
    }
}
