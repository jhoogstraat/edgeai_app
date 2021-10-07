import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../models/motor_status.dart';

import '../models/feature_set.dart';
import 'package:socket_io_client/socket_io_client.dart';
import '../models/ai_image.dart';
import '../models/status.dart';

import 'package:http/http.dart' as http;

class Api {
  final String host;
  final Socket _socket;
  final _socketFrameReceiver = StreamController<AIImage>();
  final _socketSetReceiver = StreamController<FeatureSet>();

  Api(this.host)
      : _socket = io(
            'ws://$host:5000',
            OptionBuilder()
                .setTransports(['websocket'])
                .enableAutoConnect()
                .enableForceNewConnection()
                .build());

  Future<SystemStatus> startService() async {
    final response = await http.get(Uri.http('$host:5000', 'start'));
    final status = SystemStatus.fromJson(jsonDecode(response.body));
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

  Future<MotorStatus> startMotor() async {
    final response = await http.post(Uri.http('$host:5000', "motor/start"));
    return MotorStatus.fromJson(jsonDecode(response.body));
  }

  Future<MotorStatus> stopMotor() async {
    final response = await http.post(Uri.http('$host:5000', "motor/stop"));
    return MotorStatus.fromJson(jsonDecode(response.body));
  }

  Future<MotorStatus> accelerateMotor() async {
    final response =
        await http.post(Uri.http('$host:5000', "motor/accelerate"));
    return MotorStatus.fromJson(jsonDecode(response.body));
  }

  Future<MotorStatus> decelerateMotor() async {
    final response =
        await http.post(Uri.http('$host:5000', "motor/decelerate"));
    return MotorStatus.fromJson(jsonDecode(response.body));
  }

  Future<MotorStatus> reverseMotor() async {
    final response = await http.post(Uri.http('$host:5000', "motor/reverse"));
    return MotorStatus.fromJson(jsonDecode(response.body));
  }

  Future<MotorStatus> motorStatus() async {
    final response = await http.get(Uri.http('$host:5000', "motor/status"));
    return MotorStatus.fromJson(jsonDecode(response.body));
  }

  static Future<SystemStatus> _fetchStatus(String host, String path) async {
    final response = await http.get(Uri.http('$host:5000', path));
    return SystemStatus.fromJson(jsonDecode(response.body));
  }

  static Future<SystemStatus> _updateStatus(String host, String path,
      [String? json]) async {
    final response = await http.post(Uri.http('$host:5000', path),
        body: json,
        headers: json == null
            ? null
            : {HttpHeaders.contentTypeHeader: 'application/json'});
    return SystemStatus.fromJson(jsonDecode(response.body));
  }

  static Future<SystemStatus> start(String host) =>
      _updateStatus(host, 'start');

  static Future<SystemStatus> stop(String host) => _updateStatus(host, 'stop');

  static Future<SystemStatus> fetchStatus(String host) =>
      _fetchStatus(host, 'status');

  static Future<SystemStatus> configure(String host,
      {required Map<String, int> checkedSet, required double? minPercentage}) {
    final json = jsonEncode({
      'set': checkedSet..removeWhere((key, value) => value == 0),
      'minPercentage': minPercentage
    });
    return _updateStatus(host, 'configureUsecase', json);
  }

  void dispose() {
    _socket.dispose();
    _socketFrameReceiver.close();
    _socketSetReceiver.close();
  }
}
