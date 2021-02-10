import 'dart:ui';

import 'package:flutter/foundation.dart';

class FeatureSet {
  final Map<String, int> requestedFeatures;
  final Map<String, int> detectedFeatures;
  final bool isComplete;
  final Image referenceFrame;
  final DateTime timestamp;

  FeatureSet(this.requestedFeatures, this.detectedFeatures, this.isComplete,
      this.referenceFrame, this.timestamp);

  static Future<FeatureSet> fromMessage(Map<String, dynamic> json) async {
    final codec = await instantiateImageCodec(json['referenceFrame']);
    final frame = await codec.getNextFrame();

    return FeatureSet(
      Map.from(json['requestedFeatures']),
      Map.from(json['detectedFeatures']),
      json['isComplete'],
      frame.image,
      DateTime.fromMillisecondsSinceEpoch((1000 * json['timestamp']).toInt()),
    );
  }
}

class FeatureSetList extends ChangeNotifier {
  FeatureSetList(Stream<FeatureSet> generator) {
    generator.listen((featureSet) {
      add(featureSet);
    });
  }

  List<FeatureSet> state = [];

  FeatureSet operator [](int i) => state[i]; // get
  int get length => state.length;

  void add(FeatureSet featureSet) {
    state.add(featureSet);
    notifyListeners();
  }
}
