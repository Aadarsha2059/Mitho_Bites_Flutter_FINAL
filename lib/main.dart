

import 'package:flutter/material.dart';
import 'package:fooddelivery_b/app/service_locator/service_locator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';
import 'core/network/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  await Hive.initFlutter(); // Initialize Hive for Flutter

  await HiveService().init(); // Open Hive boxes

  runApp(const App());
}
