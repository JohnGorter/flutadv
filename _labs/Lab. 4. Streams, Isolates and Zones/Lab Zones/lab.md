# Lab Zones

---
### Make your app more robust
Time: 10 minutes

--
### Setup
You do not have to create a new flutter project for this lab. Just copy the starter.dart and use this file as your workspace in your favorite IDE.

---
### Excercise 1. Make the code more robust
Run the dart file in your console. Notice that after 5 seconds, the application terminates.
Implement a zone to guard yourself from terminating the application.. Clients should always be welcome!

---
### Excercise 2. Log all exceptions from a flutter app to file
Generate a new flutter application and make sure all exceptions are logged to file. 
Make use of the code below and change it where necessary:

```
void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    ... your code here ...
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.dumpErrorToConsole(details);
      ... your code here ...
      exit(1);
    };
    runApp(MyApp());
  }, (Object error, StackTrace stack) {
    ... your code here ...
    exit(1);
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(child:TextButton(onPressed:(){ throw "AAARGH!";}))
    );
  }
}
```

