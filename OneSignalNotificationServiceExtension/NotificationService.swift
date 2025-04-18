import UserNotifications
import OneSignalExtension

class NotificationService: UNNotificationServiceExtension {
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
        
    override func didReceive( _ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        if let bestAttemptContent = bestAttemptContent {
            // Deliver the original notification content
            contentHandler(bestAttemptContent)
            
            
            
           

/* UNCOMMENT TO DUPLICATE MESSAGES USING ADDITIONAL DATA
             
             // Modify the notification content
            let userInfo = bestAttemptContent.userInfo
            let mutableUserInfo = userInfo

            let modifiedContent = UNMutableNotificationContent()
            if let dict = request.content.userInfo as? [String: Any],
               let custom = dict["custom"] as? [String: Any] {
                print("Running NSE: custom = \(custom)")
                if let a = custom["a"] as? [String: Any],
                       let title = a["title"] as? String,
                       let body = a["body"] as? String {
                    modifiedContent.title = title
                    modifiedContent.body = body
                }
            }
            modifiedContent.userInfo = mutableUserInfo
            
            // Log to verify modification
            print("Modified notification payload: \(mutableUserInfo)")
            
            // Call OneSignal to handle additional processing if needed
            OneSignalExtension.didReceiveNotificationExtensionRequest(request, with: modifiedContent)
            
            
            // Create a new notification request with a unique identifier
            let modifiedRequest = UNNotificationRequest(identifier: UUID().uuidString, content: modifiedContent, trigger: request.trigger)
            
             Schedule the modified notification
            UNUserNotificationCenter.current().add(modifiedRequest, withCompletionHandler: { error in
                if let error = error {
                    print("Error scheduling modified notification: \(error)")
                }
            })
*/
        }
    }

    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent = bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
}
