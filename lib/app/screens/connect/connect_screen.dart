import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../library/providers/config_providers.dart';
import '../streaming/streaming_screen.dart';
import '../../../library/models/status.dart';

import '../../../library/providers/app_providers.dart';
import 'views/change_timeout_dialog.dart';
import '../../../library/models/device.dart';

import 'views/add_device_dialog.dart';
import 'views/status_indicator.dart';

class ConnectScreen extends ConsumerWidget {
  const ConnectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer(builder: (context, ref, child) {
          final devices = ref.watch(devicesProvider);
          return devices.isInitialized
              ? Text('${devices.devices.length} Gerät(e) gefunden')
              : const Text('Suche nach Geräten...');
        }),
        actions: [
          IconButton(
              icon: const Icon(Icons.timelapse),
              onPressed: () => _timeoutConfigButtonPress(context, ref)),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => showDialog(
              barrierDismissible: false,
              context: context,
              builder: (_) => const AddDeviceDialog(),
            ),
          ),
        ],
      ),
      body: Consumer(builder: (context, ref, child) {
        final state = ref.watch(devicesProvider);
        return !state.isInitialized
            ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
            : RefreshIndicator(
                onRefresh: ref.read(devicesProvider).refresh,
                child: ListView.separated(
                  itemBuilder: (context, index) => ListTile(
                    title: Text(state.devices[index].name),
                    onTap: () =>
                        _deviceTilePress(context, ref, state.devices[index]),
                    trailing: StatusIndicator(device: state.devices[index]),
                  ),
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemCount: state.devices.length,
                ),
              );
      }),
    );
  }

  ///
  Future<void> _timeoutConfigButtonPress(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final initialValue =
        ref.read(discoveryTimeoutConfigProvider).state.toDouble();

    final selectedValue = await showDialog<double>(
      context: context,
      builder: (context) => ChangeTimeoutDialog(initialValue: initialValue),
    );

    if (selectedValue != null) {
      ref.read(discoveryTimeoutConfigProvider).state = selectedValue.toInt();
    }
  }

  ///
  void _deviceTilePress(BuildContext context, WidgetRef ref, Device device) {
    ref.read(deviceStatusProvider(device)).when(
          data: (status) => showStream(context, ref, status, device),
          loading: (previous) {},
          error: (error, stack, _) {
            showError(context, error as Exception, stack);
          },
        );
  }

  ///
  Future<void> showStream(
    BuildContext context,
    WidgetRef ref,
    SystemStatus status,
    Device device,
  ) async {
    ref.read(selectedDeviceProvider).state = device;
    ref.read(selectedDeviceStatusProvider).state = status;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const StreamingScreen(),
      ),
    );

    ref.read(devicesProvider).devices.forEach((device) {
      ref.refresh(deviceStatusProvider(device));
    });
  }

  ///
  void showError(BuildContext context, Exception error, StackTrace? stack) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Fehler'),
        content: Text(error.toString()),
      ),
    );
  }
}
