import 'package:flutter/foundation.dart';

class CounterNotifier extends ChangeNotifier {
  int _counter = 0;
  incrementCounter() {
    counter++;
  }
  get counter => _counter;
  set counter(val) {
    _counter = val;
    notifyListeners();
  }
}

CounterNotifier counterNotifier = CounterNotifier();
