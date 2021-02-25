import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../providers.dart';

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
