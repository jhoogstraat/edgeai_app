import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:network_info_plus/network_info_plus.dart';

import '../../../../library/providers/app_providers.dart';

class AddDeviceDialog extends ConsumerStatefulWidget {
  const AddDeviceDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddDeviceState();
}

class _AddDeviceState extends ConsumerState<AddDeviceDialog> {
  final _ipv4Regex = RegExp(
      r'^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$');
  final _ipTextController = TextEditingController();
  final _saveButtonEnabled = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Manuell hinzufügen'),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextField(
            controller: _ipTextController,
            autofocus: true,
            autocorrect: false,
            keyboardType: const TextInputType.numberWithOptions(
                signed: false, decimal: false),
            decoration: const InputDecoration(hintText: 'IP-Addresse'),
            onChanged: (text) =>
                _saveButtonEnabled.value = _ipv4Regex.hasMatch(text),
          ),
          TextButton(onPressed: _useLocalAddress, child: const Text('Lokal'))
        ],
      ),
      actions: [
        TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text('Abbrechen')),
        ValueListenableBuilder(
          valueListenable: _saveButtonEnabled,
          builder: (_, dynamic enable, child) => TextButton(
            onPressed: enable ? () => _saveButtonPressed(context) : null,
            child: child!,
          ),
          child: const Text('Hinzufügen'),
        )
      ],
    );
  }

  void _saveButtonPressed(BuildContext context) {
    ref.read(devicesProvider).addDevice(_ipTextController.text);
    Navigator.pop(context);
  }

  Future<void> _useLocalAddress() async {
    final info = NetworkInfo();
    var ip = await info.getWifiIP();

    if (ip != null) {
      final truncated = ip.substring(0, ip.lastIndexOf(".") + 1);
      _ipTextController.value = TextEditingValue(text: truncated);
      _ipTextController.selection = TextSelection.fromPosition(
        TextPosition(offset: truncated.length),
      );
    }
  }

  @override
  void dispose() {
    _ipTextController.dispose();
    _saveButtonEnabled.dispose();
    super.dispose();
  }
}
