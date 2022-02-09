import 'package:english_words/english_words.dart';
import 'package:flutter/cupertino.dart';
import 'package:system_tray/system_tray.dart';
import 'dart:io';
import 'dart:async';

import 'package:window_manager/window_manager.dart';

class Tray {
  bool _toogleTrayIcon = true;
  final SystemTray _systemTray = SystemTray();
  Timer? _timer;

  Tray._internal();

  factory Tray() => _instance;
  static late final Tray _instance = Tray._internal();

  void initState() {
    initSystemTray();
  }

  Future<void> initSystemTray() async {
    String path =
        Platform.isWindows ? 'assets/app_icon.ico' : 'assets/app_icon.png';
    if (Platform.isMacOS) {
      path = 'AppIcon';
    }

    final menu = [
      MenuItem(label: '显示', onClicked: windowManager.show),
      MenuItem(label: '隐藏', onClicked: windowManager.hide),
      MenuItem(
        label: '开启系统栏闪烁',
        onClicked: () {
          debugPrint("Start flash tray icon");

          _timer ??= Timer.periodic(
            const Duration(milliseconds: 500),
            (timer) {
              _toogleTrayIcon = !_toogleTrayIcon;
              _systemTray.setSystemTrayInfo(
                iconPath: _toogleTrayIcon ? "" : path,
              );
            },
          );
        },
      ),
      MenuItem(
        label: '关闭系统栏闪烁',
        onClicked: () {
          debugPrint("Stop flash tray icon");

          _timer?.cancel();
          _timer = null;

          _systemTray.setSystemTrayInfo(
            iconPath: path,
          );
        },
      ),
      MenuSeparator(),
      SubMenu(
        label: "测试",
        children: [
          SubMenu(
            label: "setSystemTrayInfo",
            children: [
              MenuItem(
                label: 'set title',
                onClicked: () {
                  final String text = WordPair.random().asPascalCase;
                  debugPrint("click 'set title' : $text");
                  _systemTray.setSystemTrayInfo(
                    title: text,
                  );
                },
              ),
              MenuItem(
                label: 'set icon path',
                onClicked: () {
                  debugPrint("click 'set icon path' : $path");
                  _systemTray.setSystemTrayInfo(
                    iconPath: path,
                  );
                },
              ),
              MenuItem(
                label: 'set toolTip',
                onClicked: () {
                  final String text = WordPair.random().asPascalCase;
                  debugPrint("click 'set toolTip' : $text");
                  _systemTray.setSystemTrayInfo(
                    toolTip: text,
                  );
                },
              ),
            ],
          ),
          MenuItem(label: 'disabled Item', enabled: false),
        ],
      ),
      MenuSeparator(),
      MenuItem(
        label: '退出',
        onClicked: () => exit(0),
      ),
    ];

    // We first init the systray menu and then add the menu entries
    await _systemTray.initSystemTray(
      title: "system tray",
      iconPath: path,
      toolTip: "这里是系统通知栏标题",
    );

    await _systemTray.setContextMenu(menu);

    // handle system tray event
    _systemTray.registerSystemTrayEventHandler((eventName) {
      debugPrint("eventName: $eventName");
      if (eventName == "leftMouseDown") {
      } else if (eventName == "leftMouseUp") {
        windowManager.show();
      } else if (eventName == "rightMouseDown") {
      } else if (eventName == "rightMouseUp") {
        _systemTray.popUpContextMenu();
      }
    });
  }
}
