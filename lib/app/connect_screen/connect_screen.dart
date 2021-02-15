import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/device.dart';
import 'providers/device_list_provider.dart';
import '../device_screen/device_screen.dart';
import '../../services/api.dart';
import 'widgets/add_device_alert.dart';

class ConnectScreen extends StatelessWidget {
  const ConnectScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer(builder: (context, watch, child) {
          final devices = watch(deviceListProvider);
          return devices.isInitialized
              ? Text('${devices.devices.length} Gerät(e) gefunden')
              : Text('Suche nach Geräten...');
        }),
        actions: [
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
        onRefresh: () => context.read(deviceListProvider).refreshDevices(),
        child: Consumer(
          builder: (context, watch, child) {
            final state = watch(deviceListProvider);

            if (!state.isInitialized) {
              return Center(child: CircularProgressIndicator());
            }

            return ListView.separated(
              itemBuilder: (context, index) => ListTile(
                title: Text(state.devices[index].name),
                onTap: () => _deviceTilePress(context, state.devices[index]),
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
    context.read(selectedDeviceProvider).state = device;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DeviceScreen()),
    );
  }
}
