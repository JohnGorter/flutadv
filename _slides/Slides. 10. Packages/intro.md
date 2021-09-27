# Packages

---
### Packages
Packages are software bundles contributed by other developers 
to the Flutter and Dart ecosystems

---
### Packages
- Existing packages, for example
    - http: making network requests 
    - fluro: custom navigation/route handling
    - url_launcher / battery: integration with device APIs 
    - Firebase
    - more..
- Your custom developed packages


---
### Using packages
To add a package ‘css_colors’ to an app:

- Depend on it
Open the pubspec.yaml file located inside your app folder, and add css_colors: under dependencies.
- Install it
From the terminal: Run flutter packages get
OR
From Android Studio/IntelliJ: Click ‘Packages Get’ in the action ribbon at the top of pubspec.yaml
From VS Code: Click ‘Get Packages’ located in right side of the action ribbon at the top of pubspec.yaml
- Import it
Add a corresponding import statement in your Dart code.


---
### Package types
Packages can contain several kinds of content:

- Dart packages: General packages that may contain Flutter specific functionality and thus have a dependency on the Flutter framework
    - fluro package

- Plugin packages: Specialized Dart package with API implementation for Android and/or iOS 
    - battery plugin package

---
### Developing packages
A minimal package consists of:
-  A pubspec.yaml file: 
    - A metadata file that declares the package name, version, author, etc.
- A lib directory containing the public code in the package
    - minimally a single <package-name>.dart file.

---
### Create your own package
To create a Dart package, use the --template=package flag with flutter create:
```
flutter create --template=package hello
```

This creates a package project in the hello/ folder with:

- lib/hello.dart:
    - The Dart code for the package.
- test/hello_test.dart:
    - The unit tests for the package.

---
### Referencing packages
- External packages
- Local packages

---
### External packages
- update pubspec.yaml
- use import:'package:...packagename...';

example:
```
import 'package:flutter/material.dart';
```

---
### Local packages
- not published on Pub aka private plugins

- Path dependency in pubspec.yaml
```dependencies:
  plugin1:
    path: ../plugin1/
```
- Git dependency in pubspec.yaml
```
dependencies:
  plugin1:
    git:
      url: git://github.com/flutter/plugin1.git
```
- Git dependency on a package in a folder
In pubspec.yaml:
```
dependencies:
  package1:
    git:
      url: git://github.com/flutter/packages.git
      path: packages/package1  
```      
* Ref argument to pin the dependency to a specific git commit, branch, or tag. 

---
# Demo 

Writing a package

---
# Plugins

- Flutter team plugins:
    - https://github.com/flutter/plugins
- Third party plugins
   - https://github.com/matthew-carroll/fluttery



---
<!-- .slide: data-background="url('images/demo.jpg')" --> 
<!-- .slide: class="lab" -->
## Demo time!
Demo 8.1 Using the Battery Plugin


---
<!-- .slide: data-background="url('images/lab2.jpg')" --> 
<!-- .slide: class="lab" -->
## Lab time!
Use Audioplayer and Firebase Plugins

Flutter startup 