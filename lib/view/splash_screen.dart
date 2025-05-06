import 'package:flutter/material.dart';
import 'dart:async';

import 'package:fooddelivery_b/view/sign_in.dart';

// HomeScreen placeholder after splash
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mitho Bites - Home')),
      body: Center(child: Text('Welcome to the Mitho Bites App!')),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late Animation<double> _logoAnimation;
  late Animation<Offset> _textSlideAnimation;

  @override
  void initState() {
    super.initState();

    // Logo bounce animation
    _logoController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );

    _logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _logoController.forward();

    // Text slide + fade animation
    _textController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1800),
    );

    _textSlideAnimation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    _textController.forward();

    // Simulate loading before moving to home
    Timer(Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => LoginPage(),
        ), // Navigate to HomeScreen after splash
      );
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orangeAccent.shade100,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _logoAnimation,
              child: Image.asset('assets/images/logo.png', height: 120),
            ),
            SizedBox(height: 20),
            SlideTransition(
              position: _textSlideAnimation,
              child: Column(
                children: [
                  Text(
                    "Mitho Bites",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown.shade800,
                    ),
                  ),
                  Text(
                    "Delicious foods at affordable price",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 16,
                      color: Colors.brown.shade700,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.deepOrangeAccent,
              ),
              strokeWidth: 4.0,
            ),
          ],
        ),
      ),
    );
  }
}
