import 'package:flutter/material.dart';
import 'view/splash_screen.dart'; // Correct import for splash screen from view folder

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mitho Bites',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(), // Set the SplashScreen as home screen
    );
  }
}
