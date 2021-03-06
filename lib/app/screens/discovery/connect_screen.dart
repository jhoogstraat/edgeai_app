import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../streaming/streaming_screen.dart';
import '../../../library/models/status.dart';
import '../../../library/providers/config_providers.dart';

import '../../../library/providers/app_providers.dart';
import 'views/change_timeout_dialog.dart';
import '../../../library/models/device.dart';

import 'views/add_device_dialog.dart';
import 'views/status_indicator.dart';

class ConnectScreen extends StatelessWidget {
  const ConnectScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer(builder: (context, watch, child) {
          final devices = watch(devicesProvider);
          return devices.isInitialized
              ? Text('${devices.devices.length} Gerät(e) gefunden')
              : const Text('Suche nach Geräten...');
        }),
        actions: [
          IconButton(
              icon: const Icon(Icons.timelapse),
              onPressed: () => _timeoutConfigButtonPress(context)),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => showDialog(
              barrierDismissible: false,
              context: context,
              builder: (_) => AddDeviceDialog(),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: context.read(devicesProvider).refresh,
        child: Consumer(
          builder: (context, watch, child) {
            final state = watch(devicesProvider);

            if (!state.isInitialized) {
              return Center(
                child: const CircularProgressIndicator(strokeWidth: 2),
              );
            }

            return ListView.separated(
              itemBuilder: (context, index) => ListTile(
                title: Text(state.devices[index].name),
                onTap: () => _deviceTilePress(context, state.devices[index]),
                trailing: StatusIndicator(state.devices[index]),
              ),
              separatorBuilder: (_, __) => Divider(height: 1),
              itemCount: state.devices.length,
            );
          },
        ),
      ),
    );
  }

  ///
  Future<void> _timeoutConfigButtonPress(BuildContext context) async {
    final sliderValue = ValueNotifier(
      context.read(discoveryTimeoutProvider).state.toDouble(),
    );

    await showDialog(
      context: context,
      builder: (context) {
        return ChangeTimeoutDialog(sliderValue: sliderValue);
      },
    );

    context.read(discoveryTimeoutProvider).state = sliderValue.value.toInt();
  }

  ///
  void _deviceTilePress(BuildContext context, Device device) {
    context.read(deviceStatusProvider(device)).when(
          data: (status) => showStream(context, status, device),
          loading: () {},
          error: (error, stack) => showError(context, error, stack),
        );
  }

  ///
  Future<void> showStream(
      BuildContext context, Status status, Device device) async {
    context.read(selectedDeviceProvider).state = device;
    context.read(selectedDeviceStatusProvider).state = status;

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const StreamingScreen()),
    );

    context.read(devicesProvider).devices.forEach((device) {
      context.refresh(deviceStatusProvider(device));
    });
  }

  ///
  void showError(BuildContext context, Object error, StackTrace stack) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Fehler'),
        content: Text(error.toString()),
      ),
    );
  }
}
