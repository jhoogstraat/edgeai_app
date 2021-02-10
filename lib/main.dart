import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obj_detect_board/app/connect_screen/connect_screen.dart';
import 'package:obj_detect_board/ranodm.dart';

void main() async {
  setLogger();
  runApp(ProviderScope(
    child: ObjectDetectBoardApp(),
    observers: [],
  ));
}

class ObjectDetectBoardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OBJECT DETECTION BOARD',
      theme: ThemeData.from(colorScheme: ColorScheme.dark()),
      home: ConnectScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Logger extends ProviderObserver {
  @override
  void didAddProvider(ProviderBase provider, Object value) {
    print('''didAddProvider
{
  "provider": "${provider.name ?? provider.runtimeType}",
  "newValue": "$value"
}''');
  }

  @override
  void didDisposeProvider(ProviderBase provider) {
    print('''didDisposeProvider
{
  "provider": "${provider.name ?? provider.runtimeType}",
}''');
  }

  @override
  void didUpdateProvider(ProviderBase provider, Object newValue) {
    print('''didUpdateProvider
{
  "provider": "${provider.name ?? provider.runtimeType}",
  "newValue": "$newValue"
}''');
  }
}
