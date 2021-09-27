# Dart

---
### Why Dart

- Simple Syntax, Object Oriented, Optionally Typed
- Batteries included
- Rich ecosystem <a href="https://pub.dartlang.org/">Dart Pub</a>
- AOT and JIT
- Compiles to JavaScript and Native Code
- Web, Server and Mobile

---
### Some Dart specifics
The cascade operator (from SmallTalk)
```
myTokenTable
  ..add("aToken");
  ..add("anotherToken");
// many lines elided here
// and here ... 
  ..add("theUmpteenthToken");
```

---
### Some Dart specifics
Field setter syntax, named optional parameters with default values
```
class Person {
    Person({this.name = "john", this.lastname});
    final String name; 
    final String lastname;
}
```

---
### Some Dart specifics
Named constructors 

```
class Location {
  num lat, lng; // Instance variables
  Location.fromJson(Map json) : lat = json['lat'], lng = json['lng']; 
}
```

---
### Some Dart specifics
Factory constructors

```
class Name {
  final String first;
  final String last;
  factory Name(String name) {
    var parts = name.split(' ');
    return new Name._(parts[0], parts[1]);
  }
  Name._(this.first, this.last);
}
```

---
### Some Dart specifics
Main function

```
main(){
    // your code here...
}
```

---
### Some Dart Libraries
Usefull libraries
- dart:core
- dart:io
- dart:html
- dart:async
- dart:convert
- dart:crypto
- dart:isolate
- dart:math
And more in the Dart Pub registry....

---
<!-- .slide: data-background="url('images/demo.jpg')" --> 
<!-- .slide: class="lab" -->
## Demo time!
Demo 1. Dart