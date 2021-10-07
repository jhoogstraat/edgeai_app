import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/screens/connect/connect_screen.dart';
import 'logging.dart';

void main() async {
  initLogger();
  runApp(const ProviderScope(child: EdgeAIApp()));
}

final theme = ThemeData.from(
  colorScheme: const ColorScheme.dark(
    primary: Color(0xff81c784),
    secondary: Color(0xffefebe9),
  ),
);

class EdgeAIApp extends StatelessWidget {
  const EdgeAIApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EdgeAI App',
      theme: theme,
      home: const ConnectScreen(),
    );
  }
}
