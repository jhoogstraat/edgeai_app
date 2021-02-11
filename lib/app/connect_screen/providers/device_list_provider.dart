import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/device.dart';
import '../../../services/mdns.dart';

final deviceListProvider =
    ChangeNotifierProvider((ref) => DeviceListState(ref.read));

class DeviceListState extends ChangeNotifier {
  // State
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  List<Device> _mdnsDevices = [];
  final List<Device> _manualDevices = [];
  List<Device> get devices => [..._mdnsDevices, ..._manualDevices];

  final Reader _read;

  DeviceListState(this._read) {
    refreshDevices();
  }

  Future<void> refreshDevices() async {
    _mdnsDevices = await _read(mdnsProvider).discoverDevices();
    _isInitialized = true;
    notifyListeners();
  }

  void addDevice(String ip) {
    _manualDevices.add(Device('Manual', ip));
    notifyListeners();
  }

  void removeDevice(int index) {
    _manualDevices.removeAt(index);
    notifyListeners();
  }
}
