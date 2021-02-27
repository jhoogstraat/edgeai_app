import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:obj_detect_board/library/models/ai_image.dart';

class AIImagePainter extends CustomPainter {
  AIImagePainter(this.aiImage);

  AIImage aiImage;

  static final _detectionBBoxPaint = Paint()
    ..color = Colors.red
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;

  static final _scoreTextStyle = TextStyle(
    color: Colors.red,
    fontSize: 12,
  );

  static final _emptyPaint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    if (aiImage == null || aiImage.frame == null) return;

    canvas.drawImage(aiImage.frame, Offset.zero, _emptyPaint);

    for (var obj in aiImage.features) {
      canvas.drawRect(obj.bbox, _detectionBBoxPaint);

      final textSpan = TextSpan(
        text: '(${(obj.score * 100).toInt()}%)',
        style: _scoreTextStyle,
      );

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );

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
