import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../library/providers/app_providers.dart';
import '../../common/custom_painters/image_painter.dart';

class SetsScreen extends ConsumerWidget {
  const SetsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sets'),
        actions: [
          IconButton(
              icon: const Icon(Icons.delete_forever),
              onPressed: () => ref.read(featureSetsProvider).clear())
        ],
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final sets = ref.watch(featureSetsProvider);

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
                  trailing: SizedBox(
                    height: double.infinity,
                    child: featureSet.isComplete
                        ? const Icon(Icons.check_circle_outline,
                            color: Colors.green)
                        : const Icon(Icons.error, color: Colors.red),
                  ),
                );
              },
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemCount: sets.length);
        },
      ),
    );
  }
}
