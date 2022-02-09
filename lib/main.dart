import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_window_cli/tray.dart';
import 'package:window_manager/window_manager.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 必须加上这一行。
  await windowManager.ensureInitialized();

  // Use it only after calling `hiddenWindowAtLaunch`
  windowManager.waitUntilReadyToShow().then((_) async{
    // 隐藏窗口标题栏
    // await windowManager.setTitleBarStyle('hidden');
    await windowManager.hide();
    await windowManager.setSkipTaskbar(false);
    await windowManager.setSize(const Size(800, 600));
    await windowManager.center();
  });

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    Tray().initSystemTray();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      home: Scaffold(
        body:Container()
      ),
    );
  }
}
