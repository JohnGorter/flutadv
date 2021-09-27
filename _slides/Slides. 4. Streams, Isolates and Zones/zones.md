# Zones

---
### Zones
Asynchronous dynamic extents
Currently, the most common use of zones is to handle errors raised in asynchronously executed code

For example, a simple HTTP server might use the following code:
```
runZoned(() {
  HttpServer.bind('0.0.0.0', port).then((server) {
    server.listen(staticFiles.serveRequest);
  });
},
onError: (e, stackTrace) => print('Oh noes! $e $stackTrace'));
```

Running the server in a zone enables the app to continue running despite uncaught (but non-fatal) errors in the server’s asynchronous code!

---
### Zones
Zones make the following tasks possible
- protecting your app from exiting due to an uncaught exception thrown by asynchronous code
- associating data—known as zone-local values—with individual zones
- overriding a limited set of methods, such as print() and scheduleMicrotask(), within part or all of the code
- performing an operation each time that code enters or exits a zone
    — starting or stopping a timer / saving a stack trace

---
### Zones
Zones are everywhere:
- in NodeJS, Zones are called Domains in Node.js 
- Java’s thread-local storage also has some similarities
- in JavaScript, there is a port of Dart zones, zone.js

---
### Zone basics
A zone represents the asynchronous dynamic extent of a call

> It is the computation that is performed as part of a call and, transitively, the asynchronous callbacks that have been registered by that code

For example, in the HTTP server example, bind(), then(), and the callback of then() all execute in the same zone—the zone that was created using runZoned()

---
### Another example
In the next example are 3 different zones
- zone #1 (the root zone)
- zone #2
- zone #3

```
import 'dart:async';

main() {
  foo();
  var future;
  runZoned(() {          // Starts a new child zone (zone #2).
    future = new Future(bar).then(baz);
  });
  future.then(qux);
}

foo() => ...foo-body...  // Executed twice (once each in two zones).
bar() => ...bar-body...
baz(x) => runZoned(() => foo()); // New child zone (zone #3).
qux(x) => ...qux-body...
```

<img src="/images/zones.png" heigh="400" style="position:absolute;right:-100px;top:20px;"/>

---
### A Diagram

Takeaways
- each call to runZoned() creates a new zone and executes code in that zone
- when that code schedules a task—such as calling baz()
  — that task executes in the zone where it was scheduled
- the call to qux() (last line of main()) runs in zone #1 (the root zone) even though it’s attached to a future that itself runs in zone #2!


---
### Zones
The root zone
- all Dart code executes in the root zone
- code might execute in other nested child zones as well, but at a minimum it always runs in the root zone.

---
### Handling asynchronous errors
One of the most used features of zones is their ability to handle uncaught errors in asynchronously executing code

You can use the onError argument to runZoned() to install a zoned error handler
```
runZoned(() {
  Timer.run(() { throw 'Would normally kill the program'; });
}, onError: (error, stackTrace) {
  print('Uncaught error: $error');
});
```

---
### Difference between try-catch and zoned error handlers

- zones continue to execute after uncaught errors 
- try-catch stops executing after uncaught errors  

If other asynchronous callbacks are scheduled within the zone, they still execute. As a consequence a zoned error handler might be invoked multiple times!


---
### Errors in Future Chains 
Errors on Future chains never cross the boundaries of error zones

If an error reaches an error zone boundary
- treated as unhandled error

---
### Example Errors in Future Chains 
The error raised by the first line can’t cross INTO an error zone
```
var f = new Future.error(499);
f = f.whenComplete(() { print('Outside runZoned'); });
runZoned(() {
  f = f.whenComplete(() { print('Inside non-error zone'); });
});
runZoned(() {
  f = f.whenComplete(() { print('Inside error zone (not called)'); });
}, onError: print);
```


---
### Example Errors in Future Chains 
Here’s the output you see if you run the example:
```
Outside runZoned
Inside non-error zone
Uncaught Error: 499
Unhandled exception:
499
...stack trace...
```

If you remove the calls to runZoned() or remove the onError argument, you see this output:
```
Outside runZoned
Inside non-error zone
Inside error zone (not called)
Uncaught Error: 499
Unhandled exception:
499
...stack trace...
```
Note how removing either the zones or the error zone causes the error to propagate further.


---
### Example Errors in Future Chains 
The stack trace appears because the error happens outside an error zone

If you add an error zone around the whole code snippet, then you can avoid the stack trace

---
### Example 2 Errors in Future Chains 
Example: Errors can’t LEAVE error zones

```
var completer = new Completer();
var future = completer.future.then((x) => x + 1);
var zoneFuture;
runZoned(() {
  zoneFuture = future.then((y) => throw 'Inside zone');
}, onError: (error) {
  print('Caught: $error');
});
zoneFuture.catchError((e) { print('Never reached'); });
completer.complete(499);
```

Even though the future chain ends in a catchError(), the asynchronous error can’t leave the error zone.

---
### Using zones with streams
The rule for zones and streams is simpler than for futures

