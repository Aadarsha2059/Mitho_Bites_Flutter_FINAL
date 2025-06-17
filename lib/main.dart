import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';
import 'core/network/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();         // Initialize Hive for Flutter

  await HiveService().init();       // Open Hive boxes

  runApp(const App());
}
