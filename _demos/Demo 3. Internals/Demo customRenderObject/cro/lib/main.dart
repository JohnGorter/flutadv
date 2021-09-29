import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
          // changing the primarySwatch below to Colors.green an±d then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: MyOpacity(
          opacity: 0.1,
          child: Container(child: Text("hello world")),
        ));
  }
}

class MyOpacityRenderObject extends RenderProxyBox {
  double _opacity = 0;

  MyOpacityRenderObject({required double opacity}) {
    _opacity = opacity;
  }

  set opacity(double val) {
    _opacity = val;
    markNeedsPaint();
  }

  double get opacity => _opacity;

  @override
  void paint(PaintingContext context, Offset offset) {
    context.canvas.drawRect(
        Rect.fromLTWH(10, 10, size.width - 20, size.height - 20),
        Paint()
          ..color = Colors.red
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke);
    context.pushOpacity(offset, (255 * _opacity).toInt(), super.paint);
  }
}



class MyOpacity extends SingleChildRenderObjectWidget {
  final double opacity;

  MyOpacity({required this.opacity, child}) : super(child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return MyOpacityRenderObject(opacity: opacity);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant MyOpacityRenderObject renderObject) {
    renderObject.opacity = opacity;
  }
}
