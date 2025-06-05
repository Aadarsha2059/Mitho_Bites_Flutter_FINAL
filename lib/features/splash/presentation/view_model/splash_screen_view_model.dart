import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreenViewModel extends ChangeNotifier {
  Timer? _timer;

  void startTimer(VoidCallback onTimerComplete) {
    _timer = Timer(Duration(seconds: 6), () {
      onTimerComplete();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
