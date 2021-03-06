import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../library/providers/app_providers.dart';
import '../../common/custom_painters/image_painter.dart';

class SetsScreen extends StatelessWidget {
  const SetsScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sets'),
        actions: [
          IconButton(
              icon: const Icon(Icons.delete_forever),
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
                  title: Text('Set-ID ${featureSet.id}'),
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
