# Streams

---
### What is a Stream
A stream is like a pipe, you put a value on the one end and if there’s a listener on the other end that listener will receive that value. 

A Stream can have multiple listeners 
- all of those listeners will receive the same value when it’s put in the pipeline. 

The way you put values on a stream is by using a StreamController.

---
### How to create a Stream
Start with a StreamController
```
StreamController<double> controller = StreamController<double>();
```
The controllers stream can be accessed through the stream property
```
Stream stream = controller.stream;
```

---
### How to use a stream
Now subscribe/listen to a stream. 

When you subscribe to a stream you will only get the values that are emitted (put onto the stream) after the subscription. 

```
stream.listen((value) {
  print('Value from controller: $value');
});
```

---
### Emit / Add a value onto the stream
Now call add on the streams controller
```
controller.add(12);
```
When you call that function, the callback supplied in the section above will execute. Which will print out
```
Value from controller: 12
```

---
### Managing the stream
The listen call returns a StreamSubscription of the type of your stream. 

This can be used to manage the stream subscription, for instance cancelling..

---
### Cancelling a stream
Cancel the listening when you're no longer required to receive the data. 

Basically making sure there are no memory leaks
  - a subscription to a stream will stay active until the entire memory is destroyed
  
---
### Cancelling a stream
When you subscribe to a Stream and you have to cancel it afterwards you can store it in a SteamSubscription
```
StreamSubscription<double> streamSubscription = stream.listen((value) {
  print('Value from controller: $value');
});
```

This will give you the subscription object for the registered callback.

---
### Cancelling a stream
Now cancel the stream on dispose or when it's not needed.
```
streamSubscription.cancel();
```

---
### Common Stream Errors
One thing that’s very common to see in dart is the “Stream already subscribed to” message

Active subscription cancellation will not get rid of the error! 

---
### Common Stream Errors 
Lets look at how we can create this exception ourselves, then we’ll figure out how to fix it.
```
stream.listen((value) {
  print('1st Sub: $value');
});
stream.listen((value) {
  print('2nd Sub: $value');
});
```
This will throw the error “Bad state: Stream has already been listened to”. 

Now even if you cancel the first subscription and subscribe again you’ll still get this error and that is by design.

---
### Common Stream Errors 
```
streamSubscription = stream.listen((value) {
     print('1st Sub: $value');
  });
  await streamSubscription.cancel();
  stream.listen((value) {
    print('2nd Sub: $value');
  });
```

The code above will still throw the “Bad state” stream error. 

---
### Common Stream Errors 
The reason for that is because there are two types of Streams:
- Single Subscription Stream: 
  - For use with a sequence of events that are parts of a larger whole. Things like reading a file or a web request. To ensure the subscriber that subscribed first gets all the correct information in the correct order there’s a limitation allowing you to only subscribe once for the lifecycle of the streams existence.
- Broadcast Stream: 
  - This kind of stream is for use with individual emissions that can be handled one at a time without the context or knowledge of the previous events.

You can use both for individual events, like I do, but just be weary of the subscription policy on the first one. 


---
### Common Stream Errors 
When using a StreamBuilder in Flutter you'll most likely always get the exception because the Stream will be subscribed to multiple times during build function calls (which happen a lot).

---
### Fixing the Bad State stream error
To fix this you’ll have to specifically create a broadcast StreamController so that the underlying stream is constructed and managed as a Broadcast stream that allows multiple subscriptions.

```
StreamController<double> controller = StreamController<double>.broadcast();
```


---
### Manual Streams
Another way of creating streams is through an generator/async * function
 - will run asynchronously and return (yield) a value whenever there's a new one

```
Stream<double> getRandomValues() async* {
    var random = Random(2);
    while (true) {
      await Future.delayed(Duration(seconds: 1));
      yield random.nextDouble();
    }
  }
```

---
### Manual Streams
So how do you use this Stream (Generator Function)?

```
getRandomValues().listen((value) {
    print('1st: $value');
  });
```

This will print out something like below where each line is printed after every second of delay.
```
1st: 0.000783592309359204
1st: 0.232325923093592045
1st: 0.456078359230935920
1st: 0.565783592309359204
```

Streams created in this manner are broadcast by default 
- allows for multiple subscriptions

---
<!-- .slide: data-background="url('images/demo.jpg')" --> 
<!-- .slide: class="lab" -->
## Demo time!
Demo 2. Streams

---
<!-- .slide: data-background="url('images/lab2.jpg')" --> 
<!-- .slide: class="lab" -->
## Lab time!
