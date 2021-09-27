import 'package:flutter/rendering.dart';
import 'dart:ui';

main() {
  int counter = 0;
  counterText(counter) {
    return TextSpan(text: " You have pushed this many times: $counter");
  }

  final rootNode =
      RenderParagraph(counterText(counter), textDirection: TextDirection.ltr);

  RenderingFlutterBinding(
      root: RenderPositionedBox(
          child: RenderPointerListener(
              onPointerDown: (_) {
                rootNode.text = counterText(counter++);
                var b = rootNode.parent?.parent as RenderDecoratedBox;
                b.decoration = BoxDecoration(color: Color(0xFF00FF00));
              },
              child: RenderDecoratedBox(
                  decoration: BoxDecoration(color: Color(0xFFFF0000)),
                  child: RenderPadding(
                    padding: EdgeInsets.all(100),
                    child: rootNode,
                  ))))).scheduleFrame();
}
