import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obj_detect_board/app/screens/history/sets_screen.dart';
import 'package:obj_detect_board/app/screens/streaming/streaming_screen.dart';
import 'package:obj_detect_board/library/models/status.dart';
import 'package:obj_detect_board/library/providers/app_providers.dart';
import 'package:obj_detect_board/library/providers/service_providers.dart';
import 'app/screens/discovery/connect_screen.dart';
import 'library/models/device.dart';
import 'logging.dart';

import 'package:flutter_ume/flutter_ume.dart'; // UME framework
import 'package:flutter_ume_kit_ui/flutter_ume_kit_ui.dart'; // UI kits
import 'package:flutter_ume_kit_perf/flutter_ume_kit_perf.dart'; // Performance kits
import 'package:flutter_ume_kit_show_code/flutter_ume_kit_show_code.dart'; // Show Code
import 'package:flutter_ume_kit_device/flutter_ume_kit_device.dart'; // Device info
import 'package:flutter_ume_kit_console/flutter_ume_kit_console.dart'; // Show debugPrint

void main() async {
  initLogger();

  if (kDebugMode) {
    PluginManager.instance // Register plugin kits
      ..register(const WidgetInfoInspector())
      ..register(const WidgetDetailInspector())
      ..register(const ColorSucker())
      ..register(AlignRuler())
      ..register(Performance())
      ..register(const ShowCode())
      ..register(const MemoryInfoPage())
      ..register(CpuInfoPage())
      ..register(const DeviceInfoPanel())
      ..register(Console()); // Pass in your Dio instance
    runApp(
      injectUMEWidget(
          child: ProviderScope(child: ObjectDetectBoardApp()), enable: true),
    ); // Initial UME
  } else {
    runApp(ProviderScope(child: ObjectDetectBoardApp()));
  }

  // runApp(
  //   ProviderScope(
  //     child: ObjectDetectBoardApp(),
  // overrides: [
  //   selectedDeviceProvider.overrideWithValue(Device("hans", "192.168.1.1")),
  //   selectedDeviceStatusProvider.overrideWithValue(
  //     StateController(
  //       Status(true, Size(100, 100), Size(100, 100), Size(100, 100),
  //           {'one': 'one'}, {}, 0.8, "hello"),
  //     ),
  //   )
  // ],
  // observers: [RiverpodLogger()],
  //   ),
  // );
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
