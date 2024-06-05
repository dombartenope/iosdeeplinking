import SwiftUI
import OneSignalFramework
import OneSignalLiveActivities
import OneSignalOutcomes
import OneSignalInAppMessages
import Mixpanel

@main
struct pushtostartApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var urlViewModel = URLViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView(urlVM: urlViewModel)
                .onAppear {
                    appDelegate.setURLViewModel(urlViewModel) // Pass the instance to AppDelegate
                }
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate, OSNotificationClickListener {
    private var urlVM: URLViewModel?
    
    func setURLViewModel(_ urlViewModel: URLViewModel) {
        self.urlVM = urlViewModel
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        Mixpanel.initialize(token: "d810d40cdbc7dead2ff901838c696ccb", trackAutomaticEvents: false)
        Mixpanel.mainInstance().track(event: "Signed Up", properties: [
            "Signup Type": "Referral",
        ])
        Mixpanel.mainInstance().identify(distinctId: "dominick@onesignal.com");
        Mixpanel.mainInstance().people.set(properties: [ "plan":"Premium", "$email":"dominick@onesignal.com", "User ID":"dom12345"])
        
        OneSignal.InAppMessages.addTrigger("test", withValue: "test")
        OneSignal.Debug.setLogLevel(.LL_VERBOSE)
        OneSignal.initialize("c78671ca-6d42-4d5b-98c1-f0775e95d0f4", withLaunchOptions: launchOptions)
        
        OneSignal.Notifications.requestPermission({ accepted in
            print("User accepted notifications: \(accepted)")
        }, fallbackToSettings: true)
        
        OneSignal.login("dom12345")
        OneSignal.LiveActivities.setup(ptsAttributes.self)
        OneSignal.Notifications.addClickListener(self)
        
        return true
    }

    func onClick(event: OSNotificationClickEvent) {
        if let launchURL = event.notification.launchURL {
            DispatchQueue.main.async {
                self.urlVM?.handleURL(launchURL) // Use the shared instance
                print(launchURL)
            }
        }
    }
}
