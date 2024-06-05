import SwiftUI
import WebKit
import ActivityKit
import OneSignalFramework
import OneSignalLiveActivities

struct ContentView: View {
//    @StateObject private var laViewModel = LiveActivityViewModel()
    @EnvironmentObject private var urlVM: URLViewModel
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
//                Button("Start Live Activity") {
//                    viewModel.startLiveActivity()
//                }
                Text(urlVM.url)
                    .padding()
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
    @Published var url: String = "No URL opened yet"
    
    func handleURL(_ url: URL?) {
        print("handling URL")
        guard let u = url else {
            print("Could not parse URL")
            return
        }
        print("Setting URL")
        self.url = u.absoluteString
    }
}

//class LiveActivityViewModel: ObservableObject {
//    func startLiveActivity() {
//        let osAttributes = OneSignalLiveActivityAttributeData.create(activityId: "my_activity_id")
//        let attributes = ptsAttributes(name: "Default", onesignal: osAttributes)
//        let contentState = ptsAttributes.ContentState(emoji:"😀", onesignal: nil)
//        
//        do {
//            _ = try Activity<ptsAttributes>.request(
//                attributes: attributes,
//                contentState: contentState,
//                pushType: .token)
//            
//            
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
    
