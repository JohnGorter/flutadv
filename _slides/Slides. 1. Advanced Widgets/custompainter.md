# Custom Painter

---
### What is Custom Painter

A widget that gives you access to low level drawing

Every OS has 2d drawing support, some frameworks do to!


---
### How to use a Custom Painter
```
import 'dart:ui';

...
      home: MyPainter(),  // <--
...
  }
}
```

Here is a MaterialApp containing MyPainter widget as the home


---
### How to use a Custom Painter
```
// main.dart

class MyPainter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lines'),
      ),
      body: CustomPaint(         // <--
        painter: ShapePainter(),
        child: Container(),
      ),
    );
  }
}
```

---
### CustomPaint properties
CustomPaint has the following important properties
- painter -> the painter that paints before the child
- foregroundPainter -> the painter that paints after the child
- child -> by default, the canvas will take the size of the child, if it is defined
- size -> if the child is not defined, then the size of the canvas should be specified


---
### Implement the ShapePainter
Now, you have to define the ShapePainter widget, which should extend the CustomPainter class.

Two methods must be implemented
- paint -> this method is called whenever the object needs to be repainted
- shouldRepaint -> this method is called when a new instance of the class is provided

```
class ShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return null;
  }
}
```

---
### Implement the ShapePainter
Inside the paint method, you have these parameters:
- canvas
- size

If we have a child specified inside the CustomPaint widget, then the canvas will have the same size as that child. In our case, the canvas area will take the size of the entire Container.

---
### The Canvas Area
It is crucial to understand the coordinate system used by the canvas in order to draw anything on it.

- the origin (0, 0) is located at the top-left corner of the canvas. 

All drawings are done in relation to the origin, as that is where the painter starts.

---
### The Canvas Drawings
The code for drawing 
```
// main.dart

// FOR PAINTING LINES
class ShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.teal
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    Offset startingPoint = Offset(0, size.height / 2);
    Offset endingPoint = Offset(size.width, size.height / 2);

    canvas.drawLine(startingPoint, endingPoint, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
```
---
### The Canvas Drawings Alternative

There is also another method you can follow for drawing a line using
```
// main.dart

// FOR PAINTING LINES
class ShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.teal
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    var path = Path();
    path.moveTo(0, size.height / 2);
    path.lineTo(size.width, size.height / 2);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
```
We use paths here so we can use moveTo and lineTo style paintings.

---
### More shapes
Of course you can also draw:
- circles
- polygons
- .. more

---
<!-- .slide: data-background="url('images/demo.jpg')" --> 
<!-- .slide: class="lab" -->
## Demo time!
Demo. CustomPainting

---
### Animations

Animations can be easily added 

Let’s animate the rotation of the little star

---
### Animations
Just follow the steps below for animating the rotation of the polygon with these steps
- convert the MyPainter Widget to a StatefulWidget
- extend it from TickerProviderStateMixin
- define variables, animation and controller
    - IntTween tween;
    - Animation<int> animation;
    - AnimationController controller;
- initialize tween, controller and animation variable inside the initState
- call controller.forward() or controller.repeat()
- pass the animation value in place of the radians to get the animation effect

---
### Animation
```
@override
void initState() {
  super.initState();
  tween = IntTween(begin:0, end:360);
  controller = AnimationController(
    vsync: this,
    duration: Duration(seconds: 4),
  );
  animation = tween.animate(controller)
    ..addListener(() {
      setState(() {});
    })
  controller.repeat();
}
```

---
### Animation
Then just pass the animation value 

```
Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationZ(animation.value * (Math.pi / 180)),
      child:CustomPaint(
      painter: StarPainter(),
      size: Size(200, 200),
    ));
  }
```

---
<!-- .slide: data-background="url('images/demo.jpg')" --> 
<!-- .slide: class="lab" -->
## Demo time!
Demo. Animations

---
<!-- .slide: data-background="url('images/lab2.jpg')" --> 
<!-- .slide: class="lab" -->
## Lab time!
