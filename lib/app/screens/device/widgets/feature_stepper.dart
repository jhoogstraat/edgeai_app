import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../providers.dart';

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

class FeatureStepper extends StatelessWidget {
  final String featureId;
  final String title;
  final ValueNotifier<int> value;

  const FeatureStepper({
    @required this.title,
    @required this.featureId,
    @required this.value,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Icon(Icons.add);
    Icon(Icons.remove);
    return Row(
      children: [
        Text(title),
        Expanded(child: SizedBox()),
        ElevatedButton(
            onPressed: () =>
                context.read(checkedSetProvider).decrement(featureId),
            child: Icon(Icons.remove),
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(3), minimumSize: const Size(10, 5))),
        ValueListenableBuilder(
            valueListenable: value,
            builder: (_, value, __) => Text(value.toString())),
        ElevatedButton(
          onPressed: () =>
              context.read(checkedSetProvider).increment(featureId),
          child: Icon(Icons.add),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(3),
            minimumSize: const Size(10, 5),
          ),
        ),
      ],
    );
  }
}
