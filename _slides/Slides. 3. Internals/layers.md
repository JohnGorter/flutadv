# Layer architecture

---
### Layer architecture
We are going to discuss
- widgets
- elements
- buildContext
- renderOject 
- bindings

---
### Introduction
Your application actually consists of: 
- a rendered screen of pixels
    - refreshed at 60fps normally
- external interactions
    - the device screen (e.g. finger on the glass)
    - the network (e.g. communication with a server)
    - the time (e.g. animations)
    - other external sensors

---
### Introduction
Flutter applications interact with the platform/os using
- Flutter engine
    - specific to platform/os
    https://github.com/flutter/engine/tree/6179c819926910d1c71882e884559a4f71bc18b0/shell/platform
    https://github.com/google/flutter-desktop-embedding/tree/master/testbed/windows/runner
- called Window
    - exposes APIs to communicate, indirectly, with the device

---
### Layers

Flutter Architecture (c) Flutter

<img height="500" src="/images/archi.png">

---
### Layers

- the Flutter application, using Dart, is the Flutter Framework (in green)
- the Flutter Engine (in blue), via an abstraction layer, is called Window 

The Flutter Engine notifies the Flutter Framework when
- an event of interest happens at the device level (orientation change, settings changes, memory issue, application running state…)
- some event happens at the glass level (= gesture)
- the platform channel sends some data
- when the Flutter Engine is ready to render a new frame

---
### Important takeaway

> Flutter Framework is driven by the Flutter Engine frame rendering

If you want a visual change to happen, or if you want some code to be executed based on a timer, you need to tell the Flutter Engine that something needs to be rendered.

Usually, at next refresh, the Flutter Engine will then request the Flutter Framework to 
- run some code 
- provide the new scene to render


---
### Basic flow of execution 
<img src="/images/flow.gif" />    

<a href="https://api.flutter.dev/flutter/widgets/WidgetsBinding/drawFrame.html">
https://api.flutter.dev/flutter/widgets/WidgetsBinding/drawFrame.html</a>


---
### Layers in code
You can hook into each layer 
- lowest layer is dart:ui
- middle layer are Flutter renderObjects
- upper layer is Flutter Widgets

---
<!-- .slide: data-background="url('images/demo.jpg')" --> 
<!-- .slide: class="lab" -->
## Demo time!
Demo. Exploring the layers  

---
### RenderView and RenderObject
The Flutter Framework converts Widgets into visual parts on the screen
- visual parts correspond to objects
- called RenderObjects
    - some area of the screen in terms of dimensions, position, geometry 
    - in terms of “rendered content”
    - identify zones of the screen potentially impacted by the gestures (= finger)

The set of all the RenderObjects is called Render Tree. 
At the top of that tree (= root) is a RenderView.

---
### The RenderView
The RenderView represents the total output surface of the Render Tree  
- is itself a special version of a RenderObject

<img height="300" src="/images/renderview.png">

More on this later..

---
### Bindings

On start of a Flutter application, the system invokes the main() method which will eventually call the runApp(Widget app) method
- Flutter Framework initializes the interfaces between the Flutter Framework and the Flutter Engine. 
- these are called bindings
- glue between the Flutter Engine and the Flutter Framework

---
### Bindings
Each Binding is responsible for handling a set of specific tasks, actions, events
- SchedulerBinding
- GestureBinding
- RendererBinding
- WidgetsBinding
- ServicesBinding: responsible for handling messages sent by the platform channel
- PaintingBinding: responsible for handling the image cache
- SemanticsBinding: reserved for later implementation of everything related to Semantics
- TestWidgetsFlutterBinding: used by widgets tests library

The WidgetsFlutterBinding is not really a binding but rather some kind of “binding initializer"

---
### Bindings
<img src="/images/bindings.png">

---
### Bindings interactions
Some bindings explained

SchedulerBinding
- tells the Flutter Engine: “Hey! next time you are not busy, wake me up so that I can work a bit and tell you either what to render or if I need you to call me again later…";
- listen and react to such “wake up calls” (see later)
- asks engine to schedule another frame

---
### Bindings interactions
When does the SchedulerBinding request for a wake-up call?
- when a Ticker needs to tick
- when a change applies to the layout

---
### Bindings interactions
GestureBinding
- listens to interactions with the Engine in terms of “finger” (= gesture)
- responsible for accepting data related to the finger and to determine which part(s) of the screen are impacted by the gestures and notifies these parts

---
### Bindings interactions
RendererBinding (the glue between the Flutter Engine and the Render Tree)
It has 2 distinct responsibilities
- listen to events, from the Engine, to inform about changes ofthe device settings that impact the visuals/semantics
- provide the Engine with the modifications to be applied to the display

