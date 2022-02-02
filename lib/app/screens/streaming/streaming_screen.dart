import 'views/motor_dialog.dart';
import '../../../library/providers/service_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../library/providers/app_providers.dart';
import '../../../library/services/api.dart';
import '../history/history_screen.dart';
import 'views/set_dialog.dart';
import 'views/property_view.dart';
import 'views/stream_view.dart';

/// Owned by [StreamingScreen].
/// Disables buttons when starting/stopping the service.
final _viewModelProvider = StateProvider.autoDispose((ref) => false);

class StreamingScreen extends ConsumerWidget {
  const StreamingScreen({Key? key}) : super(key: key);

  static const _bodyPadding = 20.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ref.read(selectedDeviceProvider).name),
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
            child: ListView(
              children: [
                const StreamView(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: _bodyPadding),
                  child: Consumer(
                    builder: (context, ref, child) {
                      final status = ref.watch(selectedDeviceStatusProvider);

                      return GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 20),
                        childAspectRatio: 2.0,
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
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: _bodyPadding, vertical: 8.0),
            child: Consumer(
              builder: (context, ref, child) {
                final viewModel = ref.watch(_viewModelProvider);
                final status = ref.watch(selectedDeviceStatusProvider);

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Flexible(
                          fit: FlexFit.tight,
                          child: ElevatedButton(
                              onPressed: viewModel
                                  ? null
                                  : () =>
                                      _configureSetButtonPress(context, ref),
                              child: const Text('Set')),
                        ),
                        const SizedBox(width: _bodyPadding),
                        Flexible(
                          fit: FlexFit.tight,
                          child: ElevatedButton(
                              onPressed: viewModel
                                  ? null
                                  : () => _configureMotorPress(context, ref),
                              child: const Text('Motor')),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: viewModel
                              ? null
                              : () => _toggleRunningButtonPress(ref),
                          child:
                              Text(status.isRunning ? 'Stoppen' : 'Starten')),
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

  Future<void> _toggleRunningButtonPress(WidgetRef ref) async {
    final viewModel = ref.read(_viewModelProvider.notifier);
    final status = ref.read(selectedDeviceStatusProvider.notifier);

    viewModel.state = true;

    if (!status.state.isRunning) {
      status.state = await Api.start(ref.read(selectedDeviceProvider).ip);
    } else {
      status.state = await Api.stop(ref.read(selectedDeviceProvider).ip);
    }

    viewModel.state = false;
  }

  void _configureSetButtonPress(BuildContext context, WidgetRef ref) {
    final status = ref.read(selectedDeviceStatusProvider.notifier);
    final sliderValue = ValueNotifier(status.state.minPercentage ?? 0.8);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SetDialog(sliderValue: sliderValue),
    );
  }

  Future<void> _configureMotorPress(BuildContext context, WidgetRef ref) async {
    final api = ref.read(apiProvider);
    final motorStatus = await api.motorStatus();
    ref.read(motorStatusProvider.notifier).state = motorStatus;

    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const MotorDialog(),
    );
  }
}
