import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../library/providers/app_providers.dart';
import '../../../common/custom_painters/aimage_painter.dart';

class StreamView extends StatelessWidget {
  const StreamView();

  @override
  Widget build(BuildContext context) {
    final status = context.read(selectedDeviceStatusProvider).state;
    bool _setCompleteIndicator;

    return ProviderListener(
      provider: featureSetsProvider,
      onChange: (context, featureSets) {
        _setCompleteIndicator = featureSets.last.isComplete;
        Future.delayed(
            const Duration(seconds: 1), () => _setCompleteIndicator = null);
      },
      child: FittedBox(
        alignment: Alignment.center,
        child: SizedBox(
          width: status.frameSizeCropped.width,
          height: status.frameSizeCropped.height,
          child: Consumer(
            builder: (context, watch, child) {
              final status = watch(selectedDeviceStatusProvider).state;
              return watch(frameProvider).when(
                data: (data) => status.isRunning
                    ? RepaintBoundary(
                        child: CustomPaint(
                          painter: AIImagePainter(
                              data, status.labels, _setCompleteIndicator),
                          willChange: true,
                        ),
                      )
                    : Center(child: _buildInactiveText(context)),
                loading: () => Center(
                  child: status.isRunning
                      ? SizedBox(
                          width: 70,
                          height: 70,
                          child: RepaintBoundary(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : _buildInactiveText(context),
                ),
                error: (error, _) => throw error,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInactiveText(BuildContext context) => Text(
        'INAKTIV',
        style: Theme.of(context).textTheme.headline3,
      );
}