Example: Using a stream with runZoned()
```
var stream = new File('stream.dart').openRead()
    .map((x) => throw 'Callback throws');

runZoned(() { stream.listen(print); },
         onError: (e) { print('Caught error: $e'); });
```

The exception thrown by the callback is caught by the error handler of runZoned(). Here’s the output:
```
Caught error: Callback throws
```

As the output shows, the callback is associated with the listening zone, not with the zone where map() is called.

---
### Storing zone-local values
If you want to use a static variable but couldn’t because multiple concurrently running computations interfered with each other
- use a zone-local value

Another use case is dealing with an HTTP request
- you could have the user ID and its authorization token in zone-local values

---
### Storing zone-local values
Use the zoneValues argument to runZoned() to store values in the newly created zone:
```
runZoned(() {
  print(Zone.current[#key]);
}, zoneValues: { #key: 499 });
```

---
### Reading zone-local values
To read zone-local values, use the zone’s index operator and the value’s key

You can’t change the object that a key maps to, but you can manipulate the object. For example, the following code adds an item to a zone-local list:

```
runZoned(() {
  Zone.current[#key].add(499);
  print(Zone.current[#key]); // [499]
}, zoneValues: { #key: [] });
```

---
### Zone-local inheritance
A zone inherits zone-local values from its parent zone
- adding nested zones doesn’t drop existing values
- nested zones can, however, shadow parent values

---
### Zone-local inheritance Example

Say you have two files, foo.txt and bar.txt, and want to print all of their lines. The program might look like this:
```
import 'dart:async';
import 'dart:convert';
import 'dart:io';

Future splitLinesStream(stream) {
  return stream
      .transform(ASCII.decoder)
      .transform(const LineSplitter())
      .toList();
}

Future splitLines(filename) {
  return splitLinesStream(new File(filename).openRead());
}
main() {
  Future.forEach(['foo.txt', 'bar.txt'],
                 (file) => splitLines(file)
                     .then((lines) { lines.forEach(print); }));
}
```

---
### Zone-local inheritance Example
This program works, but let’s assume that you now want to know which file each line comes from

You could do this
```
import 'dart:async';
import 'dart:convert';
import 'dart:io';

Future splitLinesStream(stream) {
  return stream
      .transform(ASCII.decoder)
      .transform(const LineSplitter())
      .map((line) => '${Zone.current[#filename]}: $line')
      .toList();
}

Future splitLines(filename) {
  return runZoned(() {
    return splitLinesStream(new File(filename).openRead());
  }, zoneValues: { #filename: filename });
}

main() {
  Future.forEach(['foo.txt', 'bar.txt'],
                 (file) => splitLines(file)
                     .then((lines) { lines.forEach(print); }));
}
```

---
### Overriding functionality
Use the zoneSpecification argument to runZoned() to override functionality that is managed by zones

you can override any of the following functionality:
- Forking child zones
- Registering and running callbacks in the zone
- Scheduling microtasks and timers
- Handling uncaught asynchronous errors (onError is a shortcut for this)
- Printing

---
### Overriding functionality example
Example: Overriding print by silencing all prints inside a zone:
```
import 'dart:async';
main() {
  runZoned(() {
    print('Will be ignored');
  }, zoneSpecification: new ZoneSpecification(
    print: (self, parent, zone, message) {
      // Ignore message.
    }));
}
```

---
### Arguments to interceptors and delegates
As the print example shows, an interceptor adds three arguments to those defined in the Zone class’s corresponding method

- Zone’s print() method has one argument: print(String line)
- The interceptor version of print()has four: print(Zone self, ZoneDelegate parent, Zone zone, String line)

The three interceptor arguments always appear in the same order, before any other arguments!

---
### Arguments to interceptors and delegates
- self -> the zone that’s handling the callback
- parent -> a ZoneDelegate representing the parent zone
- zone -> the zone where the operation originated

---
### method delegation to parent
When an interceptor delegates a method to the parent, the parent (ZoneDelegate) version of the method has just one additional argument
- zone, the zone where the original call originated from


Here is an example that shows how to delegate to the parent zone:
```
import 'dart:async';

main() {
  runZoned(() {
    var currentZone = Zone.current;
    scheduleMicrotask(() {
      print(identical(currentZone, Zone.current));  // prints true.
    });
  }, zoneSpecification: new ZoneSpecification(
    scheduleMicrotask: (self, parent, zone, task) {
      print('scheduleMicrotask has been called inside the zone');
      // The origin `zone` needs to be passed to the parent so that
      // the task can be executed in it.
      parent.scheduleMicrotask(zone, task);
    }));
}
```

---
###  Executing code when entering and leaving a zone
Say you want to know how much time some asynchronous code spends executing

You can provide run* parameters to the ZoneSpecification.

The run* parameters—run, runUnary, and runBinary—specify code to execute every time the zone is asked to execute code

