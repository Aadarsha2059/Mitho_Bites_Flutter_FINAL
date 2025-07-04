import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class BarometerView extends StatefulWidget {
  const BarometerView({super.key});

  @override
  State<BarometerView> createState() => _BarometerViewState();
}

class _BarometerViewState extends State<BarometerView> {
  BarometerEvent? _barometerEvent;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  @override
  void initState() {
    _streamSubscriptions.add(
      barometerEventStream().listen(
        (BarometerEvent event) {
          setState(() {
            _barometerEvent = event;
          });
        },
        onError: (e) {
          showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text("Sensor Not Found"),
                content: Text(
                  "It seems that your device doesn't support Barometer Sensor",
                ),
              );
            },
          );
        },
        cancelOnError: true,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Barometer')),
      body: Center(
        child: Text(
          'Pressure: ${_barometerEvent?.pressure.toStringAsFixed(2)} hPa',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
