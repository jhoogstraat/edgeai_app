import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui';

import 'package:obj_detect_board/models/annotated_image.dart';

class AnnotationCanvas extends CustomPainter {
  AnnotationCanvas(this.annotatedImage);

  AnnotatedImage annotatedImage;

  final _imgPaint = Paint();
  final _rectPaint = Paint()..style = PaintingStyle.stroke..strokeWidth = 2;
  final _textStyle = TextStyle(
    color: Colors.black,
    fontSize: 15,
  );

  @override
  void paint(Canvas canvas, Size size) {
    if (annotatedImage == null || annotatedImage.img == null) return;

    paintImage(image: annotatedImage.img, canvas: canvas, rect: Rect.fromLTWH(0, 0, size.width, size.height), fit: BoxFit.contain);

    final imgWidth = annotatedImage.img.width;
    final imgHeight = annotatedImage.img.height;

    for (var detection in annotatedImage.detections) {
      final rect = Rect.fromLTRB(
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

      textPainter.layout(minWidth: 0, maxWidth: rect.width);
      textPainter.paint(canvas, rect.bottomLeft);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
