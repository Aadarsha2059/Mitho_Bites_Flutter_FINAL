import 'package:flutter/material.dart';
import 'package:fooddelivery_b/app/service_locator/service_locator.dart';
import 'app.dart';
import 'core/network/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  await HiveService().init(); 
  runApp(const App());
}