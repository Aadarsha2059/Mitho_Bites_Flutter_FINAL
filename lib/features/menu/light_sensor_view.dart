import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';

class GyroscopeMenuSwitcher extends StatefulWidget {
  final Widget dayMenu;
  final Widget nightMenu;
  const GyroscopeMenuSwitcher({required this.dayMenu, required this.nightMenu, Key? key}) : super(key: key);

  @override
  State<GyroscopeMenuSwitcher> createState() => _GyroscopeMenuSwitcherState();
}

class _GyroscopeMenuSwitcherState extends State<GyroscopeMenuSwitcher> {
  double _rotation = 0.0;
  StreamSubscription? _gyroSub;
  bool _isNight = false;
  DateTime? _lastSwitchTime;

  @override
  void initState() {
    super.initState();
    _gyroSub = gyroscopeEvents.listen((event) {
      final now = DateTime.now();
      final maxAxis = [event.x.abs(), event.y.abs(), event.z.abs()].reduce((a, b) => a > b ? a : b);
      if (!_isNight && maxAxis > 2.0) {
        // If rotated and held for 1s, switch to night
        if (_lastSwitchTime == null) {
          _lastSwitchTime = now;
        } else if (now.difference(_lastSwitchTime!) > const Duration(seconds: 1)) {
          setState(() {
            _isNight = true;
          });
        }
      } else if (_isNight && maxAxis <= 2.0) {
        // If still and held for 1s, switch to day
        if (_lastSwitchTime == null) {
          _lastSwitchTime = now;
        } else if (now.difference(_lastSwitchTime!) > const Duration(seconds: 1)) {
          setState(() {
            _isNight = false;
          });
        }
      } else {
        _lastSwitchTime = null;
      }
      _rotation = maxAxis;
    });
  }

  @override
  void dispose() {
    _gyroSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: _isNight ? widget.nightMenu : widget.dayMenu,
    );
  }
}
