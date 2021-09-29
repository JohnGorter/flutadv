# Lab CustomRenderBox

---
### Time
Time: 30 minutes


--
### Setup
Create a brand new flutter application and use the main.dart in your IDE.

---
### Gap RenderBox
Regurlaly we use SizedBoxes to create gaps between widgets in Rows and Columns. You can use SizedBoxes for that, but then you need to specify the width or the height depending on whether we are inside a Column or a Row. If you switch from Column to a Row, you have to change the SizedBox height to width and vice versa.

This is not very productive so we can create our own RenderObject for that. 
Lets call this widget a Gap. 

The idea is that you can use the Gap like this:
```
...
Column( children: [Container(height:50, width:50), Gap(30), Container(height:50, width:50)]),
...
```
and when switched to a Row, it is just a change to Row:
```
...
Row( children: [Container(height:50, width:50), Gap(30), Container(height:50, width:50)]),
...
```

Note that we dont have to change the Gap, it changes accordingly
Note that Gap inspects it's parent element to know what the Gap should do

---
### Exercise 1. Make a RenderBox 

Create a new flutter application using the command
```
flutter create gap_excercise
```

Make a class called _RenderGap that derives from RenderBox and 
overrides the performLayout method. This method manipulates the size field.

We have to constrain the size its height when we are in an horizontal flex parent, like a Column, we have to constrain the size its width when we are in a vertical flex parent, like a Row.

The gapsize should be provided as a constructor argument. 

An example of this class is given below:

```
class _RenderGap extends RenderBox {
  _RenderGap({
    required double mainAxisExtent,
  }) : _mainAxisExtent = mainAxisExtent;

  double get mainAxisExtent => _mainAxisExtent;
  double _mainAxisExtent;
  set mainAxisExtent(double value) {
    if (_mainAxisExtent != value) {
      _mainAxisExtent = value;
      markNeedsLayout();
    }
  }

  @override
  void performLayout() {
    final AbstractNode flex = parent!;
    if (flex is RenderFlex) {
      if (flex.direction == Axis.horizontal) {
        size = constraints.constrain(Size(mainAxisExtent, 0));
      } else {
        size = constraints.constrain(Size(0, mainAxisExtent));
      }
    } else {
      throw FlutterError(
        'A Gap widget must be placed directly inside a Flex widget',
      );
    }
  }
}
```

---
### Exercise 2. Make a LeafRenderObjectWidget
Create a Gap widget that derives from LeafRenderObjectWidget. 
Override and implement the createRenderObject and the updateRenderObject
methods. 

An example of this widget is given below:

```
class Gap extends LeafRenderObjectWidget {
  const Gap(
    this.mainAxisExtent, {
    Key? key,
  })  : assert(
            mainAxisExtent >= 0 &&
            mainAxisExtent < double.infinity),
        super(key: key);

  final double mainAxisExtent;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderGap(mainAxisExtent: mainAxisExtent);
  }

  @override
  void updateRenderObject(BuildContext context, _RenderGap renderObject) {
    renderObject.mainAxisExtent = mainAxisExtent;
  }
}
```

---
### Exercise 3. Use the Gap widget
Try the Gap widget in your application and test its correct workings.