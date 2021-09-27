# JavaScript Interop

---
### JavaScript Interop
Sometimes you want to call Flutter/Dart code from your JavaScript
- Chrome features that trigger and your app needs to respond (Push Notification/Page LifeCycle Events)
- dart:js: low level interop support
Sometimes you want to integrate FlutterWeb with Javascript
- communicate with JavaScript Libraries (jQuery/VueJS)
- communicate with Chrome (LocalStorage/WebWorkers/Geolocation)
- package:dart: higher level interop support

---
### dart.js
Low-level support for interoperating with JavaScript
- provides access to JavaScript objects from Dart
- allows Dart code to get and set properties
- allows Dart to call methods of JavaScript objects 
- allows invokation of JavaScript functions
- takes care of converting between Dart and JavaScript objects
    -  providing proxies if conversion isn't possible.


---
### dart.js

This library does not 
- make Dart objects usable from JavaScript
    - their methods and properties are not accessible

---
### JSObject and context
JsObject is the core type and represents a proxy of a JavaScript object 
- gives access to the underlying JavaScript objects properties and methods. 

JsObjects can be acquired by calls to JavaScript, or they can be created from proxies to JavaScript constructors.

The top-level getter 'context' provides a 'JsObject' that represents the global object in JavaScript
- usually window

---
### Example
The following example shows an alert dialog via a JavaScript call to the global function alert():
```
import 'dart:js';
main() => context.callMethod('alert', ['Hello from Dart!']);
```

---
### Example 2

This example shows how to create a [JsObject] from a JavaScript constructor and access its properties:
```
import 'dart:js';

main() {
  var object = JsObject(context['Object']);
  object['greeting'] = 'Hello';
  object['greet'] = (name) => "${object['greeting']} $name";
  var message = object.callMethod('greet', ['JavaScript']);
  context['console'].callMethod('log', [message]);
}
```
---
<!-- .slide: data-background="url('images/demo.jpg')" --> 
<!-- .slide: class="lab" -->
## Demo time!
Demo. Low level JS interop

---
### Calling dart from JS
Since we have access to the Window, we can call dart functions from JavaSript
```
// inside index.html
window.setTimeout(()=>{
    window.callDartCode();
}, 10000);      

// inside main.dart
...
context['callDartCode'] = () {
    print('called this code');
}
```

<!-- .slide: data-background="url('images/demo.jpg')" --> 
<!-- .slide: class="lab" -->
## Demo time!
Demo. Low level JS interop


---
### JsObject.jsify

To create a JavaScript collection from a Dart collection use the 'JsObject.jsify' constructor
- converts Dart Maps and Iterables into JavaScript Objects and Arrays

The following expression creates a new JavaScript object with the properties a and b defined:
```
var jsMap = JsObject.jsify({'a': 1, 'b': 2});
```
This expression creates a JavaScript array:
```
var jsArray = JsObject.jsify([1, 2, 3]);
```


---
### JS package
Annotation support for Dart 2 JS interop

Use this package when you want to call JavaScript APIs from Dart code, or vice versa.
- provides annotations and functions 
- dart-to-JavaScript compilers recognize these annotations

This library supersedes dart:js

---
### Usage JS Package 
Calling JavaScript functions 
```
@JS()
library stringify;

import 'package:js/js.dart';

// Calls invoke JavaScript `JSON.stringify(obj)`.
@JS('JSON.stringify')
external String stringify(Object obj);
```

---
### Usage JS Package 
Using JavaScript namespaces and classes 
```
@JS('google.maps')
library maps;

import 'package:js/js.dart';

// Invokes the JavaScript getter `google.maps.map`.
external Map get map;

// The `Map` constructor invokes JavaScript `new google.maps.Map(location)`
@JS()
class Map {
  external Map(Location location);
  external Location getLocation();
}

// The `Location` constructor invokes JavaScript `new google.maps.LatLng(...)`
//
// We recommend against using custom JavaScript names whenever
// possible. It is easier for users if the JavaScript names and Dart names
// are consistent.
@JS('LatLng')
class Location {
  external Location(num lat, num lng);
}
```

---
### Passing object literals to JavaScript 
Many JavaScript APIs take an object literal as an argument. For example:
```
// JavaScript
printOptions({responsive: true});
```
If you want to use printOptions from Dart a Map<String, dynamic> would be "opaque" in JavaScript.
Instead, create a Dart class with both the @JS() and @anonymous annotations.

```
@JS()
library print_options;

import 'package:js/js.dart';

void main() {
  printOptions(Options(responsive: true));
}

@JS()
external printOptions(Options options);

@JS()
@anonymous
class Options {
  external bool get responsive;

  // Must have an unnamed factory constructor with named arguments.
  external factory Options({bool responsive});
}
```

---
### Making a Dart function callable from JavaScript 
If you pass a Dart function to a JavaScript API as an argument
- wrap the Dart function using allowInterop() or allowInteropCaptureThis()

To make a Dart function callable from JavaScript by name
- use a setter annotated with @JS().


```
@JS()
library callable_function;

import 'package:js/js.dart';

/// Allows assigning a function to be callable from `window.functionName()`
@JS('functionName')
external set _functionName(void Function() f);

/// Allows calling the assigned function from Dart as well.
@JS()
external void functionName();

void _someDartFunction() {
  print('Hello from Dart!');
}

void main() {
  _functionName = allowInterop(_someDartFunction);
  // JavaScript code may now call `functionName()` or `window.functionName()`.
}
```


---
### Demo 

Demo. JS Package

---
<!-- .slide: data-background="url('images/lab2.jpg')" --> 
<!-- .slide: class="lab" -->
## Lab time!