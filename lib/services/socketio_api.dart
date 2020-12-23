import 'dart:async';

import 'package:obj_detect_board/models/ai_image.dart';

import 'api.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketIOApi implements Api {
  final _controller = StreamController<AIImage>();
  final _socket = IO.io('ws://192.168.1.27:5001', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false
  });

  SocketIOApi() : super();

  @override
  Stream<AIImage> listen() {
    _socket.on('frame', (msg) {
      
    });
  }
}
