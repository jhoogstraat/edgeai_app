import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'models/annotated_image.dart';

class Api {
  final _url = Uri.parse('http://192.168.1.51:5000/detect');

  StreamSubscription streamSub;

  void startDetecting(void Function(AnnotatedImage) callback) async {
    final response = await http.Request("GET", _url).send();

    var part = "";

    streamSub = response.stream.listen((value) {
      final decodedString = utf8.decode(value);
      //debugPrint("----------NEW-------------");

      if (decodedString.endsWith("!!")) {
        final imageJson = part + decodedString.substring(0, decodedString.length-2);
        //debugPrint(part, wrapWidth: 1024);
        AnnotatedImage.fromJson(jsonDecode(imageJson)).then(callback);
        part = "";
      } else {
        part += decodedString;
      }
    });
  }

  void stopDetecting() {
    streamSub.cancel();
  }
}
