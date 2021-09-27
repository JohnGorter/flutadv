import 'dart:async';
import 'dart:io';

void main() {
  print("starting");

  runZonedGuarded(() {
    doStuff();
  }, (error, stack) {
    print("error $error");
  });
  
  Timer.periodic(Duration(seconds: 1), (_) {
    print("waiting on clients");
  });
}

void doStuff() {
  Future.delayed(Duration(seconds: 5)).then((_) {
    print("done");
    throw "Done here!";
  });
}
