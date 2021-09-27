
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
class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
 AnimationController? rotationController;
 Animation<double>? animation;
 List<int> results = [];
 @override
 void initState() {
   super.initState();
   rotationController = AnimationController(
     duration: const Duration(seconds: 5),
     vsync: this,
   )..addListener(() => setState(() {}));
   animation = Tween(begin: 0.0, end: 1.0).animate(rotationController!);
   rotationController?.forward(from: 0.0);
   //loop the animation for clarity
   animation?.addStatusListener((status) {
     if (status == AnimationStatus.completed) {
       rotationController?.repeat();
     }
   });
 }
 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text("Isolate Demo"),
     ),
     body: Column(
       children: [
         SizedBox(
           height: 100,
         ),
         Center(
           child: RotationTransition(
             turns: animation!,
             child: Container(
               width: 200,
               height: 200,
               color: Colors.orange,
             ),
           ),
         ),
         SizedBox(
           height: 100,
         ),
         RaisedButton(
           onPressed: () {
             // Step 2. your code here...
           },
           child: Text("fib(40) in main thread"),
         ),
         RaisedButton(
           onPressed: () async {
             // Step 3. your code here...
           },
           child: Text("fib(40) in isolate"),
         ),
         Text("Number of results: ${results.length.toString()}")
       ],
     ),
   );
 }
}
int fib(int n) {
 // step1. your code here
}
