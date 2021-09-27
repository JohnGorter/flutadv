import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        builder: (BuildContext context, Widget? widget) {
          ErrorWidget.builder = (details) => Material(
              child: Text("You used the wrong code here dude!!! $details"));
          return widget!;
        },
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: Stack(children: [
          Container(color: Colors.red),
          Positioned(
              left: 10, top: 10, height: 100, width: 100, child: TestEx())
        ]));
  }
}

class TestEx extends StatelessWidget {
  doStuff() /* async */ {
    // this does not work!!
    // try {
    //   print("a");
    //   Future.delayed(Duration(seconds: 10)).then((_) {
    //     print("b");
    //     throw "Exception in the future";
    //   });
    //   print("c");
    // } catch (error) {
    //   print("try catch works??");
    // }

    // this works with zones!
    // runZonedGuarded(() {
    //   print("a");
    //     Future.delayed(Duration(seconds: 10)).then((_) {
    //       print("b");
    //       throw "Exception in the future";
    //     });
    //      print("c");
    // }, (error, stack) {
    //   print("john $error $stack");
    // });

    // best option!!
    // try {
    //   print("a");
    //   await Future.delayed(Duration(seconds: 10));
    //   print("b");
    //   throw "Exception in the future";
    //   print("c");
    // } catch (error) {
    //   print("try catch works??");
    // }
  }

  @override
  Widget build(BuildContext context) {
    // Demo 1. Show a custom BuildError Widget
    throw UnimplementedError("NOO!");
    
    // Demo 2. Do something async that crashes!!
    // return TextButton(
    //     onPressed: () {
    //       doStuff();
    //     },
    //     child: Text("Do something stupid"));
  }
}
