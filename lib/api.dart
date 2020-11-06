import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'models/annotated_image.dart';

class Api {
  final _url = Uri.parse('http://192.168.1.27:5000/detect');

  StreamSubscription streamSub;
  bool get isAnalysing => streamSub != null;

  void startDetecting(void Function(AnnotatedImage) callback) async {
    final response = await http.Request("GET", _url).send();

    var data = "";

    streamSub = response.stream.listen((value) {
      final frames = utf8.decode(value).split("!!");

      if (frames.length > 1) {
        AnnotatedImage.fromJson(jsonDecode(data + frames.first)).then(callback);
        data = frames.last;
      } else {
        data += frames.first;
      }
    });
  }

  Future<void> stopDetecting() async {
    await streamSub.cancel();
    streamSub = null;
  }
}
