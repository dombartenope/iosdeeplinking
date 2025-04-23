//
//  ControlManager.swift
//  pushtostart
//
//  Created by dominick bartenope on 4/23/25.
//

import Foundation

class ControlManager{
    static let shared = ControlManager()
    var isRunning = false
    
    
    func sendOneSignalNotification() {
        let url = URL(string: "https://api.onesignal.com/notifications")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Key \(Bundle.main.infoDictionary?["API_KEY"] as? String ?? "")", forHTTPHeaderField: "Authorization")
        
        let payload: [String: Any] = [
            "app_id": "c78671ca-6d42-4d5b-98c1-f0775e95d0f4",
            "included_segments": ["All"],
            "headings": ["en": "ControlCenter"],
            "contents": ["en": "Sent from ControlCenter"]
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload)
        } catch {
            print("Error creating request body: \(error)")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error sending notification: \(error)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Response status code: \(httpResponse.statusCode)")
            }
        }
        task.resume()
    }
}
