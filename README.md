# Blondie SDK

Get started on integrating the Blondie into your native iOS app through these guides:

## Installation

Install Blondie to perform automations right from your iOS app. The Blondie SDK for iOS library supports iOS 8.x and upwards.

### Step 1 - Install Blondie SDK

Before you start, you need to make sure you have an access to the Blondie. Then you have three options:

#### Option 1: CocoaPods

Add Blondie SDK to your Podfile and run `pod install`

```
target :YourTargetName do
  pod 'Blondie'
end
```

#### Option 2. Carthage

1. Add `github "blondie-inc/blondie-sdk-ios"` to your Cartfile.
2. Run `carthage update`.
3. Go to your Xcode project's "General" settings. Drag `Blondie.framework` from Carthage/Build/iOS to the "Embedded Binaries" section.

#### Option 3: Install Blondie manually

Download Blondie SDK for iOS and extract the zip.

Go to your Xcode project's "General" settings. Drag `Blondie.framework` to the **"Embedded Binaries"** section. Make sure **“Copy items if needed”** is selected and click Finish.

### Step 3 - Initialize Blondie

~~First, you'll need to get your Blondie app ID and iOS API key. To find these, just select the 'Blondie for iOS' option in your app settings.~~

Then initialize Blondie SDK by importing Library and adding the following to your application delegate:

**Objective-C:**
```objective-c
@import Blondie;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Blondie setApiKey:@"<Your iOS API Key>" forAppId:@"<Your App ID>"];
}
```

**Swift:**
```swift
import Blondie 
  
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
     Blondie.setApiKey("<Your iOS API Key>", forAppId: "<Your App ID>")
}
```

## Events

You can log events in Blondie that record what users do in your app and when they do it. For example, you could record the data a user submitted in your mobile app, and when they submitted it.

**Objective-C:**
```objective-c
[Blondie logEventWithName:@"Short Form Submitted" metaData: @{
  @"": @1392036272,
  @"stripe_invoice": @"inv_3434343434",
  @"customer": @{
    @"phone": @"2654321",
    @"email": @"demo@example.com"
  }
}];
```

**Swift:**
```
Blondie.logEvent(
  withName: "Short Form Submitted", 
  metaData: [
    "order_date": 1392036272,
    "stripe_invoice":"inv_3434343434",
    "order_number": [
      "value":"3434-3434",
      "url":"https://example.org/orders/3434-3434"
    ]
  ]
)
```
