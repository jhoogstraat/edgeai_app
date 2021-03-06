import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/config_providers.dart';
import '../providers/service_providers.dart';
import '../models/device.dart';

class DevicesNotifier extends ChangeNotifier {
  // State
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  List<Device> _mdnsDevices = [];
  final List<Device> _manualDevices = [];
  List<Device> get devices => [..._mdnsDevices, ..._manualDevices];

  final Reader _read;

  DevicesNotifier(this._read) {
    refresh();
  }

  Future<void> refresh() async {
    final timeout = _read(discoveryTimeoutProvider).state;
    _mdnsDevices =
        await _read(mdnsProvider).discoverDevices(Duration(seconds: timeout));
    _isInitialized = true;
    notifyListeners();
  }

  void addDevice(String ip) {
    _manualDevices.add(Device(ip, ip));
    notifyListeners();
  }

  void removeDevice(int index) {
    _manualDevices.removeAt(index);
    notifyListeners();
  }
}
