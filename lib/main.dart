import 'package:flutter/material.dart';
import 'package:fooddelivery_b/common/globs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'utils/globs.dart';

Future<void> main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance(); // initialize global prefs
  runApp(const App());
}
