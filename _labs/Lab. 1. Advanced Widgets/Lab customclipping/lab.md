# Lab CustomClipper

---
### clipping
Time: 60 minutes

--
### Setup
Inside this folder is a starter folder. There are 3 starter files. These are the start of each excercise. Create a brand new flutter application and copy and paste the starter file of the exercise into the contents of the main.dart inside the newly generated project.
Work in this main.dart from your IDE.

---
### Excercise 1: Make a chat bubble
Use a custom clipper to make a chat bubble.
Implement your clipper so you have a chat screen were this custom clipper shines.
Make the custom clipper generic so you can give it a color and a right or left speech bubble arrow.


---
### Excercise 2: Make a custom appBar
First make a clipper that uses a quadraticBezier to implement a custom appBar. 
 
Then use a Painter in combination to the custom clipper to draw shadow below
the clipped area. 

Does the list still react to your gestures?

---
### Excercise 3: Use a custom ShapeBorder
Reimplement the clipper/painter with a custom ShapeBorder. Notice that 
you now dont have to worry about the interaction with list underneath

---
### Extra Excercise: The inverted cliprect
Sometimes you want to clip the opposite. Suppose you want to leave a circle as
a hole where you can peek trough. Clipping a cicle does the opposite, it shows the
child as a circle. Now we want to cut-out the circle and leave the boundingbox as the
clipping frame.. 

So when our widget is in a stack with an image behind it, we want the clipper to 
cut-out a hole in the middle we we see throug as if it is a frame.

An example can be seen here: https://i.stack.imgur.com/Qq0xq.png
The black transparent mask is the clipped area, the hole is cut-out..
It actually is the opposite of the normal way of clipping..

Try to implement this with the knowledge gained.

Solution to this problem: https://stackoverflow.com/questions/49374893/flutter-inverted-clipoval




