# Slivers

---
### Slivers

> A portion of a scrollable area that you can define to behave in a special way. You can use slivers to achieve custom scrolling effects, such as elastic scrolling.

---
### When to use Slivers
You can kind of think of Slivers as a lower-level interface, providing finer-grained control on implementing scrollable area. 

Slivers can be 
- lazily build each item just as it scrolls into view
- unlimited scrolling

---
### When to use Slivers
Additional scrolling behavior
- disappearing AppBar as you scroll, changing size or color as you scroll
- scrolling lists of items and grids of items as one unit
- weird collapsing list with headers 

---
### How do I use Slivers
All sliver components go inside a CustomScrollView 

The rest is up to you for how to combine your list of slivers to make your custom scrollable area

> You can reinvent a ListView by putting a SliverList inside a CustomScrollView and set nothing else

---
### SliverList
SliverList takes a delegate parameter which provides the items in the list as they scroll into view. 

You can specify children with a 
- SliverChildListDelegate -> the actual list
- SliverChildBuilderDelegate -> build them lazily 

---
### SliverChildListDelegate
```
// Explicit list of children. No efficiency savings here since the
// children are already constructed.
SliverList(
    delegate: SliverChildListDelegate(
      [
        Container(color: Colors.red, height: 150.0),
        Container(color: Colors.purple, height: 150.0),
        Container(color: Colors.green, height: 150.0),
      ],
    ),
);
```

---
### SliverChildBuilderDelegate
```
// This builds an infinite scrollable list of differently colored 
// Containers.
SliverList(
    delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
      // To convert this infinite list to a list with three items,
      // uncomment the following line:
      // if (index > 3) return null;
      return Container(color: getRandomColor(), height: 150.0);
    },
    // Or, uncomment the following line:
    // childCount: 3,
  ),
);
```

---
### SliverGrid
SliverGrids also can specify children with a delegate, or an explicit list, just like SliverList. 

Has additional formatting for the cross-axis dimension on a grid.

---
### SliverGrid

There are three ways to specify how you want your grid layout
- count constructor to count how many items are, in this case, 
```
SliverGrid.count(children: scrollItems, crossAxisCount: 4)
```
- extent constructor to specify the maximum width of items to determine how many should fit across a grid
```
SliverGrid.extent(children: scrollItems, maxCrossAxisExtent: 90.0) // 90 logical pixels
```
- default constructor, passing in an explicit gridDelegate parameter
```
// Re-implementing the above SliverGrid.count example:
SliverGrid(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 4,
  ),
  delegate: SliverChildBuilderDelegate(
    (BuildContext context, int index) {
      return new Container(
        color: randomColor(),
        height: 150.0);
    }
);
```

---
### SliverAppBar
How to build a dynamically changing AppBar

- flexibleSpace  
- expandedHeight 

```
CustomScrollView(
    slivers: <Widget>[
      SliverAppBar(
        title: Text('SliverAppBar'),
        backgroundColor: Colors.green,
        expandedHeight: 200.0,
        flexibleSpace: FlexibleSpaceBar(
          background: Image.asset('assets/forest.jpg', fit: BoxFit.cover),
        ),
      ),
      SliverFixedExtentList(
        itemExtent: 150.0,
        delegate: SliverChildListDelegate(
          [
            Container(color: Colors.red),
            Container(color: Colors.purple),
            Container(color: Colors.green),
            Container(color: Colors.orange),
            Container(color: Colors.yellow),
            Container(color: Colors.pink),
          ],
        ),
      ),
    ],
);
```

---
### SliverBar
More settings

- floating parameter -> makes the app bar reappear when you scroll down, even if you haven’t reached the top of the list

> If you add both the snap parameter with the floating parameter, you can make the app bar fully snap back into view when you scroll down

---
### More on Slivers
https://medium.com/flutterdevs/explore-slivers-in-flutter-d44073bffdf6

https://medium.com/flutter/slivers-demystified-6ff68ab0296f

---
<!-- .slide: data-background="url('images/demo.jpg')" --> 
<!-- .slide: class="lab" -->
## Demo time!
Demo. SliverTime

---
<!-- .slide: data-background="url('images/lab2.jpg')" --> 
<!-- .slide: class="lab" -->
## Lab time!