To rendered on the screen, this binding drives the PipelineOwner and initializes the RenderView

---
### Bindings interactions
WidgetsBinding
- listens to changes applied by the user via the device settings that impact the language (= locale) and the semantics
- the glue between the Widgets and the Flutter Engine

It has 2 distinct main responsibilities:
- drive the process in charge of handling the Widgets structure changes
-  trigger the rendering

The handling of the Widgets Structure changes is done via the BuildOwner
- tracks which Widgets need rebuilding
- handles other tasks that apply to widget structures as a whole


---
### Widgets

Now lets talk about widgets!
They are: 
- immutable

```
@immutable
abstract class Widget extends DiagnosticableTree {
  const Widget({ this.key });
  final Key key;
  ...
}
```

Any variable in a Widget class has to be FINAL!

A Widget is a kind of constant configuration since it is IMMUTABLE

---
### The Widgets hierarchical structure
In Flutter, you define the structure of your screen(s), using Widgets…
```
Widget build(BuildContext context){
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
                title: Text('My title'),
            ),
            body: Container(
                child: Center(
                    child: Text('Centered Text'),
                ),
            ),
        ),
    );
}
```
This sample uses 7 Widgets, which together form a hierarchical structure

---
### Simplified Widgets Tree
This code forms the underlying tree


<img height="400" src="/images/tree.png">

Tree with SafeArea as the root of the tree

---
### The forest behind the tree
This tree actually resolves into this tree


<img src="/images/tree2.png" height="400">


Actually this is not a “Widget tree” a “tree of Elements”


---
### What is an element
To each widget corresponds one element
- elements are linked to each other and form a tree
- an element is a reference of something in the tree

<img src="/images/element.png" height="200"/>

Elements point to one Widget and may also point to a RenderObject

The Element points to the Widget which created the element !

---
### Recap
So
- there is no Widget tree but a tree of Elements
- elements are created by the Widgets
- an element references the Widget that created it
- elements are linked together with the parent relationship
- elements could have a child or children
- elements could also point to a RenderObject
- elements define how parts of the visuals are linked to each other


---
### Elements visualised
<img src="/images/tree3.png" height="500">

---
### The 3 trees
There are 3 conceptual trees
- the elements tree is the actual link between the Widgets and the RenderObjects

Why?
- Because not all elements have a widget and not all elements are renderObjects

---
### Widget categories
3 main categories of Widgets
- proxies
    - hold some piece of information which needs to be made available to the Widgets
    - typical example of such Widgets is the InheritedWidget
    - do not directly take part of the User Interface but are used by others to fetch the information they can provide
- renderers
    - have a direct involvement with the layout of the screen 
    - typical examples are Row, Column, Stack,Padding, Align, Opacity, RawImage…
- components
    - the other Widgets 
    - typical examples are RaisedButton, Scaffold, Text, GestureDetector, Container…

---
### Widget categories
Depending on the Widget category, a corresponding Element type is associated

---
### Element types
Here are the different element types
- componentElement
    - these elements do not directly correspond to any visual rendering part
- renderObjectElement
    - elements that correspond to a part of the rendered screen

---
### Element types
<img src="/images/elementtypes.png" height="500">

---
### How do Widgets and Elements work together?
In Flutter, the whole mechanics relies on invalidating either 
- an element or a renderObject

Invalidating an element can be done in different ways
- by using setState, which invalidates the whole StatefulElement
- via notifications, handled by other proxyElement (such as InheritedWidget) which invalidates any element that depends on that proxyElement

Whatever the type of invalidation, when this happens, the SchedulerBinding is requested to ask the Flutter Engine to schedule a new frame.

It is when the Flutter Engine wakes up the SchedulerBinding that all the magics happens…

---
### onDrawFrame
The partial sequence diagram below shows what happens when the SchedulerBinding receives a request onDrawFrame() from the Flutter Engine

<img src="/images/ondrawframe.png" height="400">

---
### onDrawFrame
What happens:
- the WidgetsBinding is invoked and considers the changes related to the elements
- the WidgetsBinding invokes the buildScope method of the buildOwner
- buildOwner iterates the list of invalidated elements and requests them to rebuild
- the WidgetsBinding invokes the drawFrame to render the frame

Lets look into the rebuild phase

---
### Rebuilding the element tree
The main principles of this rebuild() method are:
- invoking the build() method of the widget referenced by that element 
    - build() method returns a new widget.
- if the element has no child, the new widget is inflated, otherwise
the new widget is compared to the one referenced by the child of the element

