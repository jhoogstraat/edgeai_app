import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../library/providers/app_providers.dart';
import '../../library/services/api.dart';
import '../set_history/sets_screen.dart';
import 'views/feature_stepper.dart';
import 'views/property_view.dart';
import 'views/stream_view.dart';
import 'views/stream_zoom.dart';

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
            icon: const Icon(Icons.list_alt),
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
                      MaterialPageRoute(builder: (context) => StreamZoom()),
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
                            : () => _configureButtonPress(context),
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

  void _configureButtonPress(BuildContext context) {
    final status = context.read(selectedDeviceStatusProvider);
    final sliderValue = ValueNotifier(status.state.minPercentage);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Konfigurieren'),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 10, 24),
        content: Consumer(
          builder: (context, watch, child) {
            // Makes sure the checkedSetProvider is disposed properly when the dialog is dismissed.
            final state = watch(checkedSetProvider);
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...status.state.labels.entries
                    .map((e) => FeatureStepper(
                          featureId: e.key,
                          title: e.value,
                          value: state.listen(e.key),
                        ))
                    .toList(),
                Text('Min-Prozentsatz'),
                ValueListenableBuilder(
                  valueListenable: sliderValue,
                  builder: (context, value, child) => Slider(
                    value: value,
                    divisions: 10,
                    label: value.toString(),
                    onChanged: (newValue) => sliderValue.value = newValue,
                  ),
                )
              ],
            );
          },
        ),
        actions: [
          ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Abbrechen')),
          ElevatedButton(
            onPressed: () => saveConfigButtonPressed(
                context,
                context.read(checkedSetProvider).newCheckedSet,
                sliderValue.value),
            child: Text('Speichern'),
          ),
        ],
      ),
    );
  }

  Future<void> saveConfigButtonPressed(BuildContext context,
      Map<String, int> checkedSet, double minPercentage) async {
    final host = context.read(selectedDeviceProvider).state.ip;
    final status = await Api.configure(host,
        checkedSet: checkedSet, minPercentage: minPercentage);
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
