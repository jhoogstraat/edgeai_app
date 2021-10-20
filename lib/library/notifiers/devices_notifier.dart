import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/config_providers.dart';
import '../providers/service_providers.dart';
import '../models/device.dart';

class DevicesNotifier extends ChangeNotifier {
  // State
  bool _isSearching = false;
  bool get isSearching => _isSearching;

  Object? error;
  List<Device> _mdnsDevices = [];
  final List<Device> _manualDevices = [];
  List<Device> get devices => [..._mdnsDevices, ..._manualDevices];

  final Reader _read;

  DevicesNotifier(this._read) {
    refresh();
  }

  Future<void> refresh() async {
    final timeout = _read(discoveryTimeoutConfigProvider).state;

    if (_isSearching == true) {
      return;
    }

    error = null;
    _isSearching = true;

    // Interferes with RefreshIndicator
    // notifyListeners();

    try {
      _mdnsDevices =
          await _read(mdnsProvider).discoverDevices(Duration(seconds: timeout));
    } catch (err, stack) {
      error = err;
    }

    _isSearching = false;
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
