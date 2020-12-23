import 'dart:async';
import 'dart:ui';

import 'detection.dart';
import 'dart:ui' as ui;

class AIImage {
  final ui.Image image;
  final List<Detection> detections;

  AIImage(this.image, this.detections);

  static Future<AIImage> fromJson(Map<String, dynamic> json) async {
    final _onImage = Completer<ui.Image>();
    decodeImageFromList(json['img'], (img) => _onImage.complete(img));
    final image = await _onImage.future;

    return AIImage(
        image, json['detections'].map((d) => Detection.fromJson(d)).toList());
  }

  @override
  String toString() {
    return "img: (${image.width} ${image.height}) | detect: $detections";
  }
}
