import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:obj_detect_board/models/annotated_image.dart';
import 'package:obj_detect_board/ui/annotation_canvas.dart';
import 'package:riverpod/riverpod.dart';

import 'api.dart';
import 'models/detection.dart';

void main() {
  runApp(ProviderScope
  (child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class ApiState extends StateNotifier<AnnotatedImage> {
  ApiState(state) : super(state);

  void next(AnnotatedImage img) => state = img;
}

final imageProvider = StateNotifierProvider((ref) => ApiState(null));

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key}) : super(key: key);

  final api = Api();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OBJECT DETECTION BOARD'),
        actions: [
          IconButton(
            icon: Icon(Icons.not_started),
            onPressed: () => toggleAnalyser(context),
          )
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 4 / 3,
            child: Consumer(
              builder: (context, watch, child) => CustomPaint(
                painter: AnnotationCanvas(watch(imageProvider.state)),
                willChange: true,
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Consumer(
              builder: (context, watch, child) {
                final img = watch(imageProvider.state);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Vollständigkeitsprüfung",
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    Text("complete: ${isCompleteSet(img?.detections)}"),
                    const SizedBox(height: 10),
                    Text("Objects: ${img?.detections?.length ?? 0}"),
                    Expanded(child: buildDetectionList(img)),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  bool isCompleteSet(List<Detection> detections) {
    if (detections == null) return false;
    var greens = 0;
    var yellows = 0;
    detections.forEach((element) {
      if (element.label == "slope_yellow") yellows++;
      if (element.label == "brick_green") greens++;
    });

    return greens == 1 && yellows == 1;
  }

  Widget buildDetectionList(AnnotatedImage img) {
    if (img == null || img?.detections?.isEmpty == true) return SizedBox();

    return ListView.separated(
        itemBuilder: (context, index) => ListTile(
              title: Text(img.detections[index].label),
              subtitle: Text(
                  (img.detections[index].score * 100).toStringAsFixed(0) + "%"),
            ),
        separatorBuilder: (context, index) => Divider(thickness: 1),
        itemCount: img.detections.length);
  }

  void toggleAnalyser(BuildContext context) {
    api.isAnalysing
        ? api.stopDetecting()
        : api.startDetecting(context.read(imageProvider).next);
  }
}
