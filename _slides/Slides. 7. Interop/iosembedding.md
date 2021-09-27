# IOS Embedding

---
### Flutter embedding in iOS
Preparation:
- Xcode installed
 - iOS 9.0 and later
 - CocoaPods version 1.10 or later

---
### Create a Flutter module
From the command line, run:

```
cd some/path/
flutter create --template module my_flutter
```

---
### Module organization
The my_flutter module directory structure is similar to a normal Flutter application:

```
my_flutter/
├── .ios/
│   ├── Runner.xcworkspace
│   └── Flutter/podhelper.rb
├── lib/
│   └── main.dart
├── test/
└── pubspec.yaml
```

Add your Dart code to the lib/ directory.
Add Flutter dependencies to my_flutter/pubspec.yaml, including Flutter packages and plugins.

---
### Module organization

The .ios/ hidden subfolder contains an Xcode workspace
- you can run a standalone version of your module
- a wrapper project to bootstrap your Flutter code, and contains helper scripts to facilitate building frameworks or embedding the module into your existing application with CocoaPods

---
### Embed the Flutter module 
There are two ways to embed Flutter in your existing application
- 1. Use CocoaPods dependency manager and installed Flutter SDK. (Recommended.)
- 2. Create frameworks for the Flutter engine, your compiled Dart code, and all Flutter plugins
  - manually embed the frameworks
  - manually update your existing application’s build settings in Xcode

 Note: app does not run on a simulator in Release mode because Flutter does not yet support outputting x86/x86_64 ahead-of-time (AOT) binaries for the Dart code. You can run in Debug mode on a simulator or a real device, and Release on a real device!

---
### Embed with CocoaPods and the Flutter SDK
This method requires a locally installed version of the Flutter SDK. 
- build your application in Xcode to automatically run the script to embed your Dart and plugin code
- This allows rapid iteration with the most up-to-date version of your Flutter module without running additional commands outside of Xcode

The following example assumes that your existing application and the Flutter module are in sibling directories. If you have a different directory structure, you may need to adjust the relative paths.

```
some/path/
├── my_flutter/
│   └── .ios/
│       └── Flutter/
│         └── podhelper.rb
└── MyApp/
    └── Podfile
```

---
### Embed step

If your existing application (MyApp) doesn’t already have a Podfile
run
```
pod init
```

Add the following lines to your Podfile:

```
flutter_application_path = '../my_flutter'
load File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')

target 'MyApp' do
  install_all_flutter_pods(flutter_application_path)
end
```
then
```
pod install
```

---
### Embed step
Open MyApp.xcworkspace in Xcode. You can now build the project using ⌘B.


---
### Manually embed the frameworks

- generate the necessary frameworks 
- embed them in your application by manually editing your existing Xcode project
  - does not require cocoapods
  - does not require Flutter SDK
  
You must run flutter build ios-framework every time you make code changes in your Flutter module

---
### Embed step
run
```
flutter build ios-framework --output=some/path/MyApp/Flutter/
```
the output is
```
some/path/MyApp/
└── Flutter/
    ├── Debug/
    │   ├── Flutter.xcframework
    │   ├── App.xcframework
    │   ├── FlutterPluginRegistrant.xcframework (only if you have plugins with iOS platform code)
    │   └── example_plugin.xcframework (each plugin is a separate framework)
    ├── Profile/
    │   ├── Flutter.xcframework
    │   ├── App.xcframework
    │   ├── FlutterPluginRegistrant.xcframework
    │   └── example_plugin.xcframework
    └── Release/
        ├── Flutter.xcframework
        ├── App.xcframework
        ├── FlutterPluginRegistrant.xcframework
        └── example_plugin.xcframework
```

---
### Embed step

Embed and link the generated frameworks into the existing application in Xcode
- link on the frameworks
  - drag the frameworks from some/path/MyApp/Flutter/Release/ in Finder into your target’s 
  Build Settings > Build Phases > Link Binary With Libraries.

In the target’s build settings, add $(PROJECT_DIR)/Flutter/Release/ to the Framework Search Paths (FRAMEWORK_SEARCH_PATHS).

Update Framework Search Paths in Xcode
Embed the frameworks
The generated dynamic frameworks must be embedded into your app to be loaded at runtime.

 Important: Plugins might produce static or dynamic frameworks. Static frameworks should be linked on, but never embedded. If you embed a static framework into your application, your application is not publishable to the App Store and fails with a Found an unexpected Mach-O header code archive error.

For example, you can drag the framework (except for FlutterPluginRegistrant and any other static frameworks) from your application’s Frameworks group into your target’s Build Settings > Build Phases > Embed Frameworks. Then, select Embed & Sign from the drop-down list.

