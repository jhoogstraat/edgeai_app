import 'package:flutter/material.dart';

class ChangeTimeoutDialog extends StatelessWidget {
  const ChangeTimeoutDialog({
    Key key,
    @required this.sliderValue,
  }) : super(key: key);

  final ValueNotifier<double> sliderValue;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Timeout einstellen (Sek.)'),
      content: ValueListenableBuilder<double>(
        valueListenable: sliderValue,
        builder: (context, value, child) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Slider(
              value: value,
              min: 1.0,
              max: 10.0,
              divisions: 9,
              label: value.toString(),
              onChanged: (newValue) => sliderValue.value = newValue,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Speichern'),
        )
      ],
    );
  }
}
