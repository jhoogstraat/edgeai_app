import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/screens/connect/connect_screen.dart';
import 'logging.dart';

void main() async {
  setLogger();
  runApp(ProviderScope(
    child: ObjectDetectBoardApp(),
    // observers: [RiverpodLogger()],
  ));
}

class ObjectDetectBoardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EdgeAI',
      theme:
          ThemeData.from(colorScheme: ColorScheme.dark(primary: Colors.white)),
      home: const ConnectScreen(),
      // debugShowCheckedModeBanner: false,
    );
  }
}
