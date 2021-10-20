import 'dart:io';

import 'package:multicast_dns/multicast_dns.dart';

import '../models/device.dart';

class MDNSService {
  // reusePort is ignored on Android. Thrown error can be ignored.
  // See: https://github.com/flutter/flutter/issues/55173#issuecomment-655051797

  // Android does not find any devices if port != 0
  // See: https://stackoverflow.com/a/60488382
  static Future<RawDatagramSocket> socketFactory(dynamic host, int port,
      {bool? reuseAddress, bool? reusePort, int? ttl}) {
    return RawDatagramSocket.bind(host, 0,
        reuseAddress: true, reusePort: false, ttl: ttl!);
  }

  final client = MDnsClient(rawDatagramSocketFactory: socketFactory);

  Future<List<Device>> discoverDevices(
      [Duration timeout = const Duration(seconds: 1)]) async {
    // start() not work on iOS currently.
    // Patching multicast_dns.dart is necessary.
    // See: https://github.com/dart-lang/sdk/issues/42250#issuecomment-759026385
    await client.start();

    final devices = await client
        .lookup<PtrResourceRecord>(
            ResourceRecordQuery.serverPointer('_edgeai._tcp'),
            timeout: timeout)
        .asyncExpand((ptr) => client.lookup<SrvResourceRecord>(
            ResourceRecordQuery.service(ptr.domainName),
            timeout: timeout))
        .asyncExpand((srv) => client.lookup<IPAddressResourceRecord>(
            ResourceRecordQuery.addressIPv4(srv.target),
            timeout: timeout))
        .map((ip) =>
            Device(ip.name.replaceFirst('.local', ''), ip.address.address))
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    client.stop();
    return devices;
  }
}
