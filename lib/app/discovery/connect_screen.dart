import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../library/providers/config_providers.dart';
import '../../library/providers/app_providers.dart';
import 'views/change_timeout_alert.dart';
import '../streaming/device_screen.dart';
import '../../library/models/device.dart';

import 'views/add_device_alert.dart';
import 'views/status_indicator.dart';

class ConnectScreen extends StatelessWidget {
  const ConnectScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer(builder: (context, watch, child) {
          final devices = watch(devicesProvider);
          return devices.isInitialized
              ? Text('${devices.devices.length} Gerät(e) gefunden')
              : Text('Suche nach Geräten...');
        }),
        actions: [
          IconButton(
              icon: const Icon(Icons.timelapse),
              onPressed: () => _timoutConfigButtonPress(context)),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => showDialog(
              barrierDismissible: false,
              context: context,
              builder: (_) => AddDeviceAlert(),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read(devicesProvider).refresh(),
        child: Consumer(
          builder: (context, watch, child) {
            final state = watch(devicesProvider);

            if (!state.isInitialized) {
              return Center(child: CircularProgressIndicator(strokeWidth: 2));
            }

            return ListView.separated(
              physics: AlwaysScrollableScrollPhysics(),
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

  void _deviceTilePress(BuildContext context, Device device) {
    context.read(deviceStatusProvider(device)).when(
          data: (status) async {
            context.read(selectedDeviceProvider).state = device;
            context.read(selectedDeviceStatusProvider).state = status;

            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DeviceScreen()),
            );

            context.read(devicesProvider).devices.forEach((device) {
              context.refresh(deviceStatusProvider(device));
            });
          },
          loading: () {},
          error: (error, stack) => showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Fehler'),
              content: Text(error.toString()),
            ),
          ),
        );
  }

  void _timoutConfigButtonPress(BuildContext context) {
    final textController = TextEditingController(
        text: context.read(timeoutSecondsConfigProvider).state.toString());

    showDialog(
        context: context,
        builder: (context) =>
            ChangeTimeoutAlert(textController: textController));
  }
}
