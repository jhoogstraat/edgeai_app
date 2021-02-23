import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

import '../models/feature_set.dart';
import 'package:socket_io_client/socket_io_client.dart';
import '../models/ai_image.dart';
import '../models/status.dart';

import 'package:socket_io_client/socket_io_client.dart' as socket_io;
import 'package:http/http.dart' as http;

class Api {
  final String host;
  final Socket _socket;
  final _socketFrameReceiver = StreamController<AIImage>();
  final _socketSetReceiver = StreamController<FeatureSet>();

  Api(this.host)
      : _socket = socket_io.io(
            'ws://$host:5000',
            OptionBuilder()
                .setTransports(['websocket'])
                .enableAutoConnect()
                .enableForceNewConnection()
                .build());

  Future<Status> startStream() async {
    final response = await http.get(Uri.http('$host:5000', 'start'));
    final status = Status.fromJson(jsonDecode(response.body));
    return status;
  }

  Stream<AIImage> listenFrames() {
    _socket.on('frame', (msg) async {
      final aiImage = await AIImage.fromMessage(msg);
      _socketFrameReceiver.add(aiImage);
    });

    return _socketFrameReceiver.stream;
  }

  Stream<FeatureSet> listenFeatureSets() {
    _socket.on('set', (msg) async {
      final featureSet = await FeatureSet.fromMessage(msg);
      _socketSetReceiver.add(featureSet);
    });

    return _socketSetReceiver.stream;
  }

  static Future<Status> _fetchStatus(String host, String path) async {
    final response = await http.get(Uri.http('$host:5000', path));
    return Status.fromJson(jsonDecode(response.body));
  }

  static Future<Status> _updateStatus(String host, String path,
      [String json]) async {
    final response = await http.post(Uri.http('$host:5000', path),
        body: json,
        headers: json == null
            ? null
            : {HttpHeaders.contentTypeHeader: 'application/json'});
    print(response.body);
    return Status.fromJson(jsonDecode(response.body));
  }

  static Future<Status> start(String host) => _updateStatus(host, 'start');
  static Future<Status> stop(String host) => _updateStatus(host, 'stop');
  static Future<Status> fetchStatus(String host) =>
      _fetchStatus(host, 'status');

  static Future<Status> configure(String host,
      {@required Map<String, int> checkedSet, double percentage = 0.3}) {
    final json = jsonEncode({
      'set': checkedSet..removeWhere((key, value) => value == 0),
      'percentage': percentage
    });
    return _updateStatus(host, 'configure', json);
  }

  void dispose() {
    _socket.dispose();
    _socketFrameReceiver.close();
    _socketSetReceiver.close();
  }
}
