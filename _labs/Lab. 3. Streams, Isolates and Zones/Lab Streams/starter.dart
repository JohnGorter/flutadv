import 'dart:io';
import 'dart:async';

void main() {
  getKeys().listen((event) {
    print(event);
  });
}

Stream<String> getKeys() async* {
   // .. YOUR CODE HERE
}
