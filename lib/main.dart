import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter_window_cli/tray.dart';


void main() async {
  runApp(const MyApp());

  doWhenWindowReady(() {
    final win = appWindow;
    const initialSize = Size(600, 450);
    win.minSize = initialSize;
    win.size = initialSize;
    win.alignment = Alignment.center;
    win.title = "How to use system tray with Flutter";
    win.show();
  });
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
        body: WindowBorder(
          color: const Color(0xFFFFFFFF),
          width: 0,
          child: Row(
          ),
        ),
      ),
    );
  }
}
