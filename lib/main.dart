import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:obj_detect_board/models/annotated_image.dart';
import 'package:obj_detect_board/ui/annotation_canvas.dart';
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
  // final painter = AnnotationCanvas();
  final currentImg = ValueNotifier<AnnotatedImage>(null);

  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('OBJECT DETECTION BOARD'),
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(children: [RaisedButton(
              onPressed: () => api.startDetecting((img) => currentImg.value = img),
              child: Text("START"),
            ),
              RaisedButton(
                onPressed: () => api.stopDetecting(),
                child: Text("STOP"),
              ),],),
            Expanded(
              child: SizedBox(width: width, height: double.infinity, child: ValueListenableBuilder(
                valueListenable: currentImg,
                builder: (context, value, child) => CustomPaint(
                  painter: AnnotationCanvas(value),
                  willChange: true,
                ),
              ),
            ),
            )
          ],
        ),
    );
  }
}
