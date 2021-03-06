import 'package:flutter/painting.dart';

class Status {
  final Size frameSize;
  final Size frameSizeCropped;
  final Size inputSize;
  final Map<String, String> labels;
  final Map<String, int> checkedSet;
  final double minPercentage;
  final bool isRunning;
  final String model;

  Status(this.isRunning, this.frameSize, this.frameSizeCropped, this.inputSize,
      this.labels, this.checkedSet, this.minPercentage, this.model);

  factory Status.fromJson(Map<String, dynamic> json) {
    final isRunning = json['isRunning'];
    final frameSizeOriginal = sizeFrom(json['frameSize']['original']);
    final frameSizeCropped = sizeFrom(json['frameSize']['crop']);
    final inputSize = sizeFrom(json['inputSize']);
    final labels = json['labels'].cast<String, String>();
    final checkedSet = json['usecase']['set'].cast<String, int>();
    final minPercentage = json['usecase']['minPercentage'];
    final model = json['model'].replaceFirst('models/', '');

    return Status(isRunning, frameSizeOriginal, frameSizeCropped, inputSize,
        labels, checkedSet, minPercentage, model);
  }

  static Size sizeFrom(dynamic json) {
    return Size(json['width'].toDouble(), json['height'].toDouble());
  }
}
