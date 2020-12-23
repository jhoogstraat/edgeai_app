import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui';

import 'package:obj_detect_board/models/ai_image.dart';

class AImagePainter extends CustomPainter {
  static final _rectPaint = Paint()
    ..color = Colors.red
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;
  static final _textStyle = TextStyle(
    color: Colors.red,
    fontSize: 20,
  );
  static final _zeroPaint = Paint();

  AImagePainter(this.aiImage);

  AIImage aiImage;

  @override
  void paint(Canvas canvas, Size size) {
    if (aiImage == null || aiImage.image == null) return;

    // Scale the canvas to fit the image
    final scaleY = size.height / aiImage.image.height;
    final scaleX = size.width / aiImage.image.width;
    canvas.scale(min(scaleX, scaleY));

    // Draw the image onto the canvas
    canvas.drawImage(aiImage.image, Offset.zero, _zeroPaint);

    final imgWidth = aiImage.image.width;
    final imgHeight = aiImage.image.height;

    for (var detection in aiImage.detections) {
      final rect = Rect.fromLTWH(
          detection.left * imgWidth,
          detection.top * imgHeight,
          detection.right * imgWidth,
          detection.bottom * imgHeight);

      canvas.drawRect(rect, _rectPaint);

      final textSpan = TextSpan(
        text: detection.label + "(${(detection.score * 100).toInt()}%)",
        style: _textStyle,
      );

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(canvas, rect.bottomLeft);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
