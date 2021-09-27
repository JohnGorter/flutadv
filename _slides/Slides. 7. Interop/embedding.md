# Embedding Flutter
---
### Add Flutter to existing apps
Flutter can be integrated into your existing application as a library or module. 
- module can then be imported into your Android or iOS 
    - part of your app’s UI in Flutter
    - just to run shared Dart logic

In a few steps, you can bring the productivity and the expressiveness of Flutter into your own app.

---
### Flutter embedding limitations
Following limitations:
- packing multiple Flutter libraries into an application isn’t supported.
- plugins used in add-to-app on Android should migrate to the new Android plugin APIs
- as of v1.17, the Flutter module only supports AndroidX applications on Android.
- as of Flutter v1.26, add-to-app experimentally supports adding multiple instances of Flutter engines, screens, or views into your app. 
 - enable scenarios such as a hybrid navigation stack with mixed native and Flutter screens
 - enable a page with multiple partial-screen Flutter views

---
### Supported features
Add-to-app steps on Android
- add a Flutter SDK hook to your Gradle script
- build Flutter module into a generic Android Archive (AAR)

Java and Kotlin host apps are supported

Add-to-app steps on iOS
- add a Flutter SDK hook to your CocoaPods and to your Xcode build phase
- build Flutter module into a generic iOS Framework 

Objective-C and Swift host apps supported.

