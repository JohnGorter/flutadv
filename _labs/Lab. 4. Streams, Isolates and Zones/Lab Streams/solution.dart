import 'dart:io';
import 'dart:async';

void main() async {
  StreamTransformer<String, String> upper =
      StreamTransformer.fromHandlers(handleData: (item, EventSink sink) {
    sink.add(item.toUpperCase());
  });
  
  // getKeys().distinct().transform(upper).listen((event) {
  //   print(event);
  // });
  
  await for (String e in getKeys().distinct().transform(upper)) {
    print(e);
  };
}

Stream<String> getKeys() async* {
  while (true) yield stdin.readLineSync() as String;
}
