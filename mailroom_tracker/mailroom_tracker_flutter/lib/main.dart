import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'globals.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'widgets/spotlight_search.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadApp(
      title: 'Poststellen Scanner',
      navigatorKey: navigatorKey,
      builder: (context, child) {
        return Focus(
          autofocus: true,
          canRequestFocus: true,
          onKeyEvent: (node, event) {
            if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.keyK && (HardwareKeyboard.instance.isMetaPressed || HardwareKeyboard.instance.isControlPressed)) {
              if (currentUserSignal.value != null && navigatorKey.currentContext != null) {
                showSpotlightSearch(navigatorKey.currentContext!);
                return KeyEventResult.handled;
              }
            }
            return KeyEventResult.ignored;
          },
          child: child!,
        );
      },
      home: ValueListenableBuilder(
        valueListenable: currentUserSignal,
        builder: (context, user, child) {
          return user == null ? const LoginScreen() : const ManagementDashboardScreen();
        },
      ),
    );
  }
}