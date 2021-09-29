import 'dart:async';

class CounterBloc {
  int _counter = 0;
  StreamController<int> controller = StreamController.broadcast();

  Stream get counter => controller.stream;

  void incrementCounter() {
    controller.sink.add(_counter++);
  }
}

// CounterBloc counterBloc = CounterBloc();