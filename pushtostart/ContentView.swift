import SwiftUI
import Combine
import WebKit
import ActivityKit
import OneSignalFramework
import OneSignalLiveActivities

struct ContentView: View {
    @ObservedObject var viewModel: LiveActivityViewModel
    @ObservedObject var urlVM: URLViewModel
    @State private var navigateToSecondScreen = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                Button("Launch Live Activity") {
                    viewModel.startLiveActivity()
                }
                Button("Nav to 2nd Screen") {
                    urlVM.handleURL("https://slash-magic-cloak.glitch.me")
                }
                Text(urlVM.url)
                    .padding()
                NavigationLink(destination: MySecondScreen(), isActive: $navigateToSecondScreen) {
                    EmptyView() // This creates a hidden link
                }
            }.onChange(of: urlVM.url) { newValue in
                if newValue == "https://slash-magic-cloak.glitch.me" {
                    navigateToSecondScreen = true // Trigger navigation when URL is updated
                }
            }
        }
    }
}

struct MySecondScreen: View {
    var body: some View {
        Text("Opened from deeplink")
    }
}

class URLViewModel: ObservableObject {
    @Published var url: String
    
    init() {
        url = "No URL found yet"
    }
    
    func handleURL(_ url: String) {
        print("handling URL")
        self.url = url
    }
}

class LiveActivityViewModel: ObservableObject {
    func startLiveActivity() {
        let osAttributes = OneSignalLiveActivityAttributeData.create(activityId: "my_activity_id")
        let attributes = ptsAttributes(name: "Default", onesignal: osAttributes)
        let contentState = ptsAttributes.ContentState(emoji:"😀", onesignal: nil)
        
        do {
            _ = try Activity<ptsAttributes>.request(
                attributes: attributes,
                contentState: contentState,
                pushType: .token)
            
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
