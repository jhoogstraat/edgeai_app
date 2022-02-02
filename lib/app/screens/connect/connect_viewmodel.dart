import 'package:edgeai_app/library/providers/app_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../library/models/device.dart';

final viewModelProvider = Provider((ref) {
  final devices = ref.watch(devicesProvider);

  final title = devices.isSearching
      ? 'Suche nach Geräten...'
      : '${devices.devices.length} Gerät${devices.devices.length != 1 ? 'e' : ''} gefunden';

  return ConnectViewModel(
    title,
    devices.isSearching,
    devices.error,
    devices.devices,
  );
});

class ConnectViewModel {
  final String title;
  final bool isSearching;
  final Object? error;
  final List<Device> devices;

  ConnectViewModel(this.title, this.isSearching, this.error, this.devices);
}
