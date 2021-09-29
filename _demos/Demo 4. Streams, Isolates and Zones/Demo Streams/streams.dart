import 'dart:async';

import 'dart:math';

main() async {
  // Stream s = Stream.value(10);

  StreamController<double> controller = StreamController.broadcast();
  () async {
    var random = Random(2);
    while (true) {
      await Future.delayed(Duration(seconds: 1));
      controller.add(random.nextDouble());
    }
  }();

  // Stream<double> getRandomValues() async* {
  //   var random = Random(2);
  //   while (true) {
  //     await Future.delayed(Duration(seconds: 1));
  //     yield random.nextDouble();

  //     await Future.delayed(Duration(seconds: 1));
  //     yield random.nextDouble();

  //     await Future.delayed(Duration(seconds: 1));
  //     yield random.nextDouble();
  //   }
  // }

  controller.stream.listen((event) {
    print("event $event");
  });

  print("data");
}
