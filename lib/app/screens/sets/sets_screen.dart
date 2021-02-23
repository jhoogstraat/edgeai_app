import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers.dart';

class ImagePainter extends CustomPainter {
  final ui.Image image;

  ImagePainter(this.image);

  @override
  void paint(Canvas canvas, Size size) {
    paintImage(
        canvas: canvas,
        rect: Rect.fromLTWH(0, 0, size.width, size.height),
        image: image);
  }

  @override
  bool shouldRepaint(covariant ImagePainter oldDelegate) {
    return oldDelegate.image != image;
  }
}

class SetsScreen extends StatelessWidget {
  const SetsScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sets'),
        actions: [
          IconButton(
              icon: const Icon(Icons.delete_forever, color: Colors.red),
              onPressed: () => context.read(featureSetsProvider).clear())
        ],
      ),
      body: Consumer(
        builder: (context, watch, child) {
          final sets = watch(featureSetsProvider);

          return ListView.separated(
              itemBuilder: (context, index) {
                final featureSet = sets[index];

                return ListTile(
                  title: Text('Set ID 000'),
                  subtitle: Text(featureSet.timestamp.toIso8601String()),
                  minVerticalPadding: 25,
                  leading: SizedBox(
                    width: 56,
                    height: 56,
                    child: CustomPaint(
                      painter: ImagePainter(featureSet.referenceFrame),
                    ),
                  ),
                  trailing: Container(
                    height: double.infinity,
                    child: featureSet.isComplete
                        ? const Icon(Icons.check_circle_outline,
                            color: Colors.green)
                        : const Icon(Icons.error, color: Colors.red),
                  ),
                );
              },
              separatorBuilder: (_, __) => Divider(height: 1),
              itemCount: sets.length);
        },
      ),
    );
  }
}
