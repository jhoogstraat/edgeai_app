import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../library/providers/app_providers.dart';

class AddDeviceDialog extends ConsumerWidget {
  AddDeviceDialog({
    Key? key,
  }) : super(key: key);

  final _ipv4Regex = RegExp(
      r'^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$');
  final _ipTextController = TextEditingController();
  final _dialogButtonEnabled = ValueNotifier(false);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('Manuell hinzufügen'),
      content: TextField(
        controller: _ipTextController,
        decoration: const InputDecoration(hintText: 'IP-Addresse'),
        onChanged: (text) =>
            _dialogButtonEnabled.value = _ipv4Regex.hasMatch(text),
      ),
      actions: [
        TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text('Abbrechen')),
        ValueListenableBuilder(
          valueListenable: _dialogButtonEnabled,
          builder: (_, dynamic enable, child) => TextButton(
            onPressed: enable ? () => _submitButtonPress(context, ref) : null,
            child: child!,
          ),
          child: const Text('Hinzufügen'),
        )
      ],
    );
  }

  void _submitButtonPress(BuildContext context, WidgetRef ref) {
    ref.read(devicesProvider).addDevice(_ipTextController.text);
    Navigator.pop(context);
  }
}
