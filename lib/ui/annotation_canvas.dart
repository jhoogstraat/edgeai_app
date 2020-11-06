import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui';

import 'package:obj_detect_board/models/annotated_image.dart';

final _rectPaint = Paint()
  ..color = Colors.red
  ..style = PaintingStyle.stroke
  ..strokeWidth = 2;
final _textStyle = TextStyle(
  color: Colors.red,
  fontSize: 20,
);

final _zeroPaint = Paint();

class AnnotationCanvas extends CustomPainter {
  AnnotationCanvas(this.annotatedImage);

  AnnotatedImage annotatedImage;

  @override
  void paint(Canvas canvas, Size size) {
    if (annotatedImage == null || annotatedImage.img == null) return;

    // Scale the canvas to fit the image
    final scaleY = size.height / annotatedImage.img.height;
    final scaleX = size.width / annotatedImage.img.width;
    canvas.scale(min(scaleX, scaleY));

    // Draw the image onto the canvas
    canvas.drawImage(annotatedImage.img, Offset.zero, _zeroPaint);

    final imgWidth = annotatedImage.img.width;
    final imgHeight = annotatedImage.img.height;

    for (var detection in annotatedImage.detections) {
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
