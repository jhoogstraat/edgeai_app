import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifiers/checked_set_notifier.dart';
import '../notifiers/devices_notifier.dart';
import '../notifiers/feature_set_notifier.dart';
import '../models/ai_image.dart';
import '../models/device.dart';
import '../models/status.dart';
import 'service_providers.dart';
import '../services/api.dart';

final deviceStatusProvider = FutureProvider.autoDispose
    .family<Status, Device>((ref, device) => Api.fetchStatus(device.ip));

final selectedDeviceProvider = StateProvider<Device>((ref) => null);
final selectedDeviceStatusProvider = StateProvider<Status>((ref) => null);

final frameProvider = StreamProvider.autoDispose<AIImage>(
    (ref) => ref.watch(apiProvider).listenFrames());

final checkedSetProvider = Provider.autoDispose<CheckedSetNotifier>(
  (ref) {
    final status = ref.read(selectedDeviceStatusProvider).state;
    return CheckedSetNotifier(status.labels.keys, status.checkedSet);
  },
);

final devicesProvider =
    ChangeNotifierProvider((ref) => DevicesNotifier(ref.read));

final featureSetsProvider =
    ChangeNotifierProvider.autoDispose<FeatureSetsNotifier>((ref) =>
        FeatureSetsNotifier(ref.watch(apiProvider).listenFeatureSets()));
