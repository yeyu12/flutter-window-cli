import 'package:english_words/english_words.dart';
import 'package:flutter/cupertino.dart';
import 'package:system_tray/system_tray.dart';
import 'dart:io';
import 'dart:async';

class Tray {
  bool _toogleTrayIcon = true;
  final SystemTray _systemTray = SystemTray();
  final AppWindow _appWindow = AppWindow();
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
      MenuItem(label: 'Show', onClicked: _appWindow.show),
      MenuItem(label: 'Hide', onClicked: _appWindow.hide),
      MenuItem(
        label: 'Start flash tray icon',
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
        label: 'Stop flash tray icon',
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
        label: "Test API",
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
        label: 'Exit',
        onClicked: _appWindow.close,
      ),
    ];

    // We first init the systray menu and then add the menu entries
    await _systemTray.initSystemTray(
      title: "system tray",
      iconPath: path,
      toolTip: "How to use system tray with Flutter",
    );

    await _systemTray.setContextMenu(menu);

    // handle system tray event
    _systemTray.registerSystemTrayEventHandler((eventName) {
      debugPrint("eventName: $eventName");
      if (eventName == "leftMouseDown") {
      } else if (eventName == "leftMouseUp") {
        _appWindow.show();
      } else if (eventName == "rightMouseDown") {
      } else if (eventName == "rightMouseUp") {
        _systemTray.popUpContextMenu();
      }
    });
  }
}