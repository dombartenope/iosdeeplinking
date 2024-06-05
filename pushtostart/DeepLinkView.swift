//
//  DeepLinkView.swift
//  pushtostart
//
//  Created by dominick bartenope on 5/2/24.
//

import SwiftUI

struct DeepLinkView: View {
    var deepLinkID: String?
    
    var body: some View {
        Text("Deep Link View for ID: \(deepLinkID ?? "Unknown")")
    }
}
