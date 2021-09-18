import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_providers.dart';
import '../services/api.dart';
import '../services/mdns.dart';

/// Automatically discover devices from other providers.
final mdnsProvider = Provider((ref) => MDNSService());

/// Provides an api to the currently selected edge device.
final apiProvider = Provider.autoDispose((ref) {
  final device = ref.watch(selectedDeviceProvider);
  final api = Api(device.ip);
  ref.onDispose(() => api.dispose());
  return api;
});
