import 'dart:async';
import 'dart:io';

void main() {
  print("starting");
  doStuff();
  Timer.periodic(Duration(seconds: 1), (_) {
    print("waiting on clients");
  });
}

void doStuff() {
  Future.delayed(Duration(seconds:5)).then((_) {
    print("done");
    throw "Done here!";
  });
}
