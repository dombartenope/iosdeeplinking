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
                    OneSignal.User.addTag(key:"live_activity", value:"true")
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
    
    init() {
        OneSignal.LiveActivities.setup(ptsAttributes.self)
    }
    
    var active: Bool = false
    
    func startLiveActivity() {
        let osAttributes = OneSignalLiveActivityAttributeData.create(activityId: "my_activity_id")
        let attributes = ptsAttributes(name: "Default", onesignal: osAttributes)
        let contentState = ptsAttributes.ContentState(emoji:"😀", onesignal: nil)
        
        do {
            let activity = try Activity<ptsAttributes>.request(
                attributes: attributes,
                contentState: contentState,
                pushType: .token)
            
            //Listen for early exit
            Task {
                for await state in activity.activityStateUpdates {
                    print("LA state update: \(state)")
                    if state != ActivityState.active {
                        OneSignal.User.removeTag("live_activity")
                    }
                }
                
                
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
}
