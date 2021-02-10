import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obj_detect_board/models/device.dart';
import 'package:obj_detect_board/services/mdns.dart';

final deviceListStateProvider =
    ChangeNotifierProvider((ref) => DevicesRefreshState(ref.read));

class DevicesRefreshState extends ChangeNotifier {
  // State
  bool isInitialized = false;
  List<Device> _devices = [];
  List<Device> get devices => _devices;

  final Reader _read;

  DevicesRefreshState(this._read) {
    refreshDeviceList();
  }

  Future<void> refreshDeviceList() async {
    _devices = await _read(mdnsProvider).discoverDevices();
    isInitialized = true;
    notifyListeners();
  }

  void addManualDevice(String ip) {
    _devices.add(Device('Manual', ip));
    notifyListeners();
  }
}
