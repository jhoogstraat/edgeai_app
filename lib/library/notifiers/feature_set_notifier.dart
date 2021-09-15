import 'package:flutter/foundation.dart';

import '../models/feature_set.dart';

class FeatureSetsNotifier extends ChangeNotifier {
  FeatureSetsNotifier(Stream<FeatureSet> generator) {
    generator.listen((featureSet) {
      add(featureSet);
    });
  }

  List<FeatureSet> state = [];

  FeatureSet operator [](int i) => state[i]; // get
  int get length => state.length;
  FeatureSet get last => state.first;

  void add(FeatureSet featureSet) {
    state.insert(0, featureSet);
    if (length > 50) state.removeLast();
    notifyListeners();
  }

  void clear() {
    state.clear();
    notifyListeners();
  }
}
