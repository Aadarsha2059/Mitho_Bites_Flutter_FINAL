import 'package:flutter/material.dart';
import 'package:fooddelivery_b/view/about_us_view.dart';
import 'package:fooddelivery_b/view/dashboard_view.dart';
import 'package:fooddelivery_b/view/forgot_password_view.dart';
import 'package:fooddelivery_b/view/sign_up_view.dart';
import 'package:fooddelivery_b/view/users_profile_view.dart';
import 'view/splash_screen_view.dart'; // Correct import for splash screen from view folder

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mitho Bites',
      debugShowCheckedModeBanner: false,
      home: (SplashScreen()), // Set the SplashScreen as home screen
    );
  }
}
