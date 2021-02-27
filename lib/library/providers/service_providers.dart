import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api.dart';
import '../services/mdns.dart';

import 'app_providers.dart';

final mdnsProvider = Provider((ref) => MDNSService());

final apiProvider = Provider.autoDispose<Api>((ref) {
  final device = ref.watch(selectedDeviceProvider).state;
  final api = Api(device.ip);
  ref.onDispose(() => api.dispose());
  return api;
});
