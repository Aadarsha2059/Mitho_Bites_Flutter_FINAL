import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class AccelerometerView extends StatefulWidget {
  const AccelerometerView({super.key});

  @override
  State<AccelerometerView> createState() => _AccelerometerViewState();
}

class _AccelerometerViewState extends State<AccelerometerView> {
  AccelerometerEvent? _accelerometerEvent;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  @override
  void initState() {
    super.initState();

    _streamSubscriptions.add(
      accelerometerEventStream().listen((AccelerometerEvent event) {
        setState(() {
          _accelerometerEvent = event;
        });
      }),
    );
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
    var x = _accelerometerEvent?.x.toStringAsFixed(1);
    var y = _accelerometerEvent?.y.toStringAsFixed(1);
    var z = _accelerometerEvent?.z.toStringAsFixed(1);

    return Scaffold(
      appBar: AppBar(title: const Text('Accelerometer')),
      

      body: Center(
        child: Text('Accelerometer : \n x:$x\n y: $y\n z:$z',
        style: const TextStyle(fontSize: 24),)),
    );
  }
}
