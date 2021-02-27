import 'package:flutter/foundation.dart';

class CheckedSetNotifier {
  CheckedSetNotifier(Iterable<String> keys, Map<String, int> checkedSet)
      : _notifiers = Map<String, ValueNotifier<int>>.fromIterable(keys,
            value: (key) => ValueNotifier<int>(checkedSet[key] ?? 0));

  final Map<String, ValueNotifier<int>> _notifiers;

  Map<String, int> get newCheckedSet =>
      _notifiers.map((key, value) => MapEntry(key, value.value));

  ValueNotifier<int> listen(String feature) {
    return _notifiers[feature];
  }

  void increment(String feature) {
    _notifiers[feature].value += 1;
  }

  void decrement(String feature) {
    if (_notifiers[feature].value > 0) {
      _notifiers[feature].value -= 1;
    }
  }
}
