import 'dart:async';

class CounterBloc {
  StreamController<int> _controller = StreamController.broadcast();

  int _counter = 0;

  Stream<int> get counter => _controller.stream;

  set counterValue(int i) {
    _counter++;
    _controller.add(_counter);
  }

  void dispose() {
    _controller.close();
  }
}

var counterBloc = CounterBloc();
