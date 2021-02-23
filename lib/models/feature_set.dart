import 'dart:ui';

class FeatureSet {
  final String id;
  final Map<String, int> requestedFeatures;
  final Map<String, int> detectedFeatures;
  final bool isComplete;
  final Image referenceFrame;
  // final Image referenceFrame;
  final DateTime timestamp;

  FeatureSet(this.id, this.requestedFeatures, this.detectedFeatures,
      this.isComplete, this.referenceFrame, this.timestamp);

  static Future<FeatureSet> fromMessage(Map<String, dynamic> json) async {
    final codec = await instantiateImageCodec(json['referenceFrame']);
    final frame = await codec.getNextFrame();

    return FeatureSet(
      json['id'],
      Map.from(json['requestedFeatures']),
      Map.from(json['detectedFeatures']),
      json['isComplete'],
      frame.image,
      DateTime.fromMillisecondsSinceEpoch((1000 * json['timestamp']).toInt()),
    );
  }
}
