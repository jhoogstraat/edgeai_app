import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/device_list_provider.dart';

final _ipv4Regex = RegExp(
    r'^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$');

class AddDeviceAlert extends StatelessWidget {
  AddDeviceAlert({
    Key key,
  }) : super(key: key);

  final _ipTextController = TextEditingController();
  final _dialogButtonEnabled = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Manuell hinzufügen'),
      content: TextField(
        controller: _ipTextController,
        decoration: const InputDecoration(hintText: 'IP-Addresse'),
        onChanged: (text) =>
            _dialogButtonEnabled.value = _ipv4Regex.hasMatch(text),
      ),
      actions: [
        TextButton(
            onPressed: Navigator.of(context).pop, child: Text('Abbrechen')),
        ValueListenableBuilder(
          valueListenable: _dialogButtonEnabled,
          builder: (_, enable, child) => TextButton(
            onPressed: enable ? () => _submitButtonPress(context) : null,
            child: child,
          ),
          child: Text('Hinzufügen'),
        )
      ],
    );
  }

  void _submitButtonPress(BuildContext context) {
    context.read(deviceListProvider).addDevice(_ipTextController.text);
    Navigator.pop(context);
  }
}
