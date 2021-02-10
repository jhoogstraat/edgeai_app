import 'package:flutter/painting.dart';

class Feature {
  final int id;
  final double score;
  final Rect bbox;

  Feature(this.id, this.score, this.bbox);

  factory Feature.fromJson(dynamic json) {
    return Feature(
        json['id'],
        json['score'],
        Rect.fromLTRB(json['bbox'][0], json['bbox'][1], json['bbox'][2],
            json['bbox'][3]));
  }
}
