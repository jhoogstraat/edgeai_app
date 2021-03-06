import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../library/providers/app_providers.dart';
import '../../../library/services/api.dart';
import '../history/sets_screen.dart';
import 'views/config_dialog.dart';
import 'views/property_view.dart';
import 'views/stream_view.dart';

/// Owned by [StreamingScreen].
/// Disables buttons when starting/stopping the service.
final _viewModelProvider = StateProvider.autoDispose((ref) => false);

class StreamingScreen extends StatelessWidget {
  const StreamingScreen({Key key}) : super(key: key);

  static const _bodyPadding = 20.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.read(selectedDeviceProvider).state.name),
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
          const StreamView(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: _bodyPadding),
              child: Consumer(
                builder: (context, watch, child) {
                  final status = watch(selectedDeviceStatusProvider).state;

                  return GridView.count(
                    crossAxisCount: 2,
                    physics: NeverScrollableScrollPhysics(),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                    childAspectRatio: 3.0,
                    children: [
                      PropertyView(
                        title: 'MODEL',
                        value: status.model,
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
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: _bodyPadding, vertical: 8.0),
            child: Consumer(
              builder: (context, watch, child) {
                final viewModel = watch(_viewModelProvider);
                final status = context.read(selectedDeviceStatusProvider);

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: viewModel.state
                              ? null
                              : () => _configureButtonPress(context),
                          child: const Text('Konfigurieren')),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: viewModel.state
                              ? null
                              : () => _toggleRunningButtonPress(context),
                          child: Text(
                              status.state.isRunning ? 'Stoppen' : 'Starten')),
                    ),
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
      builder: (context) => ConfigDialog(sliderValue: sliderValue),
    );
  }
}