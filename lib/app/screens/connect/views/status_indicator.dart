import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../library/providers/app_providers.dart';
import '../../../../library/models/device.dart';

class StatusIndicator extends ConsumerWidget {
  final Device device;
  static const _iconSize = 16.0;

  const StatusIndicator({Key? key, required this.device}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(deviceStatusProvider(device)).when(
          data: (status) => status.isRunning
              ? const Icon(Icons.circle, color: Colors.green, size: _iconSize)
              : const Icon(Icons.circle, color: Colors.red, size: _iconSize),
          loading: (previous) => const SizedBox(
            width: _iconSize,
            height: _iconSize,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),
          error: (error, stack, _) => const Icon(Icons.error, size: _iconSize),
        );
  }
}
