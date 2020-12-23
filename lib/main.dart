import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:obj_detect_board/app/home_page/home_page.dart';

void main() {
  runApp(ProviderScope(child: ObjectDetectBoardApp()));
}

class ObjectDetectBoardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OBJECT DETECTION BOARD',
      theme: ThemeData.from(colorScheme: ColorScheme.dark()),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
