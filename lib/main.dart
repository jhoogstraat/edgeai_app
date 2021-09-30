import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obj_detect_board/app/screens/connect/connect_screen.dart';
import 'logging.dart';

void main() async {
  initLogger();
  runApp(ProviderScope(
    child: ObjectDetectBoardApp(),
    // overrides: [],
    // observers: [RiverpodLogger()],
  ));
}

class ObjectDetectBoardApp extends StatelessWidget {
  ObjectDetectBoardApp({Key? key}) : super(key: key);

  final theme = ThemeData.from(
    colorScheme: const ColorScheme.dark(
      primary: Color(0xff81c784),
      secondary: Color(0xffefebe9),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EdgeAI',
      theme: theme,
      home: const ConnectScreen(),
    );
  }
}
