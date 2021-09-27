import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        home: Center(
            child:
                ChatBubble(color: Colors.blue, text: "test", arrowLeft: true)));
  }
}

class ChatBubble extends StatelessWidget {
  final bool arrowLeft;
  final String text;
  final Color color;
  ChatBubble(
      {required this.text, required this.arrowLeft, required this.color});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
        child: Material(
            color: color,
            child: Container(
                padding:
                    EdgeInsets.only(top: 15, bottom: 30, left: 20, right: 20),
                child: Text(text))),
        clipper: ChatBubbleClipper(arrowLeft: arrowLeft));
  }
}

class ChatBubbleClipper extends CustomClipper<Path> {
  late bool arrowLeft;

  ChatBubbleClipper({bool arrowLeft = false}) {
    this.arrowLeft = arrowLeft;
  }

  @override
  Path getClip(Size size) {
    var path = Path();
    if (!this.arrowLeft) {
      path.moveTo(0.0, size.height * 0.20);
      path.lineTo(0.0, size.height * 0.60);
      path.quadraticBezierTo(0, size.height * 0.80, 15, size.height * 0.80);
      path.lineTo(size.width - 20, size.height * 0.80);
      path.quadraticBezierTo(
          size.width - 10, size.height - 10, size.width, size.height);
      path.quadraticBezierTo(
          size.width - 10, size.height * 0.90, size.width - 10, 15.0);
      path.quadraticBezierTo(size.width - 12, 0.0, size.width - 30, 0.0);
      path.lineTo(15.0, 0.0);
      path.quadraticBezierTo(0.0, 0.0, 0.0, size.height * 0.20);
    } else {
      path.moveTo(0.0, size.height * 0.20);
      path.lineTo(0.0, size.height * 0.60);
      path.quadraticBezierTo(0, size.height * 0.80, 5, size.height * 0.80);
      path.quadraticBezierTo(10, size.height - 10, 0, size.height);
      path.quadraticBezierTo(10, size.height * 0.90, 15, size.height * 0.80);
      path.lineTo(size.width - 20, size.height * 0.80);
      path.quadraticBezierTo(
          0, size.height * 0.80, size.width - 20, size.height * 0.60);
      path.lineTo(size.width, size.height - 20);
      path.quadraticBezierTo(0.0, 0.0, 0.0, size.height * 0.20);
    }
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return true;
  }
}
