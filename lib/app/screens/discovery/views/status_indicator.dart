import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../library/providers/app_providers.dart';
import '../../../../library/models/device.dart';

class StatusIndicator extends StatelessWidget {
  StatusIndicator(this.device);

  final Device device;
  static const _iconSize = 16.0;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, status) {
      return watch(deviceStatusProvider(device)).when(
        data: (status) => status.isRunning
            ? const Icon(Icons.circle, color: Colors.green, size: _iconSize)
            : const Icon(Icons.circle, color: Colors.red, size: _iconSize),
        loading: () => SizedBox(
          width: _iconSize,
          height: _iconSize,
          child: Center(child: const CircularProgressIndicator(strokeWidth: 2)),
        ),
        error: (error, stack) => const Icon(Icons.error, size: _iconSize),
      );
    });
  }
}
