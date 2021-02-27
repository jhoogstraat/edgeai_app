import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/discovery/connect_screen.dart';
import 'logging.dart';

void main() async {
  initLogger();
  runApp(ProviderScope(
    child: ObjectDetectBoardApp(),
    // observers: [RiverpodLogger()],
  ));
}

class ObjectDetectBoardApp extends StatelessWidget {
  final theme =
      ThemeData.from(colorScheme: ColorScheme.dark(primary: Colors.white));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EdgeAI',
      theme: theme,
      home: const ConnectScreen(),
    );
  }
}
