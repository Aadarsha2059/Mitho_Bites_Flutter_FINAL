// // // lib/view/sign_in_view.dart
// // import 'package:flutter/material.dart';
// // import 'package:fooddelivery_b/model/sign_in_model.dart';
// // import 'package:fooddelivery_b/view/about_us_view.dart';
// // import 'package:fooddelivery_b/view/forgot_password_view.dart';
// // import 'package:fooddelivery_b/view/sign_up_view.dart';
// // import 'package:fooddelivery_b/features/home/presentation/view/home_view.dart';
// // import 'package:fooddelivery_b/features/user/presentation/view_model/login_view_model/login_view_model.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';

// // class SignInView extends StatefulWidget {
// //   @override
// //   _SignInViewState createState() => _SignInViewState();
// // }

// // class _SignInViewState extends State<SignInView> {
// //   final SignInModel _model = SignInModel();

// //   void _login() {
// //     if (_model.validateCredentials(context)) {
// //       Navigator.push(
// //         context,
// //         MaterialPageRoute(
// //           builder: (_) => HomeView(loginViewModel: LoginViewModel()),
// //         ),
// //       );
// //     }
// //   }

// //   void _navigateToSignUp() {
// //     Navigator.push(context, MaterialPageRoute(builder: (_) => SignUpPage()));
// //   }

