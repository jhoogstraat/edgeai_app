import 'dart:async';

import 'package:flutter/material.dart';
import 'api.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key}) : super(key: key);
  final api = Api();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OBJECT DETECTION BOARD'),
      ),
      body: Center(
        child: Column(
          children: [
            RaisedButton(
              onPressed: getDetections,
              child: Text("START"),
            ),
            RaisedButton(
              onPressed: () => streamSub.cancel(),
              child: Text("STOP"),
            )
          ],
        ),
      ),
    );
  }

  StreamSubscription streamSub;

  void getDetections() async {
    final stream = await api.startDetecting();
    streamSub = stream.listen((event) {
      print(event.detections.first.label);
    });
  }
}
