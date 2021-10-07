import 'package:flutter/painting.dart';

class Feature {
  final int id;
  final double score;
  final Rect bbox;

  const Feature(this.id, this.score, this.bbox);

  factory Feature.fromJson(dynamic json) {
    return Feature(
      json['id'],
      json['score'],
      Rect.fromLTRB(
        json['bbox'][0].toDouble(),
        json['bbox'][1].toDouble(),
        json['bbox'][2].toDouble(),
        json['bbox'][3].toDouble(),
      ),
    );
  }
}