// //   @override
// //   void dispose() {
// //     _model.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Stack(
// //         children: [
// //           Container(
// //             decoration: const BoxDecoration(
// //               gradient: LinearGradient(
// //                 colors: [Color(0xffB81736), Color(0xff281537)],
// //                 begin: Alignment.topCenter,
// //                 end: Alignment.bottomCenter,
// //               ),
// //             ),
// //           ),
// //           Padding(
// //             padding: const EdgeInsets.only(top: 60.0, left: 22, right: 22),
// //             child: Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [
// //                 const Text(
// //                   'Hello\nSign in!',
// //                   style: TextStyle(
// //                     fontSize: 30,
// //                     color: Colors.white,
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                 ),
// //                 IconButton(
// //                   icon: const Icon(
// //                     Icons.info_outline_rounded,
// //                     color: Colors.white,
// //                     size: 30,
// //                   ),
// //                   tooltip: 'About Us',
// //                   onPressed:
// //                       () => Navigator.push(
// //                         context,
// //                         MaterialPageRoute(builder: (_) => AboutUsView()),
// //                       ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           Padding(
// //             padding: const EdgeInsets.only(top: 200.0),
// //             child: Container(
// //               decoration: const BoxDecoration(
// //                 color: Colors.white,
// //                 borderRadius: BorderRadius.only(
// //                   topLeft: Radius.circular(40),
// //                   topRight: Radius.circular(40),
// //                 ),
// //               ),
// //               child: SingleChildScrollView(
// //                 padding: const EdgeInsets.all(24),
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Align(
// //                       alignment: Alignment.topRight,
// //                       child: CircleAvatar(
// //                         backgroundImage: AssetImage('assets/images/logo.png'),
// //                         radius: 30,
// //                       ),
// //                     ),
// //                     SizedBox(height: 20),
// //                     Text(
// //                       "Login Page",
// //                       style: TextStyle(
// //                         fontSize: 30,
// //                         fontWeight: FontWeight.bold,
// //                         color: Color(0xff281537),
// //                       ),
// //                     ),
// //                     SizedBox(height: 8),
// //                     Text(
// //                       "Mitho_Bites Nepal",
// //                       style: TextStyle(
// //                         fontSize: 18,
// //                         color: Color(0xffB81736),
// //                         fontStyle: FontStyle.italic,
// //                       ),
// //                     ),
// //                     SizedBox(height: 30),
// //                     TextField(
// //                       controller: _model.usernameController,
// //                       decoration: InputDecoration(
// //                         labelText: "Username",
// //                         prefixIcon: Icon(Icons.person),
// //                         filled: true,
// //                         fillColor: Colors.grey.shade200,
// //                         border: OutlineInputBorder(
// //                           borderRadius: BorderRadius.circular(12),
// //                           borderSide: BorderSide.none,
// //                         ),
// //                       ),
// //                     ),
// //                     SizedBox(height: 20),
// //                     TextField(
// //                       controller: _model.passwordController,
// //                       obscureText: true,
// //                       decoration: InputDecoration(
// //                         labelText: "Password",
// //                         prefixIcon: Icon(Icons.lock),
// //                         filled: true,
// //                         fillColor: Colors.grey.shade200,
// //                         border: OutlineInputBorder(
// //                           borderRadius: BorderRadius.circular(12),
// //                           borderSide: BorderSide.none,
// //                         ),
// //                       ),
// //                     ),
// //                     SizedBox(height: 20),
// //                     Align(
// //                       alignment: Alignment.centerRight,
// //                       child: GestureDetector(
// //                         onTap:
// //                             () => Navigator.push(
// //                               context,
// //                               MaterialPageRoute(
// //                                 builder: (_) => ForgotPasswordPage(),
// //                               ),
// //                             ),
// //                         child: Text(
// //                           "Forgot Password?",
// //                           style: TextStyle(
// //                             fontWeight: FontWeight.bold,
// //                             fontSize: 16,
// //                             color: Color.fromARGB(255, 81, 227, 253),
// //                             decoration: TextDecoration.underline,
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                     SizedBox(height: 20),
// //                     Container(
// //                       width: double.infinity,
// //                       height: 55,
// //                       decoration: BoxDecoration(
// //                         borderRadius: BorderRadius.circular(30),
// //                         gradient: const LinearGradient(
// //                           colors: [Color(0xffB81736), Color(0xff281537)],
// //                         ),
// //                       ),
// //                       child: ElevatedButton(
// //                         onPressed: _login,
// //                         style: ElevatedButton.styleFrom(
// //                           backgroundColor: Colors.transparent,
// //                           shadowColor: Colors.transparent,
// //                           shape: RoundedRectangleBorder(
// //                             borderRadius: BorderRadius.circular(30),
// //                           ),
// //                         ),
// //                         child: const Text(
// //                           "Login",
// //                           style: TextStyle(fontSize: 18, color: Colors.white),
// //                         ),
// //                       ),
// //                     ),
// //                     SizedBox(height: 30),
// //                     Center(
// //                       child: Text("We can login with other options as well.."),
// //                     ),
// //                     SizedBox(height: 16),
// //                     Row(
// //                       mainAxisAlignment: MainAxisAlignment.center,
// //                       children: [
// //                         ElevatedButton.icon(
// //                           onPressed: () {},
// //                           icon: Icon(Icons.facebook, color: Color(0xff3b5998)),
// //                           label: Text("Facebook"),
// //                           style: ElevatedButton.styleFrom(
// //                             backgroundColor: Color(0xfff5f6f7),
// //                             padding: EdgeInsets.symmetric(
// //                               horizontal: 20,
// //                               vertical: 12,
// //                             ),
// //                             shape: RoundedRectangleBorder(
// //                               borderRadius: BorderRadius.circular(10),
// //                             ),
// //                           ),
// //                         ),
// //                         SizedBox(width: 20),
// //                         ElevatedButton.icon(
// //                           onPressed: () {},
// //                           icon: Icon(Icons.g_mobiledata, color: Colors.white),
// //                           label: Text("Google"),
// //                           style: ElevatedButton.styleFrom(
// //                             backgroundColor: Color(0xff949393),
// //                             padding: EdgeInsets.symmetric(
// //                               horizontal: 20,
// //                               vertical: 12,
// //                             ),
// //                             shape: RoundedRectangleBorder(
// //                               borderRadius: BorderRadius.circular(10),
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                     SizedBox(height: 40),
// //                     Align(
// //                       alignment: Alignment.bottomRight,
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.end,
// //                         children: [
// //                           Text(
// //                             "Don't have an account?",
// //                             style: TextStyle(
// //                               fontWeight: FontWeight.bold,
// //                               color: Colors.grey,
// //                             ),
// //                           ),
// //                           GestureDetector(
// //                             onTap: _navigateToSignUp,
// //                             child: Text(
// //                               "Sign Up",
// //                               style: TextStyle(
// //                                 fontWeight: FontWeight.bold,
// //                                 fontSize: 17,
// //                                 color: Colors.black,
// //                               ),
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                     SizedBox(height: 20),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:fooddelivery_b/model/sign_in_model.dart';
// import 'package:fooddelivery_b/view/about_us_view.dart';
// import 'package:fooddelivery_b/view/forgot_password_view.dart';
// import 'package:fooddelivery_b/view/sign_up_view.dart';
// import 'package:fooddelivery_b/features/home/presentation/view/home_view.dart';
// import 'package:fooddelivery_b/features/user/presentation/view_model/login_view_model/login_view_model.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fooddelivery_b/features/chatbot/presentation/view/chat_bot_view.dart';

// class SignInView extends StatefulWidget {
//   @override
//   _SignInViewState createState() => _SignInViewState();
// }

// class _SignInViewState extends State<SignInView> {
//   final SignInModel _model = SignInModel();

//   void _login() {
//     if (_model.validateCredentials(context)) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => HomeView(loginViewModel: LoginViewModel()),
//         ),
//       );
//     }
//   }

//   void _navigateToSignUp() {
//     Navigator.push(context, MaterialPageRoute(builder: (_) => SignUpPage()));
//   }

//   @override
//   void dispose() {
//     _model.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Color(0xffB81736), Color(0xff281537)],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 60.0, left: 22, right: 22),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'Hello\nSign in!',
//                   style: TextStyle(
//                     fontSize: 30,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(
//                     Icons.info_outline_rounded,
//                     color: Colors.white,
//                     size: 30,
//                   ),
//                   tooltip: 'About Us',
//                   onPressed:
//                       () => Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (_) => AboutUsView()),
//                       ),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 200.0),
//             child: Container(
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(40),
//                   topRight: Radius.circular(40),
//                 ),
//               ),
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(24),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Align(
//                       alignment: Alignment.topRight,
//                       child: CircleAvatar(
//                         backgroundImage: AssetImage('assets/images/logo.png'),
//                         radius: 30,
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     Text(
//                       "Login Page",
//                       style: TextStyle(
//                         fontSize: 30,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xff281537),
//                       ),
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       "Mitho_Bites Nepal",
//                       style: TextStyle(
//                         fontSize: 18,
//                         color: Color(0xffB81736),
//                         fontStyle: FontStyle.italic,
//                       ),
//                     ),
//                     SizedBox(height: 30),
//                     TextField(
//                       controller: _model.usernameController,
//                       decoration: InputDecoration(
//                         labelText: "Username",
//                         prefixIcon: Icon(Icons.person),
//                         filled: true,
//                         fillColor: Colors.grey.shade200,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     TextField(
//                       controller: _model.passwordController,
//                       obscureText: true,
//                       decoration: InputDecoration(
//                         labelText: "Password",
//                         prefixIcon: Icon(Icons.lock),
//                         filled: true,
//                         fillColor: Colors.grey.shade200,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     Align(
//                       alignment: Alignment.centerRight,
//                       child: GestureDetector(
//                         onTap:
//                             () => Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) => ForgotPasswordPage(),
//                               ),
//                             ),
//                         child: Text(
//                           "Forgot Password?",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                             color: Color.fromARGB(255, 81, 227, 253),
//                             decoration: TextDecoration.underline,
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     Container(
//                       width: double.infinity,
//                       height: 55,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(30),
//                         gradient: const LinearGradient(
//                           colors: [Color(0xffB81736), Color(0xff281537)],
//                         ),
//                       ),
//                       child: ElevatedButton(
//                         onPressed: _login,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.transparent,
//                           shadowColor: Colors.transparent,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                         ),
//                         child: const Text(
//                           "Login",
//                           style: TextStyle(fontSize: 18, color: Colors.white),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 30),
//                     Center(
//                       child: Text("We can login with other options as well.."),
//                     ),
//                     SizedBox(height: 16),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         ElevatedButton.icon(
//                           onPressed: () {},
//                           icon: Icon(Icons.facebook, color: Color(0xff3b5998)),
//                           label: Text("Facebook"),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Color(0xfff5f6f7),
//                             padding: EdgeInsets.symmetric(
//                               horizontal: 20,
//                               vertical: 12,
//                             ),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: 20),
//                         ElevatedButton.icon(
//                           onPressed: () {},
//                           icon: Icon(Icons.g_mobiledata, color: Colors.white),
//                           label: Text("Google"),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Color(0xff949393),
//                             padding: EdgeInsets.symmetric(
//                               horizontal: 20,
//                               vertical: 12,
//                             ),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 40),
//                     Align(
//                       alignment: Alignment.bottomRight,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           Text(
//                             "Don't have an account?",
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.grey,
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: _navigateToSignUp,
//                             child: Text(
//                               "Sign up",
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 17,
//                                 color: Colors.black,
//                                 decoration: TextDecoration.underline,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           const ChatBotView(),
//         ],
//       ),
//     );
//   }
// }
