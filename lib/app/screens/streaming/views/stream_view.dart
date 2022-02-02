import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../library/notifiers/feature_set_notifier.dart';
import '../../../../library/providers/app_providers.dart';
import '../../../common/custom_painters/aimage_painter.dart';

class StreamView extends ConsumerWidget {
  const StreamView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool? _setCompleteIndicator;

    ref.listen(featureSetsProvider, (_, FeatureSetsNotifier featureSets) {
      _setCompleteIndicator = featureSets.last.isComplete;
      Future.delayed(
        const Duration(seconds: 1),
        () => _setCompleteIndicator = null,
      );
    });

    final status = ref.read(selectedDeviceStatusProvider);
    return FittedBox(
      alignment: Alignment.center,
      child: SizedBox(
        width: status.frameSizeCropped.width,
        height: status.frameSizeCropped.height,
        child: ref.watch(frameProvider).when(
              data: (data) => status.isRunning
                  ? RepaintBoundary(
                      child: CustomPaint(
                        painter: AIImagePainter(
                          data,
                          status.labels,
                          _setCompleteIndicator,
                        ),
                        willChange: true,
                      ),
                    )
                  : Center(child: _buildInactiveText(context)),
              loading: () => Center(
                child: status.isRunning
                    ? const SizedBox(
                        width: 70,
                        height: 70,
                        child: RepaintBoundary(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : _buildInactiveText(context),
              ),
              error: (error, _) => throw error,
            ),
      ),
    );
  }

  Widget _buildInactiveText(BuildContext context) => Text(
        'INAKTIV',
        style: Theme.of(context).textTheme.headline3,
      );
}
