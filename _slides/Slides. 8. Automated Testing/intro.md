# Testing

---
### Testing
- Why?

A good set of automated tests will help you make sure your app performs correctly before you publish it while retaining your feature and bug fix velocity


---
### Testing
Testing contains
- Unit test tests a single function, method, or class. 
- Widget test (in other UI frameworks referred to as component test) tests a single widget.
- Integration test tests a complete app or a large part of an app. 


---
### Testing tradeoffs

|               | Unit          | Widget           | Integration    |
| :-----------: | :-----------: | :--------------: | :-------------:|
| Confidence    | Low           | Higher           | Highest        |
| Maintenance   | Low           | Higher           |   Highest      |
| Dependencies  | Few           | More             |  Lots          |
| Execution speed | Quick       | Slower           |    Slowest     |
 

---
### Unit testing
The `flutter test` command lets you run your tests in a local Dart VM with a headless version of the Flutter Engine.

```
\\ Add this file to test/unit_test.dart:

import 'package:test/test.dart';

void main() {
  test('my first unit test', () {
    var answer = 42;
    expect(answer, 42);
  });
}
```

update pubspec
```
dev_dependencies:
  flutter_test:
    sdk: flutter
```

---
### Widget testing
```
void main() {
  testWidgets('my first widget test', (WidgetTester tester) async {
    var sliderKey = new UniqueKey();
    var value = 0.0;
    // Tells the tester to build a UI based on the widget tree passed to it
    await tester.pumpWidget(
      new StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return new MaterialApp(
            home: new Material(
              child: new Center(
                child: new Slider(
                  key: sliderKey,
                  value: value,
                  onChanged: (double newValue) {
                    setState(() {
                      value = newValue;
                   ... 
    );
    expect(value, equals(0.0));

    // Taps on the widget found by key
    await tester.tap(find.byKey(sliderKey));

    // Verifies that the widget updated the value correctly
    expect(value, equals(0.5));
  });
}
```

---
### Testing
Integration testing

use 
- a command-line tool flutter drive
- a package package:flutter_driver (API)

```
dev_dependencies:
  flutter_driver:
    sdk: flutter
```

- call enableFlutterDriverExtension().

Together, the two allow you to:
- create instrumented app for integration testing
- write a test
- run the test



// https://proandroiddev.com/testing-flutter-applications-f961969da86a