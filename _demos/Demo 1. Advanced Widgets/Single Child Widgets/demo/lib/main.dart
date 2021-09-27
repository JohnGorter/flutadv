import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print("Density ${VisualDensity.maximumDensity}");
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          visualDensity: VisualDensity(horizontal: 10),
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        // home: Stack(children: [
        //   Align(alignment: Alignment(0,0), child:Container(color: Colors.red, width:100, height:50),),
        //   Align(alignment: Alignment(-0.2,0.2), child:Container(color: Colors.green, width:100, height:50),),
        //   Align(alignment: Alignment(-0.4,0.4), child:Container(color: Colors.blue, width:100, height:50),),
        // ])

        home: Scaffold(
            body: Column(
          children: [
            TextButton(onPressed: () {}, child: Text("Hello World")),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Center(
                    child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                            constraints:
                                BoxConstraints(minHeight: 300, minWidth: 300),
                            color: Colors.red))))
          ],
        )));
  }
}
