import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/config_providers.dart';
import '../providers/service_providers.dart';
import '../models/device.dart';

class DevicesNotifier extends ChangeNotifier {
  // Public Notifier state
  bool get isSearching => _isSearching;
  Object? error;
  List<Device> get devices => [..._mdnsFoundDevices, ..._manuallyAddedDevices];

  // Private state
  bool _isSearching = false;
  List<Device> _mdnsFoundDevices = [];
  final List<Device> _manuallyAddedDevices = [];
  final Reader _readProvider;

  DevicesNotifier(this._readProvider) {
    refresh();
  }

  Future<void> refresh() async {
    if (_isSearching == true) {
      return;
    }

    _isSearching = true;
    error = null;

    // Interferes with RefreshIndicator.. What does this?
    notifyListeners();

    final searchTimeout = _readProvider(discoveryTimeoutConfigProvider);
    try {
      _mdnsFoundDevices = await _readProvider(mdnsProvider)
          .discoverDevices(Duration(seconds: searchTimeout));
    } catch (err, _) {
      error = err;
    }

    _isSearching = false;

    notifyListeners();
  }

  void addDevice(String ip) {
    _manuallyAddedDevices.add(Device(ip, ip));
    notifyListeners();
  }

  void removeDevice(int index) {
    _manuallyAddedDevices.removeAt(index);
    notifyListeners();
  }
}
