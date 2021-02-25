import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'notifiers/checked_set_notifier.dart';
import 'notifiers/devices_notifier.dart';
import 'notifiers/feature_set_notifier.dart';
import 'services/api.dart';
import 'services/mdns.dart';

import 'models/ai_image.dart';
import 'models/device.dart';
import 'models/status.dart';

final mdnsProvider = Provider((ref) => MDNSService());

final devicesProvider =
    ChangeNotifierProvider((ref) => DevicesNotifier(ref.read));

final deviceStatusProvider = FutureProvider.autoDispose
    .family<Status, Device>((ref, device) => Api.fetchStatus(device.ip));

final selectedDeviceProvider = StateProvider<Device>((ref) => null);
final selectedDeviceStatusProvider = StateProvider<Status>((ref) => null);

final checkedSetProvider = Provider.autoDispose<CheckedSetNotifier>(
  (ref) {
    final status = ref.read(selectedDeviceStatusProvider).state;
    return CheckedSetNotifier(status.labels.keys, status.checkedSet);
  },
);

final apiProvider = Provider.autoDispose<Api>((ref) {
  final device = ref.watch(selectedDeviceProvider).state;
  final api = Api(device.ip);
  ref.onDispose(() => api.dispose());
  return api;
});

final frameProvider = StreamProvider.autoDispose<AIImage>(
    (ref) => ref.watch(apiProvider).listenFrames());

final featureSetsProvider =
    ChangeNotifierProvider.autoDispose<FeatureSetsNotifier>((ref) =>
        FeatureSetsNotifier(ref.watch(apiProvider).listenFeatureSets()));
