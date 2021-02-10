import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:obj_detect_board/models/feature_set.dart';
import '../../services/api.dart';
import '../painters/aimage_painter.dart';
import '../../models/ai_image.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'home_view_model.dart';

final homeModelProvider = ChangeNotifierProvider((ref) => HomeViewModel());

final frameProvider = StreamProvider.autoDispose<AIImage>(
    (ref) => ref.watch(apiProvider).listenFrames());

final setListProvider = ChangeNotifierProvider.autoDispose(
    (ref) => FeatureSetList(ref.watch(apiProvider).listenFeatureSets()));

class HomeScreen extends StatelessWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sets'),
        actions: [
          IconButton(
            icon: Icon(Icons.not_started_outlined),
            onPressed: () => context.read(apiProvider).startStream(),
          )
        ],
      ),
      body: Column(
        children: [
          Flexible(
            flex: 1,
            child: FittedBox(
              child: SizedBox(
                width: 480,
                height: 480,
                child: Consumer(
                  builder: (context, watch, child) {
                    final frame = watch(frameProvider);
                    print(frame);
                    return frame.when(
                      data: (data) => CustomPaint(
                        painter: AIImagePainter(data),
                        willChange: true,
                      ),
                      loading: () => Center(child: CircularProgressIndicator()),
                      error: (error, _) {
                        throw error;
                      },
                    );
                  },
                ),
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Consumer(
              builder: (context, watch, child) {
                final featureSets = watch(setListProvider);
                return ListView.separated(
                    itemBuilder: (context, index) => ListTile(
                          title: Text('Set ${featureSets[index].timestamp} - ' +
                              (featureSets[index].isComplete
                                  ? 'vollständig'
                                  : 'unvollständig')),
                          onTap: () => showSetDetail(context),
                        ),
                    separatorBuilder: (_, __) => Divider(),
                    itemCount: featureSets.length);
              },
            ),
          )
        ],
      ),
    );
  }

  void showSetDetail(BuildContext context) {
    showCupertinoModalBottomSheet(
      context: context,
      builder: (context) => Container(),
    );
  }
}
