// import 'package:flutter/material.dart';
// import 'dart:async';

// import 'package:fooddelivery_b/view/sign_in_view.dart';

// // HomeScreen placeholder after splash
// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Mitho Bites - Home')),
//       body: Center(child: Text('Welcome to the Mitho Bites App!')),
//     );
//   }
// }

// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with TickerProviderStateMixin {
//   late AnimationController _logoController;
//   late AnimationController _textController;
//   late Animation<double> _logoAnimation;
//   late Animation<Offset> _textSlideAnimation;

//   late AnimationController _blinkController;
//   late Animation<double> _blinkAnimation;

//   @override
//   void initState() {
//     super.initState();

//     // Logo bounce animation
//     _logoController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 1500),
//     );

//     _logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
//     );

//     _logoController.forward();

//     // Text slide + fade animation
//     _textController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 1800),
//     );

//     _textSlideAnimation = Tween<Offset>(
//       begin: Offset(0, 1),
//       end: Offset(0, 0),
//     ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

//     _textController.forward();

//     // Blinking animation for text
//     _blinkController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 1000),
//       lowerBound: 0.0,
//       upperBound: 1.0,
//     );

//     _blinkController.repeat(reverse: true);
//     _blinkAnimation = Tween<double>(
//       begin: 1.0,
//       end: 0.0,
//     ).animate(_blinkController);

//     // Simulate loading before moving to home
//     Timer(Duration(seconds: 6), () {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (_) => SignInView(),
//         ), // Navigate to LoginPage after splash
//       );
//     });
//   }

//   @override
//   void dispose() {
//     _logoController.dispose();
//     _textController.dispose();
//     _blinkController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.orangeAccent.shade100,
//       body: Container(
//         height: double.infinity,
//         width: double.infinity,
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Color(0xffB81736), // Red
//               Color(0xff281537), // Dark Maroon
//             ],
//           ),
//         ),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ScaleTransition(
//                 scale: _logoAnimation,
//                 child: Image.asset('assets/images/logo.png', height: 120),
//               ),
//               SizedBox(height: 20),
//               SlideTransition(
//                 position: _textSlideAnimation,
//                 child: Column(
//                   children: [
//                     Text(
//                       "Mitho Bites",
//                       style: TextStyle(
//                         fontSize: 32,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                     Text(
//                       "Delicious foods at affordable price",
//                       style: TextStyle(
//                         fontStyle: FontStyle.italic,
//                         fontSize: 16,
//                         color: Colors.white70,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 30),
//               const CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(
//                   Colors.deepOrangeAccent,
//                 ),
//                 strokeWidth: 4.0,
//               ),
//               SizedBox(height: 30),
//               FadeTransition(
//                 opacity: _blinkAnimation,
//                 child: const Text(
//                   "Quality FOODS give Quality LIFE",
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
