import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obj_detect_board/models/device.dart';
import 'package:obj_detect_board/models/feature_set.dart';
import 'package:socket_io_client/socket_io_client.dart';
import '../models/ai_image.dart';
import '../models/status.dart';

import 'package:socket_io_client/socket_io_client.dart' as socket_io;
import 'package:http/http.dart' as http;

final selectedDeviceProvider = StateProvider<Device>((ref) => null);

final apiProvider = Provider.autoDispose((ref) {
  final device = ref.watch(selectedDeviceProvider).state;
  final api = Api(device.ip);
  print('created api for device ${device.ip}');

  ref.onDispose(() {
    print('disposing api');
    api.dispose();
  });

  return api;
});

class Api {
  final String host;
  final Socket _socket;
  final _socketFrameResponse = StreamController<AIImage>();
  final _socketSetResponse = StreamController<FeatureSet>();

  Api(this.host)
      : _socket = socket_io.io(
            'ws://$host:5000',
            OptionBuilder()
                .setTransports(['websocket'])
                .enableAutoConnect()
                .enableForceNewConnection()
                .build());

  Future<Status> startStream() async {
    final response = await http.get('http://$host:5000/start');
    final status = Status.fromJson(jsonDecode(response.body));
    return status;
  }

  Stream<AIImage> listenFrames() {
    _socket.on('frame', (msg) async {
      final aiImage = await AIImage.fromMessage(msg);
      _socketFrameResponse.add(aiImage);
    });

    return _socketFrameResponse.stream;
  }

  Stream<FeatureSet> listenFeatureSets() {
    _socket.on('set', (msg) async {
      final featureSet = await FeatureSet.fromMessage(msg);
      _socketSetResponse.add(featureSet);
    });

    return _socketSetResponse.stream;
  }

  Future<Status> fetchStatus() async {
    final response = await http.get('http://192.168.1.27:5000');
    return Status.fromJson(jsonDecode(response.body));
  }

  void dispose() {
    _socket.dispose();
    _socketFrameResponse.close();
    _socketSetResponse.close();
  }
}
