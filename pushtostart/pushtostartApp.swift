import SwiftUI
import OneSignalFramework
import OneSignalLiveActivities
import OneSignalOutcomes
import OneSignalInAppMessages
import Mixpanel

@main
struct pushtostartApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var urlVM = URLViewModel()

    
    
    init(){
        appDelegate.urlViewModel = urlVM
    }
    

    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(urlVM)
     }
    }
}


class AppDelegate: UIResponder, UIApplicationDelegate, OSNotificationClickListener{
    var urlViewModel: URLViewModel?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        
        Mixpanel.initialize(token: "", trackAutomaticEvents: false)
        Mixpanel.mainInstance().track(event: "Signed Up", properties: [
            "Signup Type": "Referral",
        ])
        Mixpanel.mainInstance().identify(distinctId: "dominick@onesignal.com");
        // Sets user's "Plan" attribute to "Premium"
        Mixpanel.mainInstance().people.set(properties: [ "plan":"Premium", "$email":"dominick@onesignal.com", "User ID":"dom12345"])
        
        
        OneSignal.InAppMessages.addTrigger("test",withValue: "test")
        // Remove this method to stop OneSignal Debugging
        OneSignal.Debug.setLogLevel(.LL_VERBOSE)
        
        // OneSignal initialization
        OneSignal.initialize("c78671ca-6d42-4d5b-98c1-f0775e95d0f4", withLaunchOptions: launchOptions)
        
        
        // We recommend removing the following code and instead using an In-App Message to prompt for notification permission
        OneSignal.Notifications.requestPermission({ accepted in
            print("User accepted notifications: \(accepted)")
        }, fallbackToSettings: true)
        
        // Login your customer with externalId
        OneSignal.login("dom12345")
        
        OneSignal.LiveActivities.setup(ptsAttributes.self)
        OneSignal.Notifications.addClickListener(self)

        
        return true
    }

        func onClick(event: OSNotificationClickEvent) {
            print("click event called")
            urlViewModel?.handleURL(URL(string: event.notification.launchURL!)!)
        }

}
