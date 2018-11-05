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

First, you'll need to get your Blondie Flow ID and an API key. To find these, just add an SDK trigger to your Blondie Flow.

Then initialize Blondie SDK by importing Library and adding the following to your application delegate:

**Objective-C:**
```objective-c
@import Blondie;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Blondie setApiKey:@"<Your API Key>" forFlowId:@"<Your Flow ID>"];
}
```

**Swift:**
```swift
import Blondie 
  
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
     Blondie.setApiKey("<Your API Key>", forFlowId: "<Your Flow ID>")
}
```

## Configuration

Here’s how to configure Blondie for iOS:

### Select an environment

You can select the Blondie Flow environment to use. It is very handy when you need to test a particular feature before rolling out to production.

By default we select `production` environment, but you can always change it by calling one of:

**Objective-C**
```objective-c
[Blondie useDevelopmentEnvironment];
[Blondie useTestEnvironment];
[Blondie useProductionEnvironment];
```

**Swift**
```swift
Blondie.useDevelopmentEnvironment()
Blondie.useTestEnvironment()
Blondie.useProductionEnvironment()
```

### Use a custom Blondie Flow instance

In order to integrate Blondie SDK with a custom Blondie Flow instance you can set the base url by calling:

**Objective-C**
```objective-c
[Blondie setBaseUrl:@"https://custom.flow.url"];
```

**Swift**
```swift
Blondie.setBaseUrl("https://custom.flow.url")
```

## Tracking events

You can log events in Blondie that record what users do in your app and when they do it. For example, you could record the data a user submitted in your mobile app, and when they submitted it.

**Objective-C:**
```objective-c
[Blondie triggerEventWithName:@"Short Form Submitted" metaData: @{
  @"amount": @1234,
  @"customer": @{
    @"phone": @"+3712654321",
    @"email": @"demo@example.com"
  }
}];
```

**Swift:**
```swift
Blondie.triggerEvent(
  withName: "Short Form Submitted", 
  metaData: [
    "amount": 1234,
    "customer": [
      "phone": "+3712654321",
      "email": "demo@example.com"
    ]
  ]
)
```
