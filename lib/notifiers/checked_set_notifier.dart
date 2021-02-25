import 'package:flutter/foundation.dart';

class CheckedSetNotifier {
  final Map<String, ValueNotifier<int>> _notifiers;

  Map<String, int> get newCheckedSet =>
      _notifiers.map((key, value) => MapEntry(key, value.value));

  CheckedSetNotifier(
      [Iterable<String> keys, Map<String, int> checkedSet = const {}])
      : _notifiers = Map<String, ValueNotifier<int>>.fromIterable(keys,
            value: (key) => ValueNotifier<int>(checkedSet[key] ?? 0));

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
