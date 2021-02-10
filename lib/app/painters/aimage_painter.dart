import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../models/ai_image.dart';

class AIImagePainter extends CustomPainter {
  static final _rectPaint = Paint()
    ..color = Colors.red
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;

  static final _textStyle = TextStyle(
    color: Colors.red,
    fontSize: 12,
  );

  static final _zeroPaint = Paint();

  AIImagePainter(this.aiImage);

  AIImage aiImage;

  @override
  void paint(Canvas canvas, Size size) {
    if (aiImage == null || aiImage.frame == null) return;

    canvas.drawImage(aiImage.frame, Offset.zero, _zeroPaint);

    for (var obj in aiImage.features) {
      canvas.drawRect(obj.bbox, _rectPaint);

      final textSpan = TextSpan(
        text: '(${(obj.score * 100).toInt()}%)',
        style: _textStyle,
      );

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(
          canvas, obj.bbox.bottomLeft.translate(0, -textPainter.height));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; //
  }
}
