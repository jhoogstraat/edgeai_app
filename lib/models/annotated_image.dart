import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'detection.dart';
import 'dart:ui' as ui;

class AnnotatedImage {
  final ui.Image img;
  final List<Detection> detections;

  AnnotatedImage(this.img, this.detections);

  static Future<AnnotatedImage> fromJson(dynamic json) async {
    final completer = Completer<ui.Image>();

    decodeImageFromList(
        base64Decode(json['img']['data']), (img) => completer.complete(img));
    final image = await completer.future;

    final List<dynamic> detections = json['detections'];
    return AnnotatedImage(
        image, detections.map((d) => Detection.fromJson(d)).toList());
  }

  @override
  String toString() {
    return "img: (${img.width} ${img.height}) | detect: $detections";
  }
}