Embed frameworks in Xcode
You should now be able to build the project in Xcode using ⌘B.

 Tip: To embed the Debug version of the Flutter frameworks in your Debug build configuration and the Release version in your Release configuration, in your MyApp.xcodeproj/project.pbxproj, try replacing path = Flutter/Release/example.xcframework; with path = "Flutter/$(CONFIGURATION)/example.xcframework"; for all added frameworks. (Note the added ".)

You must also add $(PROJECT_DIR)/Flutter/$(CONFIGURATION) to the Framework Search Paths (FRAMEWORK_SEARCH_PATHS) build setting.

Option C - Embed application and plugin frameworks in Xcode and Flutter framework with CocoaPods
Alternatively, instead of distributing the large Flutter.xcframework to other developers, machines, or continuous integration systems, you can instead generate Flutter as CocoaPods podspec by adding the flag --cocoapods. This produces a Flutter.podspec instead of an engine Flutter.xcframework. The App.xcframework and plugin frameworks are generated as described in Option B.

content_copy
flutter build ios-framework --cocoapods --output=some/path/MyApp/Flutter/
content_copy
some/path/MyApp/
└── Flutter/
    ├── Debug/
    │   ├── Flutter.podspec
    │   ├── App.xcframework
    │   ├── FlutterPluginRegistrant.xcframework
    │   └── example_plugin.xcframework (each plugin with iOS platform code is a separate framework)
    ├── Profile/
    │   ├── Flutter.podspec
    │   ├── App.xcframework
    │   ├── FlutterPluginRegistrant.xcframework
    │   └── example_plugin.xcframework
    └── Release/
        ├── Flutter.podspec
        ├── App.xcframework
        ├── FlutterPluginRegistrant.xcframework
        └── example_plugin.xcframework
Host apps using CocoaPods can add Flutter to their Podfile:

content_copy
pod 'Flutter', :podspec => 'some/path/MyApp/Flutter/[build mode]/Flutter.podspec'
 Note: You must hard code the [build mode] value. For example, use Debug if you need to use flutter attach and Release when you’re ready to ship.

Embed and link the generated App.xcframework, FlutterPluginRegistrant.xcframework, and any plugin frameworks into your existing application as described in Option B.

Local Network Privacy Permissions
On iOS 14 and higher, enable the Dart multicast DNS service in the Debug version of your app to add debugging functionalities such as hot-reload and DevTools via flutter attach.

 Warning: This service must not be enabled in the Release version of your app, or you may experience App Store rejections.

One way to do this is to maintain a separate copy of your app’s Info.plist per build configuration. The following instructions assume the default Debug and Release. Adjust the names as needed depending on your app’s build configurations.

Rename your app’s Info.plist to Info-Debug.plist. Make a copy of it called Info-Release.plist and add it to your Xcode project.

Info-Debug.plist and Info-Release.plist in Xcode
In Info-Debug.plist only add the key NSBonjourServices and set the value to an array with the string _dartobservatory._tcp. Note Xcode will display this as “Bonjour services”.

Optionally, add the key NSLocalNetworkUsageDescription set to your desired customized permission dialog text.

Info-Debug.plist with additional keys
In your target’s build settings, change the Info.plist File (INFOPLIST_FILE) setting path from path/to/Info.plist to path/to/Info-$(CONFIGURATION).plist.

Set INFOPLIST_FILE build setting
This will resolve to the path Info-Debug.plist in Debug and Info-Release.plist in Release.

Resolved INFOPLIST_FILE build setting
Alternatively, you can explicitly set the Debug path to Info-Debug.plist and the Release path to Info-Release.plist.

If the Info-Release.plist copy is in your target’s Build Settings > Build Phases > Copy Bundle Resources build phase, remove it.

Copy Bundle build phase
The first Flutter screen loaded by your Debug app will now prompt for local network permission. The permission can also be allowed by enabling Settings > Privacy > Local Network > Your App.

Local network permission dialog
Apple Silicon (arm64 Macs)
Flutter does not yet support arm64 iOS simulators. To run your host app on an Apple Silicon Mac, exclude arm64 from the simulator architectures.

In your host app target, find the Excluded Architectures (EXCLUDED_ARCHS) build setting. Click the right arrow disclosure indicator icon to expand the available build configurations. Hover over Debug and click the plus icon. Change Any SDK to Any iOS Simulator SDK. Add arm64 to the build settings value.

Set conditional EXCLUDED_ARCHS build setting
When done correctly, Xcode will add "EXCLUDED_ARCHS[sdk=iphonesimulator*]" = arm64; to your project.pbxproj file.

Repeat for any iOS unit test targets.

Development

---
### Demo 

Demo. Android embedding

---
<!-- .slide: data-background="url('images/lab2.jpg')" --> 
<!-- .slide: class="lab" -->
## Lab time!