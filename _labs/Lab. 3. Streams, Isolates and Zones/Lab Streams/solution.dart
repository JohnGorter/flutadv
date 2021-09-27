import 'dart:io';
import 'dart:async';

void main() {
  StreamTransformer<String, dynamic> upper =
      StreamTransformer.fromHandlers(handleData: (item, EventSink sink) {
    sink.add(item.toUpperCase());
  });
  getKeys().distinct().transform(upper).listen((event) {
    print(event);
  });
}

Stream<String> getKeys() async* {
  while (true) yield stdin.readLineSync() as String;
}
