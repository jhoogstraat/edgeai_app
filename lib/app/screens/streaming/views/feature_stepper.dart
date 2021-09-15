import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../library/providers/app_providers.dart';

class FeatureStepper extends ConsumerWidget {
  final String featureId;
  final String title;
  final ValueNotifier<int>? value;

  const FeatureStepper({
    required this.title,
    required this.featureId,
    required this.value,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Text(title),
        const Expanded(child: SizedBox()),
        ElevatedButton(
            onPressed: () => ref.read(checkedSetProvider).decrement(featureId),
            child: const Icon(Icons.remove),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(3),
              minimumSize: const Size(10, 5),
            )),
        ValueListenableBuilder(
            valueListenable: value!,
            builder: (_, dynamic value, __) => Text(value.toString())),
        ElevatedButton(
          onPressed: () => ref.read(checkedSetProvider).increment(featureId),
          child: const Icon(Icons.add),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(3),
            minimumSize: const Size(10, 5),
          ),
        ),
      ],
    );
  }
}
