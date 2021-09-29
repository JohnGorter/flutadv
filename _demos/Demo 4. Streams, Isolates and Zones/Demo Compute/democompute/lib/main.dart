import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

bool doSomethingExpensive(int data) {
  print("Start");
  print("process [${Isolate.current.debugName}]: working... $pid");
  int i = data;
  while (true) {
    i++;
    sleep(Duration(microseconds: 1));
    if (i > 100000) {
      print("Done $i");
      i = 0;
      return true;
    }
  }
}

class _MyAppState extends State<MyApp> {
  int color = 0;

  @override
  void initState() {
    super.initState();
    // simulate a very expensive operation
    // doSomethingExpensive(0);
    compute(doSomethingExpensive, 0);

    Timer.periodic(Duration(milliseconds: 500), (_) {
      setState(() {
        color++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print("process [${Isolate.current.debugName}]: building...  $pid ");
    return Container(
        color: [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.yellow
    ][color % 4]);
  }
}
