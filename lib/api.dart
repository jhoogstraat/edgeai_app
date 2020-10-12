import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Detection {
  final String label;
  final double score;

  final double topLeftX;
  final double topLeftY;
  final double bottomRightX;
  final double bottomRightY;

  Detection(this.label, this.score, this.topLeftX, this.topLeftY,
      this.bottomRightX, this.bottomRightY);

  factory Detection.fromJson(dynamic json) {
    print(json[2][0][0]);
    return Detection(
        json[0],
        double.tryParse(json[1]),
        double.tryParse(json.parse(json[2][0][0])),
        double.tryParse(json.parse(json[2][0][1])),
        double.tryParse(json.parse(json[2][1][0])),
        double.tryParse(json.parse(json[2][1][1])));
  }
}

class AnnotatedImage {
  final Image img;
  final List<Detection> detections;

  AnnotatedImage(this.img, this.detections);

  factory AnnotatedImage.fromJson(dynamic json) {
    final List<dynamic> detections = json['detections'];
    return AnnotatedImage(
        json['img'], detections.map((d) => Detection.fromJson(d)).toList());
  }
}

class Api {
  final url = Uri.parse('http://192.168.1.25:5000/detect');

  Future<Stream<AnnotatedImage>> startDetecting() async {
    final response = await http.Request("GET", url).send();

    return response.stream.map(
        (event) => AnnotatedImage.fromJson(jsonDecode(utf8.decode(event))));
  }
}
