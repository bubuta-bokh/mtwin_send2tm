import 'package:flutter/material.dart';

class SnackbarGlobal {
  static GlobalKey<ScaffoldMessengerState> key =
      GlobalKey<ScaffoldMessengerState>();

  static void show(String message, int duration, String messageType) {
    Color bkgColor = Colors.blueAccent;
    if (messageType == 'error') {
      bkgColor = Colors.red;
    } else if (messageType == 'warn') {
      bkgColor = const Color.fromARGB(255, 215, 201, 149);
    } else if (messageType == 'success') {
      bkgColor = Colors.lightGreen;
    }

    key.currentState!
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: bkgColor,
          duration: Duration(seconds: duration),
          content: Text(message),
          showCloseIcon: true,
        ),
      );
  }
}
