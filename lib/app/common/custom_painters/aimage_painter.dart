import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../../library/models/ai_image.dart';

class AIImagePainter extends CustomPainter {
  AIImagePainter(this.aiImage, this.labels, [this.isSetComplete]);

  AIImage aiImage;
  bool? isSetComplete;
  Map<String, String> labels;

  static final _detectionBBoxPaint = Paint()
    ..color = Colors.red
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;

  static final _setCompleteIndicatorPaint = Paint()
    ..style = PaintingStyle.stroke
    ..color = Colors.green
    ..strokeWidth = 7;

  static final _setIncompleteIndicatorPaint = Paint()
    ..style = PaintingStyle.stroke
    ..color = Colors.red
    ..strokeWidth = 7;

  static const _scoreTextStyle = TextStyle(
    color: Colors.red,
    fontSize: 12,
  );

  static final _emptyPaint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImage(aiImage.frame, Offset.zero, _emptyPaint);

    for (var obj in aiImage.features) {
      canvas.drawRect(obj.bbox, _detectionBBoxPaint);

      final textSpan = TextSpan(
        text: '${labels[obj.id.toString()]} (${(obj.score * 100).toInt()}%)',
        style: _scoreTextStyle,
      );

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );

      if (isSetComplete != null) {
        canvas.drawRect(
            Rect.fromLTWH(3.5, 3.5, size.width - 7, size.height - 7),
            isSetComplete!
                ? _setCompleteIndicatorPaint
                : _setIncompleteIndicatorPaint);
      }

      textPainter.layout();
      textPainter.paint(
        canvas,
        obj.bbox.bottomLeft.translate(0, -textPainter.height),
      );
    }
  }

  @override
  bool shouldRepaint(covariant AIImagePainter oldDelegate) =>
      oldDelegate.aiImage != aiImage;
}
