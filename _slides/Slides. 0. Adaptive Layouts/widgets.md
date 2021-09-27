# Widgets

---
### Widgets

<img src="/images/widgets.png">

---
<img src="/images/widgets2.png">



---
### Widget kinds
- Stateless Widgets
    - Immutable widgets
    - build override
- Statefull Widgets
    - Mutable Statefull Objects
    - createState override
- Inherted Widgets
    - Prevent state chaining
    - MediaQuery/Navigator/Theme and more
    - Widget.of(context).currentState..


---
### Stateless Widgets

Simpelest widget, only contains builder logic
Examples:
    - Center
    - Padding
    - Container
    - ListView
    - Grid
    - much much more...

You will write your own

---
### Stateless Widget example
```
class MyWidget extends StatelessWidget {
    @override
    Widget build (BuildContext context){
        return Container();
    }
}
```
---
<!-- .slide: data-background="url('images/demo.jpg')" --> 
<!-- .slide: class="lab" -->
## Demo time!
Demo 1. Stateless Widgets

---
### Statefull Widgets

Widgets with a state counterpart
- Widget gets recreated and remains immutable, 
  the associated State object remains and is mutable
- Widget overrides the createState which
  creates the associated State object
- StateClass overrides the build function 
- setState
    - changes the state
    - rebuilds the widget
- initState initializes the state of the State Object

---
### Statefull Widget example

```
class Bird extends StatefulWidget {
  const Bird({
    Key key, this.color: const Color(0xFFFFE306), this.child,
  }) : super(key: key);
  final Color color;
  final Widget child;
  _BirdState createState() => new _BirdState();
}

class _BirdState extends State<Bird> {
  double _size = 1.0;
  void grow() { setState(() { _size += 0.1; }); }

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: widget.color,
      transform: new Matrix4.diagonal3Values(_size, _size, 1.0),
      child: widget.child,
    );
  }
}
```

---
<!-- .slide: data-background="url('images/demo.jpg')" --> 
<!-- .slide: class="lab" -->
## Demo time!
Demo 2. Statefull Widgets

---
### GlobalKeys
GlobalKeys 
- can be used to address widgets in the current level.
- points to widget
- currentState returns associated StateObject

GlobalKeys give access to StateObject API

---
### GlobalKey Example
```
class AppWidget extends StatefulWidget {
	@override State createState() => AppWidgetState();
}

class AppWidgetState extends State<AppWidget> {
	GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

	Widget build(BuildContext context) {
		return MaterialApp(
			home: Scaffold(
				key: _scaffoldKey,
				appBar: AppBar( title: Text('Title'), ),
				drawer: Drawer( child: Center( child: Text('Drawer'), ),),
				body: Center( child: Text('Body'), ),
	,),);}}
``` 

---
<!-- .slide: data-background="url('images/demo.jpg')" --> 
<!-- .slide: class="lab" -->
## Demo time!
Demo 3. GlobalKeys

---
### Inherited Widgets

Data and manipulation API can become unmanagable
- Each Widget passes state further down the tree
- What if a child moves to another subtree?

Answer: Inherited Widgets

---
### Inherited Widgets
Inherited widgets can be queried for
- upward search to correct widget
- returns immutable inherited wiget

How can inherited widgets contain state if they are immutable?

---
### Inherited Widget
Inherited widgets
- Widgets that inherit from InheritedWidget
- Holds immutable field to Stateful widget
- Statefullwidget can contain state and API

---
### Inherited Widget

App
    - AppStatefullWidget  -> State
        - AppStateInheritedWidget
            - Other widgets... can refer to state..

---
### Inherited Widget
You can obtain inherited widgets using
```
  MyInheritedWidget.of(context).currentState...
```
Used quite a lot in Flutter.

---
<!-- .slide: data-background="url('images/demo.jpg')" --> 
<!-- .slide: class="lab" -->
## Demo time!
Demo 4. Inherited Widgets

---
### Navigator Widget
Nagivator widget is used for routing
- Navigator.of(context).push()/pushNamed
- MaterialPageRoute
    - has a builder constructor parameter
    - used to pass state to next page

---
<!-- .slide: data-background="url('images/demo.jpg')" --> 
<!-- .slide: class="lab" -->
## Demo time!
Demo 5. Routing

---
<!-- .slide: data-background="url('images/lab2.jpg')" --> 
<!-- .slide: class="lab" -->
## Lab time!
