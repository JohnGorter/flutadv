# Custom Clipper

Make beautiful cut-outs

---
### What is Clipper
A custom clipper can be used to clip the widget into any desired shape

Built-in clippers 
- ClipOval -> creates an oval using the widget’s bounding box
- ClipRect -> clip a rectangular area
- ClipRRect -> clip the image with rounded corners
- ClipPath -> uses a custom clipper we can implement

---
### Custom clipping
Suppose if you want to implement shape like a star...

Let’s move to the coding part :
```
ClipPath(
   clipper: StarClipper(), // <--
   child: Container();
 )
```

---
### Custom clipping
To make your custom clip, make your own class that extends CustomClipper and 
override two methods
- getClip(): returns a path 
- shouldReclip(): returns a boolean if your widget needs to be reclipped or not

```
class CustomClipperImage extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    var path = Path();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return bool;
  } 
```

---
### Making the shape
We know these methods from the painter:

- MoveTo :
```
path.moveTo(x, y);
```
- LineTo :
```
path.lineTo(x,y);
```
- quadraticBeizerTo: (clip your widget with a curve).
```
var controlPoint = Offset(x, y);
var endPoint = Offset(x,y);
path.quadraticBezierTo(controlPoint.dx, controlPoint.dy,
    endPoint.dx, endPoint.dy);
```

---
<!-- .slide: data-background="url('images/demo.jpg')" --> 
<!-- .slide: class="lab" -->
## Demo time!
Demo. Clipping

---
### ShapeBorder

If you want to have a shadow below the clipped shape, instead of
painting your own shadow, you can use the custom ShapeBorder!

```
Container(
  height: 370,
  decoration: ShapeDecoration(
    color: Colors.blue,
    shape: AppBarBorder(),
    /// You can also specify some neat shadows to cast on widgets scrolling under this one
    shadows: [
      BoxShadow(
        color: Colors.black.withOpacity(0.7),
        blurRadius: 18.0,
        spreadRadius: 2.0,
      ),
    ],
  ),
),

class AppBarBorder extends ShapeBorder {
  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    Offset controllPoint1 = Offset(0, rect.size.height - 100);
    Offset endPoint1 = Offset(100, rect.size.height - 100);
    Offset controllPoint2 = Offset(rect.size.width, rect.size.height - 100);
    Offset endPoint2 = Offset(rect.size.width, rect.size.height - 200);
    
    return Path()
      ..lineTo(0, rect.size.height)
      ..quadraticBezierTo(
          controllPoint1.dx, controllPoint1.dy, endPoint1.dx, endPoint1.dy)
      ..lineTo(rect.size.width - 100, rect.size.height - 100)
      ..quadraticBezierTo(
          controllPoint2.dx, controllPoint2.dy, endPoint2.dx, endPoint2.dy)
      ..lineTo(rect.size.width, 0);
  }

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.only(bottom: 0);

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) => null;

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}
```

---
<!-- .slide: data-background="url('images/lab2.jpg')" --> 
<!-- .slide: class="lab" -->
## Lab time!
