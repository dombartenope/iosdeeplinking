# Deep Linking
## Universal Links
The Deeplink must be hosted on web server and follow the guidance in the [documentation here]("https://documentation.onesignal.com/docs/deep-linking") if you want to change this to match your own.
This is the deeplink that is currently set up to be used in this project: https://slash-magic-cloak.glitch.me

## How to Use
1. Clone this repository and build the project
2. Open https://slash-magic-cloak.glitch.me to initialize the url if you want to try to open the browser from the deeplink
- You don't need to do this if you plan on leaving the default click handler in place to intercept the link and handle the deep link within the app
3. Change the App ID to match your own OneSignal app
4. Send a notification with a launch URL that contains that exact link if using the default event handler, or change the link and logic in the app to match your own
5. Note the behavior and use this as a reference for your own project


# Push To Start Live Activities
## Struct
This uses the default struct provided by the widget when you add that target on XCode. The changes made to the default layout are as follows:
1. [Struct]("https://documentation.onesignal.com/docs/push-to-start-live-activities#3-define-the-static-and-dynamic-data-of-your-live-activity") found in [ptsLiveActivity.swift]("https://github.com/dombartenope/iosdeeplinking/blob/main/pts/ptsLiveActivity.swift")
2. [Push To Start method]("https://documentation.onesignal.com/docs/push-to-start-live-activities#5-invoke-the-setup-in-the-appdelegate") found in [pushtostartApp.swift]("https://github.com/dombartenope/iosdeeplinking/blob/main/pushtostart/pushtostartApp.swift")

## API Request (push to start)
```
curl --request POST \
--url "https://onesignal.com/api/v1/apps/APP_ID/activities/activity/ptsAttributes" \
--header "Authorization: Basic API_KEY" \
--header "accept: application/json" \
--header "content-type: application/json" \
--data '{
  "included_segments": ["Subscribed Users"],
  "activity_id": "my-example-activity-id",
  "event_attributes": {
    "name": "testing123"
  },
  "event_updates": {
    "emoji": "😃"
  },
  "name": "hello world",
  "headings": {
    "en": "English Message"
  },
  "contents": {
      "en":"English Message"
  }
}'
```
