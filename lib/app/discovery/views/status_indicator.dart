import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../library/providers/app_providers.dart';
import '../../../library/models/device.dart';

class StatusIndicator extends StatelessWidget {
  StatusIndicator(this.device);

  final Device device;
  static const size = 16.0;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, status) {
      final statusFuture = watch(deviceStatusProvider(device));
      return statusFuture.when(
        data: (status) => status.isRunning
            ? const Icon(Icons.circle, color: Colors.green, size: size)
            : const Icon(Icons.circle, color: Colors.red, size: size),
        loading: () => SizedBox(
          width: size,
          height: size,
          child: Center(
            child: const CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        error: (error, stack) => Icon(Icons.error, size: 16),
      );
    });
  }
}
