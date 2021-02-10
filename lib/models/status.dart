import 'package:flutter/painting.dart';

class Status {
  final Size frameSizeOriginal;
  final Size frameSizeCropped;
  final Size inputSize;
  final Map<String, String> labels;
  final Map<String, int> checkedSet;
  final bool isRunning;

  Status(this.frameSizeOriginal, this.frameSizeCropped, this.inputSize,
      this.labels, this.checkedSet, this.isRunning);

  factory Status.fromJson(Map<String, dynamic> json) {
    final frameSizeOriginal = Size(json['frameSize']['original']['width'],
        json['frameSize']['original']['height']);
    final frameSizeCropped = Size(json['frameSize']['cropped']['width'],
        json['frameSize']['cropped']['height']);
    final inputSize =
        Size(json['inputSize']['width'], json['inputSize']['height']);
    final labels = json['labels'] as Map<String, String>;
    final checkedSet = json['set'] as Map<String, int>;
    final isRunning = json['isRunning'];

    return Status(frameSizeOriginal, frameSizeCropped, inputSize, labels,
        checkedSet, isRunning);
  }
}
