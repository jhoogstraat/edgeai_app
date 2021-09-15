import 'dart:async';
import 'dart:ui';
import 'feature.dart';

class AIImage {
  final Image frame;
  final List<Feature> features;

  AIImage(this.frame, this.features);

  static Future<AIImage> fromMessage(Map<String, dynamic> json) async {
    final codec = await instantiateImageCodec(json['frame']);
    final frame = await codec.getNextFrame();

    return AIImage(
      frame.image,
      json['objects'].map((obj) => Feature.fromJson(obj)).toList(),
    );
  }

  @override
  String toString() {
    return 'frame: (${frame.width} ${frame.height}) | detect: $features';
  }
}