---
###  Executing code when entering and leaving a zone Example
```
final total = new Stopwatch();
final user = new Stopwatch();

final specification = new ZoneSpecification(
  run: (self, parent, zone, f) {
    user.start();
    try { return parent.run(zone, f); } finally { user.stop(); }
  },
  runUnary: (self, parent, zone, f, arg) {
    user.start();
    try { return parent.runUnary(zone, f, arg); } finally { user.stop(); }
  },
  runBinary: (self, parent, zone, f, arg1, arg2) {
    user.start();
    try {
      return parent.runBinary(zone, f, arg1, arg2);
    } finally {
      user.stop();
    }
  });

runZoned(() {
  total.start();
  // ... Code that runs synchronously...
  // ... Then code that runs asynchronously ...
    .then((...) {
      print(total.elapsedMilliseconds);
      print(user.elapsedMilliseconds);
    });
}, zoneSpecification: specification);
```

---
### Summary
Zones are good for protecting your code from uncaught exceptions in asynchronous code, but they can do much more. 

- associate data with zones
- override core functionality such as printing and task scheduling. 
- zones enable better debugging and provide hooks that you can use for functionality such as profiling

---
<!-- .slide: data-background="url('images/demo.jpg')" --> 
<!-- .slide: class="lab" -->
## Demo time!
Demo 1 Zones in dart

---
### Zones in Flutter
Why bother?

Remember what we said about zones:
- good for protecting your code from uncaught exceptions

We use a lot of async code, HTTP, FileIO etc...
What happens if we do not catch async exceptions in Flutter?
- the app dies

How do we catch these? Right! Zones!

---
### Handling errors in Flutter
The Flutter framework catches errors that occur during callbacks triggered by the framework itself, including errors encountered during the 
- build
- layout
- paint 

Errors that don’t occur within Flutter’s callbacks can’t be caught by the framework, setting up a Zone helps

---
### FlutterError.onError

All errors caught by Flutter are routed to the FlutterError.onError handler
- by default, this calls FlutterError.dumpErrorToConsole

When an error occurs during the build phase, the ErrorWidget.builder callback is invoked to build the widget that is used instead of the one that failed.
- by default, in debug mode this shows an error message in red, and in release mode this shows a gray background

When errors occur without a Flutter callback on the call stack, they are handled by the Zone where they occur
- by default, a Zone only prints errors and does nothing else

---
### Customize error handling in Flutter
You can customize these behaviors by setting them to values in your void main() function.

---
### Errors caught by Flutter
For example, to make your application quit immediately any time an error is caught:

Errors caught by Flutter can be overriden:
```
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    if (kReleaseMode)
      exit(1);
  };
  runApp(MyApp());
}
```

Note: The top-level kReleaseMode constant indicates whether the app was compiled in release mode.

---
### Customize error handling in Flutter

To define a customized error widget that displays whenever the builder fails to build a widget, use MaterialApp.builder:

```
class MyApp extends StatelessWidget {
...
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      ...
      builder: (BuildContext context, Widget widget) {
        Widget error = Text('...rendering error...');
        if (widget is Scaffold || widget is Navigator)
          error = Scaffold(body: Center(child: error));
        ErrorWidget.builder = (FlutterErrorDetails errorDetails) => error;
        return widget;
      },
    );
  }
}
```

---
### Errors not caught by Flutter
Consider an onPressed callback that invokes an asynchronous function, such as MethodChannel. For example:

```
OutlinedButton(
  child: Text('Click me!'),
  onPressed: () async {
    final channel = const MethodChannel('crashy-custom-channel');
    await channel.invokeMethod('blah');
  },
),
```
If invokeMethod throws an error, it won’t be forwarded to FlutterError.onError. Instead, it’s forwarded to the Zone where runApp was run!

---
### Errors not caught by Flutter
To catch errors outside of flutter (like async calls), use runZonedGuarded

```
import 'dart:async';

void main() {
  runZonedGuarded(() {
    runApp(MyApp());
  }, (Object error, StackTrace stack) {
    myBackend.sendError(error, stack);
  });
}
```

---
### Errors not caught by Flutter (2)
If in your app you call WidgetsFlutterBinding.ensureInitialized() manually to perform some initialization before calling runApp (e.g. Firebase.initializeApp()) you must call WidgetsFlutterBinding.ensureInitialized() inside runZonedGuarded:

```
runZonedGuarded(() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
```

---
### Handling all types of errors
Say you want to all of the above:

```
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await myErrorsHandler.initialize();
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.dumpErrorToConsole(details);
      myErrorsHandler.onError(details);
      exit(1);
    };
    runApp(MyApp());
  }, (Object error, StackTrace stack) {
    myErrorsHandler.onError(error, stack);
    exit(1);
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (BuildContext context, Widget widget) {
        Widget error = Text('...rendering error...');
        if (widget is Scaffold || widget is Navigator)
          error = Scaffold(body: Center(child: error));
        ErrorWidget.builder = (FlutterErrorDetails errorDetails) => error;
        return widget;
      },
    );
  }
}
```

---
<!-- .slide: data-background="url('images/demo.jpg')" --> 
<!-- .slide: class="lab" -->
## Demo time!
Demo 2 Catch Flutter Errors

---
<!-- .slide: data-background="url('images/lab2.jpg')" --> 
<!-- .slide: class="lab" -->
## Lab time!