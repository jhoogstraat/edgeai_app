import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../sets/sets_screen.dart';
import '../../../services/api.dart';
import '../../../providers.dart';
import 'widgets/property_view.dart';
import 'widgets/stream_view.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'widgets/feature_stepper.dart';
import 'widgets/zoom_route.dart';

/// Owned by [DeviceScreen].
/// Disables buttons when starting/stopping the service.
final _viewModelProvider = StateProvider.autoDispose((ref) => false);

class DeviceScreen extends StatelessWidget {
  const DeviceScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sets'),
        actions: [
          IconButton(
            icon: Icon(Icons.list_alt),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SetsScreen()),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.zero,
              child: Hero(
                tag: 'frame',
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: StreamView(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ZoomRoute()),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer(
              builder: (context, watch, child) {
                final device = context.read(selectedDeviceProvider).state;
                final status = watch(selectedDeviceStatusProvider).state;

                return GridView.count(
                  crossAxisCount: 2,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  childAspectRatio: 3.0,
                  children: [
                    PropertyView(
                      title: 'NAME',
                      value: device.name,
                    ),
                    PropertyView(
                      title: 'AUFLÖSUNG (KAMERA)',
                      value:
                          '${status.frameSize.width.toInt()} x ${status.frameSize.height.toInt()}',
                    ),
                    PropertyView(
                        title: 'STATUS',
                        value: status.isRunning ? 'AKTIV' : 'INAKTIV'),
                    PropertyView(
                        title: 'AUFLÖSUNG (CROPPED)',
                        value:
                            '${status.frameSizeCropped.width.toInt()} x ${status.frameSizeCropped.height.toInt()}'),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Consumer(
              builder: (context, watch, child) {
                final viewModel = watch(_viewModelProvider);
                final status = context.read(selectedDeviceStatusProvider);

                return Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                        onPressed: viewModel.state
                            ? null
                            : () => _toggleRunningButtonPress(context),
                        icon: Icon(status.state.isRunning
                            ? Icons.stop
                            : Icons.play_arrow),
                        label: Text(
                            status.state.isRunning ? 'Stoppen' : 'Starten')),
                    ElevatedButton.icon(
                        onPressed: viewModel.state
                            ? null
                            : () => _configureSetButtonPress(context),
                        icon: const Icon(Icons.settings),
                        label: const Text('Konfigurieren')),
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Future<void> _toggleRunningButtonPress(BuildContext context) async {
    final viewModel = context.read(_viewModelProvider);
    final status = context.read(selectedDeviceStatusProvider);

    viewModel.state = true;

    if (!status.state.isRunning) {
      status.state =
          await Api.start(context.read(selectedDeviceProvider).state.ip);
    } else {
      status.state =
          await Api.stop(context.read(selectedDeviceProvider).state.ip);
    }

    viewModel.state = false;
  }

  void _configureSetButtonPress(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Configure Set'),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 10, 24),
        content: Consumer(
          builder: (context, watch, child) {
            // Makes sure the checkedSetProvider is disposed properly when the dialog is dismissed.
            final state = watch(checkedSetProvider);
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: context
                  .read(selectedDeviceStatusProvider)
                  .state
                  .labels
                  .entries
                  .map((e) => FeatureStepper(
                        featureId: e.key,
                        title: e.value,
                        value: state.listen(e.key),
                      ))
                  .toList(),
            );
          },
        ),
        actions: [
          ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Abbrechen')),
          ElevatedButton(
              onPressed: () => saveCheckedListButtonPressed(context),
              child: Text('Speichern')),
        ],
      ),
    );
  }

  Future<void> saveCheckedListButtonPressed(BuildContext context) async {
    final host = context.read(selectedDeviceProvider).state.ip;
    final status = await Api.configure(host,
        checkedSet: context.read(checkedSetProvider).newCheckedSet);
    context.read(selectedDeviceStatusProvider).state = status;
    Navigator.pop(context);
  }
}

class FeatureSetListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final featureSets = watch(featureSetsProvider);
        return ListView.separated(
            itemBuilder: (context, index) => ListTile(
                  title: Text('Set ${featureSets[index].timestamp} - ' +
                      (featureSets[index].isComplete
                          ? 'vollständig'
                          : 'unvollständig')),
                  // trailing: mage.memory(featureSets[index].referenceFrame),
                  onTap: () => showSetDetail(context),
                ),
            separatorBuilder: (_, __) => Divider(),
            itemCount: featureSets.length);
      },
    );
  }

  void showSetDetail(BuildContext context) {
    showCupertinoModalBottomSheet(
        context: context, builder: (context) => Container());
  }
}
