import 'dart:ui';

import '../models/motor_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifiers/checked_set_notifier.dart';
import '../notifiers/devices_notifier.dart';
import '../notifiers/feature_set_notifier.dart';
import '../models/ai_image.dart';
import '../models/device.dart';
import '../models/status.dart';
import 'service_providers.dart';
import '../services/api.dart';

/// Fetches the status of a given [Device].
final deviceStatusProvider = FutureProvider.autoDispose
    .family<SystemStatus, Device>((ref, device) => Api.fetchStatus(device.ip));

/// This Provider is scoped.
/// State holder of the user-selected [Device].
///
/// Set from UI
///
/// Workaround for now
/// https://github.com/rrousselGit/river_pod/issues/767
final selectedDeviceProvider = StateProvider<Device>(
  (ref) => const Device("", ""),
);

/// This is different to [deviceStatusProvider] in that it provides the [SystemStatus]
/// of the currently selected device.
///
/// Set from UI, to allow synchronous access
/// to the current [Device]s [SystemStatus].
///
/// Workaround for now.
/// https://github.com/rrousselGit/river_pod/issues/767
final selectedDeviceStatusProvider = StateProvider<SystemStatus>(
  (ref) => const SystemStatus(
      false, Size.zero, Size.zero, Size.zero, {}, {}, 0.0, ""),
);

/// Provides video frames coming from the edge device.
final frameProvider = StreamProvider.autoDispose<AIImage>(
  (ref) => ref.watch(apiProvider).listenFrames(),
  dependencies: [apiProvider],
);

///
final checkedSetProvider = Provider.autoDispose<CheckedSetNotifier>(
  (ref) {
    final status = ref.read(selectedDeviceStatusProvider).state;
    return CheckedSetNotifier(status.labels.keys, status.checkedSet);
  },
);

final devicesProvider = ChangeNotifierProvider(
  (ref) => DevicesNotifier(ref.read),
);

final featureSetsProvider =
    ChangeNotifierProvider.autoDispose<FeatureSetsNotifier>(
  (ref) => FeatureSetsNotifier(ref.watch(apiProvider).listenFeatureSets()),
  dependencies: [apiProvider],
);

final motorStatusProvider = StateProvider<MotorStatus>(
  (ref) => const MotorStatus(0, 0, false),
);
