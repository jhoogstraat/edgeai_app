import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:obj_detect_board/app/painters/aimage_painter.dart';
import 'package:obj_detect_board/models/ai_image.dart';
import 'package:obj_detect_board/models/detection.dart';
import 'package:obj_detect_board/providers.dart';

import 'home_view_model.dart';

final homeModelProvider = ChangeNotifierProvider((ref) => HomeViewModel());
final frameProvider =
    StreamProvider<AIImage>((ref) => ref.read(apiProvider).listen());

class HomePage extends StatelessWidget {
  HomePage({Key key}) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OBJECT DETECTION BOARD'),
        actions: [
          IconButton(
            icon: Icon(Icons.not_started),
            onPressed: () => print("Turn on/off"),
          )
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 4 / 3,
            child: Consumer(
              builder: (context, watch, child) {
                return watch(frameProvider).when(
                  data: (data) => CustomPaint(
                      painter: AImagePainter(data), willChange: true),
                  loading: () => Center(child: CircularProgressIndicator()),
                  error: (error, _) {
                    throw error;
                    return Center(
                      child: Text(error.toString() + _.toString()),
                    );
                  },
                );
              },
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Consumer(
              builder: (context, watch, child) {
                return watch(frameProvider).when(
                  data: (aiImage) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Vollständigkeitsprüfung",
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 10),
                      Text("complete: ${isCompleteSet(aiImage.detections)}"),
                      const SizedBox(height: 10),
                      Text("Objects: ${aiImage.detections?.length ?? 0}"),
                      Expanded(child: buildDetectionList(aiImage)),
                    ],
                  ),
                  loading: () => Center(child: CircularProgressIndicator()),
                  error: (error, _) {
                    throw error;
                    return Center(
                      child: Text(error.toString() + _.toString()),
                    );
                  },
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

  Widget buildDetectionList(AIImage img) {
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
}
