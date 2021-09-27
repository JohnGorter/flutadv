# Threading

---
### Threads
Dart was originally a single-threaded programming language. 
Sometimes you need threads: 
- image decoding/encoding
- number crunching
- other?

We typically dont want to frustrate the UI thread!

---
### What is Isolate?
Any Dart code is executed in Isolate
- isolated environment with memory and EventLoop allocated  

Isolate resembled a process in OS or WebWorker in JS

Each Isolate is single-threaded and can only manage the memory and EventLoop allocated for it. 
You cannot control the memory of another Isolate.

---
### How do different Isolates communicate?
Ports
- SendPort
- ReceivePort


---
### How do I start using Isolates in my applications?
Include the Dart library: isolates

Classes available:
- Capability:
- Isolate: Isolate or isolated context of the execution of Dart code.
- RecievePort: a Single subscription stream
- SendPort: a class that can send messages to RecievePort

---
### When should I use Isolate?

To complete a sizeable one-time task. For example
- de- / serialization of data, 
- receiving a large response from the server
- some complex mathematical calculations (Fibonacci number), etc.

You can isolate someone else's poorly optimized code so that you do not rewrite it

---
### Basic example
```
import 'dart:isolate';
import 'package:flutter/material.dart';

void main() {
 runApp(MyApp());
}

class MyApp extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
   return MaterialApp(
     home: MyHomePage(),
   );
 }
}

class MyHomePage extends StatefulWidget {
 @override
 _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
 Isolate isolate;
 ReceivePort receivePort;

 @override
 void initState() {
   super.initState();
   spawnNewIsolate();
 }

 void spawnNewIsolate() async {
   receivePort = ReceivePort();
   try {
     isolate = await Isolate.spawn(sayHello, receivePort.sendPort);
     print("Isolate: $isolate");
     receivePort.listen((dynamic message) {
       print('New message from Isolate: $message');
     });
   } catch (e) {
     print("Error: $e");
   }
 }

 //spawn accepts only static methods or top-level functions
 static void sayHello(SendPort sendPort) {
   sendPort.send("Hello from Isolate");
 }

 @override
 void dispose() {
   super.dispose();
   receivePort.close();
   isolate.kill();
 }

 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text("Isolate Demo"),
     ),
     body: Center(),
   );
 }
}
```

---
<!-- .slide: data-background="url('images/demo.jpg')" --> 
<!-- .slide: class="lab" -->
## Demo time!
Demo 1 Isolates

---
<!-- .slide: data-background="url('images/lab2.jpg')" --> 
<!-- .slide: class="lab" -->
## Lab time!

---
### Compute
Compute is a more convenient way of working with isolates,
- a built-in wrapper over Isolate Api in Flutter

Flutter extends isolates with compute by taking care of:
- Isolate creation
- Task transfer to isolate
- Task completion
- Returning  response
- Closing ports
- Isolate destruction

---
### Compute
All you need to use the compute function is 
- pass first argument to the function that you want to execute in the isolate
- pass second argument to pass arguments that should go to the executable function

---
### Compute Basic example
```
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
 runApp(MyApp());
}

class MyApp extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
   return MaterialApp(
     home: MyHomePage(),
   );
 }
}

class MyHomePage extends StatefulWidget {
 @override
 _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
 @override
 void initState() {
   super.initState();
   createComputeFunction();
 }

 void createComputeFunction() async {
   String answer;
   answer = await compute(sayHelloFromCompute, 'Hello');
   print("Answer from compute: $answer");
 }

 static String sayHelloFromCompute(String string) {
   return string;
 }

 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text("Isolate Demo"),
     ),
     body: Center(),
   );
 }
}
```

---
### Third-party solutions
There are two third-party libraries for working with isolates
- computer - https://pub.dev/packages/computer 
  - creating a limited number of workers
  - distribution of tasks between the created workers
  - task queue management
- worker_manager - https://pub.dev/packages/worker_manager
  - creation of a pool of isolates
  - works through streams
  - allows you to set work timeouts
  - ability to stop calculations

You can already familiarize yourself with them in more detail and see examples of work in the documentation.


---
<!-- .slide: data-background="url('images/demo.jpg')" --> 
<!-- .slide: class="lab" -->
## Demo time!
Demo 2 Compute

---
<!-- .slide: data-background="url('images/lab2.jpg')" --> 
<!-- .slide: class="lab" -->
## Lab time!

