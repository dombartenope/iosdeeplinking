import SwiftUI
import ActivityKit
import OneSignalFramework
import OneSignalLiveActivities
import OneSignalOutcomes
import OneSignalInAppMessages
import Mixpanel
import Foundation

import CallKit
import PushKit

import UserNotifications

/* OFFLINE LOGGING IMPORTS */
//This enables the below "LOGGING" code blocks to log to the device console (offline)
import Darwin
import os.log
/* END OFFLINE LOGGING IMPORTS */

@main
struct pushtostartApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var urlViewModel = URLViewModel()
    @StateObject private var liveActivityViewModel = LiveActivityViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: liveActivityViewModel, urlVM: urlViewModel)
                .onAppear {
                    appDelegate.setURLViewModel(urlViewModel) // Pass the instance to AppDelegate
                }
        }
    }
}

/* LOGGING EXTENSION */
//Enable this to log to the device console (offline)
// extension OSLog {
//     private static var subsystem = Bundle.main.bundleIdentifier!
//     static let test = OSLog(subsystem: subsystem, category: "Test")
// }
/* END LOGGING EXTENSION */

class AppDelegate: UIResponder, UIApplicationDelegate, OSNotificationClickListener, OSInAppMessageClickListener, PKPushRegistryDelegate{
    
    /* VOIP LOGIC */
    let callController = CXCallController()
    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
        print("==================== VOIP ====================")
        let tokenData = pushCredentials.token
        let tokenString = tokenData.map { String(format: "%02x", $0) }.joined()
        print("VoIP Push Token: \(tokenString)")
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType) {
        print("==================== VOIP RECEIVED ====================")
    }
    /* END VOIP LOGIC */

    
    private var urlVM: URLViewModel?
    
    func setURLViewModel(_ urlViewModel: URLViewModel) {
        self.urlVM = urlViewModel
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        /* LOGGING REDIRECT */
        //Enable this to log to the device console (offline)
        // if true /*isatty(STDERR_FILENO) != 1*/ { // if no terminal is attached to stderr
        //            let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        //            let logfileUrl = documentsUrl.appendingPathComponent("out.log")
        //            logfileUrl.withUnsafeFileSystemRepresentation { path in
        //                guard let path = path else {
        //                    return
        //                }
        //                print("redirect stderr and stderr to: \(String(cString: path))")
        //                let file = fopen(path, "a")
        //                assert(file != nil, String(cString: strerror(errno)))
        //                let fd = fileno(file)
        //                assert(fd >= 0, String(cString: strerror(errno)))
        //                let result1 = dup2(fd, STDERR_FILENO)
        //                assert(result1 >= 0, String(cString: strerror(errno)))
        //                let result2 = dup2(fd, STDOUT_FILENO)
        //                assert(result2 >= 0, String(cString: strerror(errno)))

        //                os_log("***** os_log: Test", log: OSLog.test, type: .debug)
        //                print("***** print:Test")
        //                NSLog("***** NSLog: Test")
        //            }
        //        }
        /* END LOGGING REDIRECT */

        /* LOGGING CALL */
        //Enable this to log to the device console (offline)
        // os_log("os_log: Test", log: OSLog.test, type: .debug)
        // print("print: Test")
        // NSLog("NSLog: Test")
        /* END LOGGING CALL */

        
        /* VOIP LOGIC */
        
        let voipRegistry = PKPushRegistry(queue: DispatchQueue.main)
        voipRegistry.delegate = self
        voipRegistry.desiredPushTypes = [.voIP]

        /* END VOIP LOGIC*/
        
        /* MIXPANEL INTEGRATION -- DISABLED FOR PURPOSE OF DEMO
            Mixpanel.initialize(token: ConfigManager.mixpanelToken, trackAutomaticEvents: false)
            Mixpanel.mainInstance().track(event: "Signed Up", properties: [
                "Signup Type": "Referral",
            ])
            Mixpanel.mainInstance().identify(distinctId: "dominick@onesignal.com");
            Mixpanel.mainInstance().people.set(properties: [ "plan":"Premium", "$email":"dominick@onesignal.com", "User ID":"dom12345"])
        */
        
        //SDK SET UP
        OneSignal.Debug.setLogLevel(.LL_VERBOSE)
        OneSignal.initialize("c78671ca-6d42-4d5b-98c1-f0775e95d0f4", withLaunchOptions: launchOptions)
        
        //NOTIFICATION PERMISSION AND LOGIC
        OneSignal.Notifications.requestPermission({ accepted in
            print("OneSignalAppCode \(accepted)")
        }, fallbackToSettings: false)
        
        OneSignal.Notifications.addClickListener(self)
        
        //USER LOGIC
        OneSignal.login("eid_test")
        
        /* LIVE ACTIVITY */
        // PUSH TO START LISTENER
        OneSignal.LiveActivities.setup(ptsAttributes.self)
        OneSignal.LiveActivities.setup(RideShareAttributes.self)
        
        // MANUAL LIVE ACTIVITY TOKEN GENERATION METHOD
//        if #available(iOS 17.2, *) {
//          // Setup an async task to monitor and send pushToStartToken updates to OneSignalSDK.
//          Task {
//              for try await data in Activity<GameWidgetAttributes>.pushToStartTokenUpdates {
//                  let token = data.map {String(format: "%02x", $0)}.joined()
//                  OneSignal.LiveActivities.setPushToStartToken(GameWidgetAttributes.self, withToken: token)
//              }
//          }
//          // Setup an async task to monitor for an activity to be started, for each started activity we
//          // can then set up an async task to monitor and send updateToken updates to OneSignalSDK. If
//          // there can be multiple instances of this activity-type, the activity-id (i.e. "my-activity-id") is
//          // most likely passed down as an attribute within MyWidgetAttributes.
//          Task {
//              for await activity in Activity<GameWidgetAttributes>.activityUpdates {
//                Task {
//                    for await pushToken in activity.pushTokenUpdates {
//                        let token = pushToken.map {String(format: "%02x", $0)}.joined()
//                        OneSignal.LiveActivities.enter("my-activity-id", withToken: token)
//                    }
//                }
//              }
//          }
//        }
        /* END LIVE ACTIVITY */

        
        //IAM LOGIC
        OneSignal.InAppMessages.addTrigger("test", withValue: "test")
        OneSignal.InAppMessages.addClickListener(self)
        

        return true
    }
    
    func onClick(event: OSInAppMessageClickEvent){
        let actionId = event.result.actionId
        if actionId == "customscheme://test" {
            self.urlVM?.handleURL(actionId!)
        }
    }
    
    func onClick(event: OSNotificationClickEvent) {
      
        if let launchURL = event.notification.launchURL {
            DispatchQueue.main.async {
                self.urlVM?.handleURL(launchURL) // Use the shared instance
                print(launchURL)
            }
        }
        
//        let rawOSPayload: String? = event.notification.rawPayload
        
        guard let iOSAttachments = event.notification.rawPayload as NSDictionary? as? [String: Any] else {return}
        print(iOSAttachments)
        
        if let customScheme = event.notification.additionalData {
            if let stringValue = customScheme["url"] as? String {
                self.urlVM?.handleURL(stringValue) // Use the shared instance
            } else {
                print("The value is invalid")
            }
        }
        
    }
}

