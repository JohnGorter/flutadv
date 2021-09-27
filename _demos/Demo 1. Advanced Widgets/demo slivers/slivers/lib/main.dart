import 'package:flutter/material.dart';

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
        home: CustomScrollView(slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: true,
            snap: true,
            title: Text("My App"),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(height: 200, color: Colors.red),
              Container(height: 200, color: Colors.green),
              Container(height: 200, color: Colors.blue),
              Container(height: 200, color: Colors.black),
            ]),
          ),
          SliverPersistentHeader(
              pinned: true, delegate: Delegate(Colors.red, "Header")),
          SliverList(
              delegate: SliverChildListDelegate([
            Container(height: 200, color: Colors.white),
            Container(height: 200, color: Colors.yellow),
            Container(height: 200, color: Colors.pink),
            Container(height: 200, color: Colors.grey),
          ])),
          SliverPersistentHeader(
              pinned: true, delegate: Delegate(Colors.red, "Header")),
          SliverList(
              delegate: SliverChildListDelegate([
            Container(height: 200, color: Colors.red),
              Container(height: 200, color: Colors.green),
              Container(height: 200, color: Colors.blue),
              Container(height: 200, color: Colors.black),
          ]))
        ]));
  }
}

class Delegate extends SliverPersistentHeaderDelegate {
  final Color backgroundColor;
  final String _title;

  Delegate(this.backgroundColor, this._title);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
        child: Container(
      color: backgroundColor,
      child: Center(
        child: Text(
          _title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
      ),
    ));
  }

  @override
  double get maxExtent => 150;

  @override
  double get minExtent => 60;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
