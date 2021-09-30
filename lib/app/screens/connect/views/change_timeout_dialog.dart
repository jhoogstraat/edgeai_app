import 'package:flutter/material.dart';
import 'package:horizontal_picker/horizontal_picker.dart';

class ChangeTimeoutDialog extends StatefulWidget {
  const ChangeTimeoutDialog({Key? key, required this.initialValue})
      : super(key: key);

  final double initialValue;

  @override
  State<ChangeTimeoutDialog> createState() => _ChangeTimeoutDialogState();
}

class _ChangeTimeoutDialogState extends State<ChangeTimeoutDialog> {
  late double currentValue;

  @override
  void initState() {
    super.initState();
    currentValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Timeout einstellen (Sek.)'),
      contentPadding: EdgeInsets.zero,
      content: HorizontalPicker(
          minValue: 1,
          maxValue: 10,
          divisions: 9,
          initialPosition: InitialPosition.center,
          suffix: "s",
          backgroundColor: Colors.transparent,
          activeItemTextColor: Theme.of(context).colorScheme.primary,
          passiveItemsTextColor: Theme.of(context).colorScheme.onSurface,
          showCursor: false,
          onChanged: (value) => currentValue = value),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, currentValue),
          child: const Text('Speichern'),
        )
      ],
    );
  }
}
