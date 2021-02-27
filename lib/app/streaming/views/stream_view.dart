import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../library/providers/app_providers.dart';
import '../../common/custom_painters/aimage_painter.dart';

final _setCompleteIndicator = ValueNotifier<Color>(Colors.transparent);

class StreamView extends StatelessWidget {
  StreamView({@required this.onTap});

  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final status = context.read(selectedDeviceStatusProvider).state;

    return ProviderListener(
      onChange: (context, featureSets) {
        final lastSet = featureSets.last;

        if (lastSet.isComplete) {
          _setCompleteIndicator.value = Colors.green;
        } else {
          _setCompleteIndicator.value = Colors.red;
        }

        Future.delayed(const Duration(seconds: 1), () {
          _setCompleteIndicator.value = Colors.transparent;
        });
      },
      provider: featureSetsProvider,
      child: ValueListenableBuilder(
        valueListenable: _setCompleteIndicator,
        builder: (context, color, child) {
          return ColoredBox(
            color: color,
            child: child,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: FittedBox(
            alignment: Alignment.center,
            child: Container(
              width: status.frameSizeCropped.width,
              height: status.frameSizeCropped.height,
              child: GestureDetector(
                onTap: onTap,
                child: Consumer(
                  builder: (context, watch, child) {
                    final status = watch(selectedDeviceStatusProvider).state;

                    return watch(frameProvider).when(
                      data: (data) => RepaintBoundary(
                        child: CustomPaint(
                          painter: AIImagePainter(data),
                          willChange: true,
                        ),
                      ),
                      loading: () => Center(
                        child: status.isRunning
                            ? SizedBox(
                                width: 70,
                                height: 70,
                                child: RepaintBoundary(
                                    child: CircularProgressIndicator()),
                              )
                            : Text(
                                'INAKTIV',
                                style: Theme.of(context).textTheme.headline3,
                              ),
                      ),
                      error: (error, _) => throw error,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
