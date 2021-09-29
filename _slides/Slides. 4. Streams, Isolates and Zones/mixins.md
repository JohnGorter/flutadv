Dart: What are mixins?
It’s a kind of magic ✨
Romain Rastel
Romain Rastel
Follow

Sep 16, 2018 · 7 min read







Dart mixer (modified from shareicon)
When I started to learn Dart, the concept of mixins was new for me.
I come from the C# world, where it does not exist (at least prior to C# 8.0, to the best of my knowledge).
At first, I found this concept somewhat difficult to understand, until I realized how powerful it was.
Disclaimer: Mixins specifications are evolving in Dart 2. Some of the following content might not be applicable at the time of reading this.
🤔 Why do we need mixins?
If languages such as C# do not have mixins, it probably isn’t that useful, is it?
Let’s have a look at the following class inheritance diagram:

We have here a superclass called Animal which has three subclasses (Mammal, Bird, and Fish). At the bottom, we have concrete classes.
The little squares represent behavior. For example, the blue square indicates that an instance of a class with this behavior can swim.
Some animals share common behavior: A cat and a dove can both walk, but the cat cannot fly (except for Nyan Cat 😀).
These kinds of behavior are orthogonal to this classification, so we cannot implement these behavior in the superclasses.
If a class could have more than one superclass, it would be easy, we could create three other classes: Walker, Swimmer, Flyer. After that, we would just have to inherit Dove and Cat from the Walker class. But in Dart, every class (except for Object) has exactly one superclass.
Instead of inheriting from the Walker class, we could implement it, as it if was an interface, but we should have to implement the behavior in multiple classes, so it’s not a good solution.
We need a way of reusing a class’s code in multiple class hierarchies.
You know what? Mixins are exactly that:
Mixins are a way of reusing a class’s code in multiple class hierarchies.
— dartlang.org
Described like that, it sounds easy 😁.
🔒 Constraints
The mixin feature comes with a few restrictions (from dartlang.org):
Dart 1.12 or lower supports mixins that must extend Object, and must not call super().
Dart 1.13 or greater supports mixins that can extend from classes other than Object, and can call super.method(). This support is only available by default in the Dart VM and in Analyzer behind a flag. More specifically, it is behind the --supermixin flag in the command-line analyzer. It is also available in the analysis server, behind a client-configurable option. Dart2js and dartdevc do not support super mixins.
In Dart 2.1, mixins are expected to have fewer restrictions. For example, Flutter supports mixins calling super() and extending from a class other than Object, but the syntax is expected to change before appearing in all Dart SDKs. For details, see the mixin specification.
📝 Syntax
We saw how mixins can be useful, let’s see how to create and use them.
Mixins are implicitly defined via ordinary class declarations:

If we want to prevent our mixin to be instantiated or extended, we can define it like that:

To use a mixin, use the with keyword followed by one or more mixin name:

Defining the Walker mixin on the Cat class, allows us to call the walk method but not the fly method (defined in Flyer).

🔎 Details
I told you I found this concept somewhat difficult to understand, but so far it’s not so difficult, is it?
Well, can you tell what the output of the following program is 😵?

You can run this program on DartPad
Both, AB and BA classes extend the P class with A and B mixins but in a different order. All three A, B and P classes have a method called getMessage.
First, we call the getMessage method of the AB class, then the getMessage method of the BA class.
So, what do you think the resulting output will be?
I’m giving you five propositions:
A. It does not compile
B. BA
C. AB
D. BAAB
E. ABBA
🥁🥁🥁The answer is the proposition B! The program prints BA.
I think you guessed that the order in which the mixins are declared is very important.
Why? How is it working?
✨ Linearization
When you apply a mixin to a class, keep in mind this:
Mixins in Dart work by creating a new class that layers the implementation of the mixin on top of a superclass to create a new class — it is not “on the side” but “on top” of the superclass, so there is no ambiguity in how to resolve lookups.
— Lasse R. H. Nielsen on StackOverflow.
In fact, the code

is semantically equivalent to

The final inheritance diagram can be represented like this:

New classes are created between AB and P. These new classes are a mix-in between the superclass P and the classes A and B.
As you can see, there is no multiple inheritance in there!
Mixins is not a way to get multiple inheritance in the classical sense. Mixins is a way to abstract and reuse a family of operations and state. It is similar to the reuse you get from extending a class, but it is compatible with single-inheritance because it is linear.
— Lasse R. H. Nielsen on StackOverflow.
One important thing to remember is that the order in which mixins are declared represents the inheritance chain, from the top superclass to the bottom one.
📄 Types
What is the type of a mixin application instance? In general, it is a subtype of its superclass, and also a subtype of the type denoted by the mixin name itself, that is, the type of the original class.
— dartlang.org
So it means that this program

You can run this program on DartPad
will print six lines with true in the console.
Detailed explanation
Lasse R. H. Nielsen gave me a great explanation:
Since each mixin application creates a new class, it also creates a new interface (because all Dart classes also define interfaces). As described, the new class extends the superclass and includes copies of the mixin class members, but it also implements the mixin class interface.
In most cases, there is no way to refer to that mixin-application class or its interface; the class for Super with Mixin is just an anonymous superclass of the class declared like class C extends Super with Mixin {}. If you name a mixin application like class CSuper = Super with Mixin {}, then you can refer to the mixin application class and its interface, and it will be a sub-type of both Super and Mixin.
— Lasse R. H. Nielsen
🙄 When to use mixins?
Mixins are very helpful when we want to share a behavior across multiple classes that don’t share the same class hierarchy, or when it doesn’t make sense to implement such a behavior in a superclass.
It’s typically the case for serialization (Take a look at jaguar_serializer for example) or persistence. But you can also use mixins to provide some utility functions (like the RenderSliverHelpers in Flutter).
Take a time to play with this feature, and I’m sure you’ll find new use cases 😉. Don’t restrict yourself to stateless mixins, you can absolutely store variables and use them!
📈 Mixins specification is evolving
If you’re interested in Dart language evolution, you should know that its specification will evolve in Dart 2.1 and they would love your feedback here and there. For detailed information, you can read this.
To give you a glimpse into the future, consider this source code:

The mixin declaration from line 13 to 18, indicates a superclass constraint on Super. It means that in order to apply this mixin to a class, this class must extend or implementSuper because the mixin uses a feature provided by Super.
The output of this program would be:
MySuper
Sub
If you wonder why, keep in mind how mixins are linearized:

In fact, the call to super.method() on line 15 actually calls the method declared on line 8.
🐬Complete Animal example
You can find below, the complete Animals example with which I introduced the mixins:

We can see below how these mixins are linearized:

📗 Conclusion
We saw that mixins are a powerful concept that allows you to reuse code across multiple class hierarchies.
Flutter uses this feature a lot, and I found it important to understand it better, that’s why I shared my comprehension with you.
If you have any questions, feel free to post them 👇.
Any feedback is welcome 😃.
If you enjoyed this story, you can support me by 👏 this.
You can also follow me on Twitter.