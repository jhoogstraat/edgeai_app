import 'package:edgeai_app/app/screens/connect/connect_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../library/models/device.dart';
import '../../../library/models/status.dart';
import '../../../library/notifiers/devices_notifier.dart';
import '../../../library/providers/app_providers.dart';
import '../../../library/providers/config_providers.dart';
import '../streaming/streaming_screen.dart';
import 'views/add_device_dialog.dart';
import 'views/change_timeout_dialog.dart';
import 'views/status_indicator.dart';

class ConnectScreen extends ConsumerWidget {
  const ConnectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Show Dialog on error
    ref.listen<Object?>(viewModelProvider.select((value) => value.error),
        (_, error) {
      if (error != null) {
        showErrorDialog(context, Exception(error), null);
      }
    });

    final viewModel = ref.watch(viewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(viewModel.title),
        actions: [
          IconButton(
              onPressed: ref.read(devicesProvider).refresh,
              icon: const Icon(Icons.refresh)),
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
      body: RefreshIndicator(
        onRefresh: ref.read(devicesProvider).refresh,
        child: viewModel.isSearching
            ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
            : ListView.separated(
                itemBuilder: (context, index) => ListTile(
                  title: Text(viewModel.devices[index].name),
                  onTap: () => _deviceTilePress(
                    context,
                    ref,
                    viewModel.devices[index],
                  ),
                  trailing: StatusIndicator(
                    device: viewModel.devices[index],
                  ),
                ),
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemCount: viewModel.devices.length,
              ),
      ),
    );
  }

  ///
  Future<void> _timeoutConfigButtonPress(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final initialValue = ref.read(discoveryTimeoutConfigProvider).toDouble();

    final selectedValue = await showDialog<double>(
      context: context,
      builder: (context) => ChangeTimeoutDialog(initialValue: initialValue),
    );

    if (selectedValue != null) {
      ref.read(discoveryTimeoutConfigProvider.notifier).state =
          selectedValue.toInt();
    }
  }

  ///
  void _deviceTilePress(BuildContext context, WidgetRef ref, Device device) {
    ref.read(deviceStatusProvider(device)).when(
          data: (status) =>
              navigateToStreamingScreen(context, ref, status, device),
          loading: () {},
          error: (error, stack) {
            showErrorDialog(context, error as Exception, stack);
          },
        );
  }

  Future<void> navigateToStreamingScreen(
    BuildContext context,
    WidgetRef ref,
    SystemStatus status,
    Device device,
  ) async {
    ref.read(selectedDeviceProvider.notifier).state = device;
    ref.read(selectedDeviceStatusProvider.notifier).state = status;

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

  Future<void> showErrorDialog(
    BuildContext context,
    Exception error,
    StackTrace? stack,
  ) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Fehler'),
        content: Text(error.toString()),
      ),
    );
  }
}
