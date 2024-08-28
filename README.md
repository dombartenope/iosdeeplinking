# Deep Linking
## Universal Links
The Deeplink must be hosted on web server and follow the guidance in the [documentation here]("https://documentation.onesignal.com/docs/deep-linking") if you want to change this to match your own.
- This is [the deeplink]("https://slash-magic-cloak.glitch.me") that is currently set up to be used in this project


# Push To Start Live Activities
## Struct
This uses the default struct provided by the widget when you add that target on XCode. The changes made to the default layout are as follows:
1. [Struct]("https://documentation.onesignal.com/docs/push-to-start-live-activities#3-define-the-static-and-dynamic-data-of-your-live-activity") found in [ptsLiveActivity.swift]("https://github.com/dombartenope/iosdeeplinking/blob/main/pts/ptsLiveActivity.swift")
2. [Push To Start method]("https://documentation.onesignal.com/docs/push-to-start-live-activities#5-invoke-the-setup-in-the-appdelegate") found in [pushtostartApp.swift]("https://github.com/dombartenope/iosdeeplinking/blob/main/pushtostart/pushtostartApp.swift")

## API Request (push to start)
```
curl --request POST \ 
--url "http://onesignal.com/api/v1/apps/APP_ID/activities/activity/ptsAttributes" \ 
--header "Authorization: Basic REST API KEY" \ 
--header "accept: application/json" \ 
--header "content-type: application/json" \ 
--data '{ 
  "included_segments: ["Subscribed Users"], 
  "activity_id": "my-example-activity-id", 
  "attributes": { 
    "name": "testing123" 
  }, 
  "event_updates": {
    "emoji": "😃" 
  }, 
  "name": "hello world" 
}'
```
