# Zooming into RenderObjects

---
### Lets explore a well known widget
The Opacity Widget
- it only accepts one child. 
- there is only one parameter called opacity which is a value between 0.0 and 1.0

---
### SingleChildRenderObjectWidget
The Opacity is a SingleChildRenderObjectWidget

The hierarchy of extension class extensions goes like this:
```
Opacity → SingleChildRenderObjectWidget → RenderObjectWidget → Widget
```
In contrast, the StatelessWidget and StatefulWidget goes as follows
```
StatelessWidget/StatefulWidget → Widget
```

Stateless/StatefulWidget only compose widgets while the Opacity widget actually changes how it is drawn

---
### Widgets do not paint 

A widget only holds the configuration information. 

In this case, the opacity widget is only holding the opacity value

You can create new widget every time the build function is called, they are not expensive to construct

---
### The Rendering
Rendering is done inside the RenderObjects

The RenderObject is responsible for rendering

The Opacity widget creates and updates a RenderObject with these methods
```
@override
RenderOpacity createRenderObject(BuildContext context) => new RenderOpacity(opacity: opacity);

@override
void updateRenderObject(BuildContext context, RenderOpacity renderObject) {
  renderObject.opacity = opacity;
}
```

---
### RenderOpacity
The RenderOpacity needs to implement all the methods (for example performing layout/ hit testing/ computing sizes) and ask its child to do the actual work.

Therefore RenderOpacity extends the RenderProxyBox and adds
```
double get opacity => _opacity;
double _opacity;
set opacity(double value) {
  _opacity = value;
  markNeedsPaint();
}

@override
void paint(PaintingContext context, Offset offset) {
    context.pushOpacity(offset, _alpha, super.paint);
}
```

The PaintingContext is basically a fancy canvas with method called pushOpacity

---
### Recap
- the Opacity is not a StatelessWidget or a StatefulWidget but instead a SingleChildRenderObjectWidget
- the Widget only holds information which the renderer can use
- the RenderOpacity, which extends the RenderProxyBox does the actual layouting/ rendering 
- because the opacity behaves exactly as its child it delegates every method call
- it overrides the paint method and calls pushOpacity which adds the desired opacity to the widget.

But where is the Element here?

---
### How about elements
- the widget is only a configuration 
- the RenderObject only manages layout/rendering etc

Flutter recreates widgets all the time, when the build() methods gets called. This build method is called every time something changes. 

Flutter can’t rebuild the whole sub tree every time
Flutter wants to update the tree whenever possible

---
### Introducing the Element
The element is a concrete widget in the big tree

Remember:
- the first time when a widget is created, it is inflated to an Element
- the element then gets inserted it into the tree

- If the widget later changes, it is compared to the old widget and the element updates accordingly
- the element doesn’t get rebuilt, it only gets updated

Where is the element created in the opacity example?

---
### The missing Element

The SingleChildRenderObjectWidget creates it
```
@override
SingleChildRenderObjectElement createElement() => new SingleChildRenderObjectElement(this);
```

And the SingleChildRenderObjectElement is just an Element which has single child

The element creates the RenderObject, but in our case the Opacity widget creates its own RenderObject?

---
### The missing Element
This is just convenience API. 

Because more often then not, the widget needs a RenderObject but no custom Element.

The SingleChildRenderObjectElement gets a reference to the RenderObjectWidget 
- which has the methods to create a RenderObject
```
SingleChildRenderObjectElement(SingleChildRenderObjectWidget widget) : super(widget);
```

---
### The missing Element

The mount method is the place where the element gets inserted into the element tree, and here the magic happens (RenderObjectElement class)
```
@override
void mount(Element parent, dynamic newSlot) {
  super.mount(parent, newSlot);
  _renderObject = widget.createRenderObject(this); <--
  attachRenderObject(newSlot);
  _dirty = false;
}
```

Only once (when it get’s mounted) it asks the widget “Please give me the renderobject you’d like to use so I can save it”.

---
<!-- .slide: data-background="url('images/demo.jpg')" --> 
<!-- .slide: class="lab" -->
## Demo time!
Demo. Custom RenderObject

---
<!-- .slide: data-background="url('images/lab2.jpg')" --> 
<!-- .slide: class="lab" -->
## Lab time!