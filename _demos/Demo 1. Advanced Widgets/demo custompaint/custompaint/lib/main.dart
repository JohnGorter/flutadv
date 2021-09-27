import 'package:flutter/material.dart';
import 'dart:math' as Math;

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
        home: MyCustomPaint());
  }
}

class MyCustomPaint extends StatefulWidget {
  @override
  _MyCustomPaintState createState() => _MyCustomPaintState();
}

class _MyCustomPaintState extends State<MyCustomPaint>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Tween<int> _tween;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _tween = IntTween(begin: 0, end: 360);
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 4));
    _animation = _tween.animate(_controller);
    _animation.addListener(() {
      setState(() {});
    });
    _controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationZ(_animation.value * (Math.pi / 180)),
      child:CustomPaint(
      painter: StarPainter(),
      size: Size(200, 200),
    ));
  }
}

class StarPainter extends CustomPainter {
  StarPainter();

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path()
      ..moveTo(0, size.height / 3)
      ..lineTo(size.width / 3, size.height / 3)
      ..lineTo(size.width / 2, 0)
      ..lineTo((size.width / 3) * 2, size.height / 3)
      ..lineTo(size.width, size.height / 3)
      ..lineTo((size.width / 5) * 4, (size.height / 5) * 3)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width / 2, (size.height / 5) * 4)
      ..lineTo(0, size.height)
      ..lineTo(size.width / 5, (size.height / 5) * 3)
      ..lineTo(0, size.height / 3)
      ..close();

    Paint paint = Paint()
      ..strokeWidth = 2
      ..style = PaintingStyle.fill
      ..color = Colors.red;
   
   
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
