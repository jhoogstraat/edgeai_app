import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../library/providers/app_providers.dart';
import '../../../../library/services/api.dart';

import 'feature_stepper.dart';

class ConfigDialog extends StatelessWidget {
  const ConfigDialog({Key? key, required this.sliderValue}) : super(key: key);

  final ValueNotifier<double?> sliderValue;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Konfigurieren'),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 10, 24),
      content: Consumer(
        builder: (context, ref, child) {
          // Makes sure the checkedSetProvider is disposed properly when the dialog is dismissed.
          final state = ref.watch(checkedSetProvider);
          final status = ref.read(selectedDeviceStatusProvider).state;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...status.labels.entries
                  .map((e) => FeatureStepper(
                        featureId: e.key,
                        title: e.value,
                        value: state.listen(e.key),
                      ))
                  .toList(),
              const Text('Min-Prozentsatz'),
              ValueListenableBuilder(
                valueListenable: sliderValue,
                builder: (context, dynamic value, child) => Slider(
                  value: value,
                  divisions: 10,
                  label: value.toString(),
                  onChanged: (newValue) => sliderValue.value = newValue,
                ),
              )
            ],
          );
        },
      ),
      actions: [
        ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen')),
        Consumer(builder: (context, ref, child) {
          return ElevatedButton(
            onPressed: () => saveConfigButtonPress(context, ref,
                ref.read(checkedSetProvider).newCheckedSet, sliderValue.value),
            child: const Text('Speichern'),
          );
        }),
      ],
    );
  }

  Future<void> saveConfigButtonPress(BuildContext context, WidgetRef ref,
      Map<String, int> checkedSet, double? minPercentage) async {
    final host = ref.read(selectedDeviceProvider).state!.ip;
    final status = await Api.configure(host,
        checkedSet: checkedSet, minPercentage: minPercentage);
    ref.read(selectedDeviceStatusProvider).state = status;
    Navigator.pop(context);
  }
}
