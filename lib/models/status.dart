import 'package:flutter/painting.dart';

class Status {
  final Size frameSize;
  final Size frameSizeCropped;
  final Size inputSize;
  final Map<String, String> labels;
  final Map<String, int> checkedSet;
  final bool isRunning;

  Status(this.frameSize, this.frameSizeCropped, this.inputSize, this.labels,
      this.checkedSet, this.isRunning);

  factory Status.fromJson(Map<String, dynamic> json) {
    final frameSizeOriginal = sizeFrom(json['frameSize']['original']);
    final frameSizeCropped = sizeFrom(json['frameSize']['crop']);
    final inputSize = sizeFrom(json['inputSize']);
    final labels = json['labels'].cast<String, String>();
    final checkedSet = json['set'].cast<String, int>();
    final isRunning = json['isRunning'];

    return Status(frameSizeOriginal, frameSizeCropped, inputSize, labels,
        checkedSet, isRunning);
  }

  static Size sizeFrom(dynamic json) {
    return Size(json['width'].toDouble(), json['height'].toDouble());
  }
}
