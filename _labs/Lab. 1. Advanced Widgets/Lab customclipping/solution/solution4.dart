import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  int i = 0;
  runApp(new MaterialApp(
      home: new SafeArea(
        child: new Stack(
          children: <Widget>[
            new GestureDetector(
              onTap: () {
                print("Tapped! ${i++}");
              },
              child: new Container(
                color: Colors.white,
                child: new Center(
                  child: new Container(
                    width: 400.0,
                    height: 300.0,
                    color: Colors.red.shade100,
                  ),
                ),
              ),
            ),
            new IgnorePointer(
              child: new ClipPath(
                clipper: new InvertedCircleClipper(),
                child: new Container(
                  color: new Color.fromRGBO(0, 0, 0, 0.5),
                ),
              ),
            )
          ],
        ),
      ),
    ));
}

class InvertedCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return new Path()
      ..addOval(new Rect.fromCircle(
          center: new Offset(size.width / 2, size.height / 2),
          radius: size.width * 0.45))
      ..addRect(new Rect.fromLTWH(0.0, 0.0, size.width, size.height))
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}