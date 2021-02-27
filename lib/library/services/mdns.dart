import 'package:multicast_dns/multicast_dns.dart';
import '../models/device.dart';

class MDNSService {
  // Fix for Android (https://github.com/flutter/flutter/issues/55173#issuecomment-655051797)

  final client = MDnsClient();

  Future<List<Device>> discoverDevices(
      [Duration timeout = const Duration(seconds: 1)]) async {
    // Does not work on iOS currently.
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
        .map((ip) => Device(ip.name, ip.address.address))
        .toList();

    devices.sort((a, b) => a.name.compareTo(b.name));

    await client.stop();
    return devices;
  }
}