- if they could be exchanged (=same widget type and key), the update is made, the child element is kept
- if they could not be exchanged, the child element is unmounted (~ discarded) and the new widget is inflated


Lets look at an animation

---
### rebuilding the element tree
This is what happens in the rebuild step
<img src="/images/ondrawframe2.gif" height="400">

---
### Widget inflate mapping

When the widget is inflated, it is requested to create a new element of a certain type, defined by the widget category.
- InheritedWidget renders InheritedElement
- StatefulWidget renders StatefulElement
- StatelessWidget renders StatelessElement
- InheritedModel renders InheritedModelElement
- InheritedNotifier renders InheritedNotifierElement
- LeafRenderObjectWidget renders LeafRenderObjectElement
- SingleChildRenderObjectWidget renders SingleChildRenderObjectElement
- MultiChildRenderObjectWidget renders MultiChildRenderObjectElement
- ParentDataWidget renders ParentDataElement

Each of these element types has a distinct behavior


---
### Examples of specific tasks per Element Type

- a StatefulElement will invoke the widget.createState() method at initialization, which will create the State and link it to the element

- a RenderObjectElement type will create a RenderObject when the element will be mounted, this renderObject will be added to the render tree and linked to the element

---
### RenderObjects drawFrame
After rebuild, the rendering process starts
- the WidgetsBinding invokes the drawFrame method of the RendererBinding

<img src="/images/drawframerender.png" height="400">

---
### RenderObjects drawFrame
During this step, the following activities are performed
- each renderObject marked as dirty is requested to perform its layout
- each renderObject marked as needs paint is repainted, using the renderObject’s layer.
- the resulting scene is built and sent to the Flutter Engine 

At the end of this flow of actions, the device screen is updated

---
### Gesture handling
The gestures are handled by the GestureBinding

The Flutter Engine sends information related to a gesture-related event, through the window.onPointerDataPacket API, the GestureBinding intercepts it and
- converts the coordinates to match the device pixel ratio
- requests the renderView to provide a list of RenderObjects which cover a part of screen containing the coordinates of the event
- iterates that list of renderObjects and dispatches the related event to each of them

When a renderObject is waiting for this kind of event, it processes it


---
### Animations
In Flutter, everything which is related to animation refers to the notion of Ticker.

A Ticker does only one thing, when active
- it requests the SchedulerBinding to register a callback and ask the Flutter Engine to wake it up when next available

When the Flutter Engine is ready
- it then invokes the SchedulerBinding via a request: “onBeginFrame"
- the SchedulerBinding intercepts this request, iterates ticker callbacks and invokes them

If the animation is complete, the ticker is “disabled", otherwise, the ticker requests the SchedulerBinding to schedule another callback. And so on…

---
### BuildContext
The BuildContext is an interface that 
- defines getters and methods that could be implemented by an element
- is mainly used in the build() method of a StatelessWidget and StatefulWidget or in a StatefulWidget State object

The BuildContext is the Element itself which corresponds to 
- the Widget being rebuilt 
- the StatefulWidget linked to the State where you are referencing the context variable

---
### How useful the BuildContext can be?
The BuildContext corresponds to 
- the element related to the widget 
- a location of the widget in the tree

very useful to:
- obtain the reference of the RenderObject that corresponds to the widget 
- obtain the size of the RenderObject
- visit the tree (e.g. MediaQuery.of(context), Theme.of(context)…)

---
###  Just for the fun…
The following totally useless code makes possible for a StatelessWidget to update itself (as if it was a StatefulWidget but without using any setState()), by using the BuildContext …

```
void main(){
    runApp(MaterialApp(home: TestPage(),));
}

class TestPage extends StatelessWidget {
    // final because a Widget is immutable (remember?)
    final bag = {"first": true};

    @override
    Widget build(BuildContext context){
        return Scaffold(
            appBar: AppBar(title: Text('Stateless ??')),
            body: Container(
                child: Center(
                    child: GestureDetector(
                        child: Container(
                            width: 50.0,
                            height: 50.0,
                            color: bag["first"] ? Colors.red : Colors.blue,
                        ),
                        onTap: (){
                            bag["first"] = !bag["first"];
                            //
                            // This is the trick
                            //
                            (context as Element).markNeedsBuild();
                        }
                    ),
                ),
            ),
        );
    }
}
```

---
###  Just for the fun…

When you are invoking the setState() method, the latter ends up doing the very same thing
``` 
_element.markNeedsBuild().
```

---
<!-- .slide: data-background="url('images/demo.jpg')" --> 
<!-- .slide: class="lab" -->
## Demo time!
Demo. Exploring the layers
