# Android Embedding
---
### Flutter embedding in Android
Using Android Studio
The Android Studio IDE is a convenient way of integrating your Flutter module automatically
- co-edit both your Android code and your Flutter code in the same project
- use your normal IntelliJ Flutter plugin functionalities such as Dart code completion, hot reload, and widget inspector
- you need Android Studio 3.6 with version 42+ of the Flutter plugin for IntelliJ

Using the File > New > New Module… menu in Android Studio 
- create a new Flutter module 
- select an existing Flutter module 

The Android Studio plugin automatically adds your Flutter module as a dependency

Your app now includes the Flutter module as a dependency

---
### Manual integration
You have two scenario's to choose from:
- 1. Depend on the Android Archive (AAR)
    - more manual work
    - no need for the app developers to have Flutter SDK 
- 2. Depend on the module’s source code
    - easier integration
    - depends on the tooling of the Flutter SDK

---
### Manual integration 1
Steps for manual integration with AAR:

- create a Flutter module
Let’s assume that you have an existing Android app at some/path/MyApp, and that you want your Flutter project as a sibling:
```
 flutter create -t module --org com.example my_flutter
```

---
### Manual integration 2
- check the host apps build.gradle
```
android {
  //...
  compileOptions {
    sourceCompatibility 1.8
    targetCompatibility 1.8
  }
}
```
---
### Manual integration 3
- build the Flutter module
```
 cd some/path/my_flutter
 flutter build aar
```

---
### Manual integration 4
- add the Flutter module as dependency in project build.gradle
```
android {
  // ...
}

repositories {
  maven {
    url 'some/path/my_flutter/build/host/outputs/repo'
    // This is relative to the location of the build.gradle file
    // if using a relative path.
  }
  maven {
    url 'https://storage.googleapis.com/download.flutter.io'
  }
}

dependencies {
  // ...
  debugImplementation 'com.example.my_flutter:flutter_debug:1.0'
  releaseImplementation 'com.example.my_flutter:flutter_release:1.0'
}
```

Your app now includes the Flutter module as a dependency

---
### Manual integration 5
Steps for depend on the module’s source code
- enables a one-step build for both your Android project and Flutter project. 
- convenient when you work on both parts simultaneously and rapidly iterate, 
- must install the Flutter SDK to build the host app

Include the Flutter module as a subproject in the host app’s settings.gradle:
```
// Include the host app project.
include ':app'                                    // assumed existing content
setBinding(new Binding([gradle: this]))                                // new
evaluate(new File(                                                     // new
  settingsDir.parentFile,                                              // new
  'my_flutter/.android/include_flutter.groovy'                         // new
))                                                                     // new
```

---
### Manual integration 5

Introduce an implementation dependency on the Flutter module from your app:

```
dependencies {
  implementation project(':flutter')
}
```

The app now includes the Flutter module as a dependency

---
### Demo 

Demo. Android embedding

---
<!-- .slide: data-background="url('images/lab2.jpg')" --> 
<!-- .slide: class="lab" -->
## Lab time!