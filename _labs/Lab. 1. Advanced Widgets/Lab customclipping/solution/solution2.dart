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
        home: Material(
            child: Stack(
          children: [
            ListView(
              children: List.generate(
                  100, (index) => ListTile(title: Text("item $index"))),
            ),
             ClipWithShadow(
              child: Container(color: Colors.red),
              painter: MyPainter(),
              clipper: MyClipper(),
            )
          ],
        )));
  }
}

class ClipWithShadow extends StatelessWidget {
  final CustomPainter painter;
  final CustomClipper<Path> clipper;
  final Widget child;

  ClipWithShadow(
      {required this.clipper, required this.painter, required this.child});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CustomPaint(
        painter: painter,
        child: ClipPath(
          child: child,
          clipper: clipper,
        ));
  }
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..strokeWidth = 3
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..imageFilter = ImageFilter.blur(sigmaX: .9, sigmaY: .9);

    var path = Path();
    path.lineTo(0.0, 40);
    var firstControlPoint = Offset(size.width / 2, 150);
    var firstEndPoint = Offset(size.width, 40);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    throw UnimplementedError();
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, 40);
    var firstControlPoint = Offset(size.width / 2, 150);
    var firstEndPoint = Offset(size.width, 40);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return true;
  }
}
