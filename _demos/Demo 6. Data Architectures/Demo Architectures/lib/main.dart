import 'package:flutter/material.dart';
import './notifier/counternotifier.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late void Function() listener;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listener = () {
      setState(() {});
    };
    counterNotifier.addListener(listener);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    counterNotifier.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '${counterNotifier.counter}',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: counterNotifier.incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}




// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatelessWidget {
//   MyHomePage({Key? key, required this.title}) : super(key: key);
//   final String title;
//   @override
//   Widget build(BuildContext context) {
//     return MyCounterBlocInherited(
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(title),
//         ),
//         body: Center(child: MyDemoPage()),
//         floatingActionButton:
//           MyButton(), // This trailing comma makes auto-formatting nicer for build methods.
//         )
//       );
//   }
// }

// class MyButton extends StatelessWidget {
//   const MyButton({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return FloatingActionButton(
//       onPressed:
//           MyCounterBlocInherited.of(context).counterBloc.incrementCounter,
//       tooltip: 'Increment',
//       child: Icon(Icons.add),
//     );
//   }
// }

// class MyDemoPage extends StatelessWidget {
//   const MyDemoPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//         stream: MyCounterBlocInherited.of(context).counterBloc.counter,
//         builder: (BuildContext context, AsyncSnapshot snapshot) {
//           return Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Text(
//                 'You have pushed the button this many times:',
//               ),
//               Text(
//                 '${snapshot.data}',
//                 style: Theme.of(context).textTheme.headline4,
//               ),
//             ],
//           );
//         });
//   }
// }
