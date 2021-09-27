import 'dart:isolate';
import 'dart:core';
import 'dart:io';
import 'dart:async';

Future<void> main() async {
  final receivePort = ReceivePort();
  bool bFinish = false;
  Timer? timer;

  final isolate = await Isolate.spawn(
    downloadAndCompressTheInternet,
    [receivePort.sendPort, 3],
  );

  receivePort.listen((message) {
    print(message);
    if (message == -1) bFinish = true;
  });

  timer = Timer.periodic(Duration(seconds: 1), (_) {
    print("ting");
    if (bFinish) {
      receivePort.close();
      isolate.kill();
      timer?.cancel();
    }
  });
}

void downloadAndCompressTheInternet(List<Object> arguments) {
  SendPort sendPort = arguments[0] as SendPort;
  int number = arguments[1] as int;
  int i = 0;
  while (true) {
    if (i > 3) sendPort.send(-1);
    else sendPort.send(42 + number);
    sleep(Duration(seconds: 2));
    i++;
    
  }
}


// import 'dart:isolate';
// import 'dart:core';
// import 'dart:io';
// import 'dart:async';

// bool bFinish = false;

// Future<void> main() async {
//   final receivePort = ReceivePort();

//   final isolate = await Isolate.spawn(
//     downloadAndCompressTheInternet,
//     [receivePort.sendPort, 3],
//   );

//   receivePort.listen((message) {
//     print(message);
//   });

//   Timer.periodic(Duration(seconds: 1), (_) {
//     print("ting");
//     if (bFinish) {
//       receivePort.close();
//       isolate.kill();
//     }
//   });
// }

// void downloadAndCompressTheInternet(List<Object> arguments) {
//   SendPort sendPort = arguments[0] as SendPort;
//   int number = arguments[1] as int;
//   int i = 0;
//   while (true) {
//     sendPort.send(42 + number);
//     sleep(Duration(seconds: 2));
//     i++;
//     if (i > 3) bFinish = true;
//   }
// }
