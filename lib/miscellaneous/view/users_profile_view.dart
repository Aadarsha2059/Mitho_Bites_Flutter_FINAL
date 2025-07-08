// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:fooddelivery_b/view/sign_in_view.dart';
// import 'dashboard_view.dart';
// import 'sign_up_view.dart';

// class UserProfileView extends StatelessWidget {
//   final TextEditingController txtName = TextEditingController(
//     text: "Aadarsha Dhakal",
//   );
//   final TextEditingController txtEmail = TextEditingController(
//     text: "aadarsha@example.com",
//   );
//   final TextEditingController txtMobile = TextEditingController(
//     text: "9800000000",
//   );
//   final TextEditingController txtAddress = TextEditingController(
//     text: "Kathmandu, Nepal",
//   );
//   final TextEditingController txtPassword = TextEditingController();
//   final TextEditingController txtConfirmPassword = TextEditingController();

//   UserProfileView({super.key});

//   void _saveProfile(BuildContext context) {
//     Fluttertoast.showToast(
//       msg: "Saved changes",
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.BOTTOM,
//     );
//     Future.delayed(const Duration(seconds: 1), () {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const DashboardView()),
//       );
//     });
//   }

//   void _signOut(BuildContext context) {
//     showDialog(
//       context: context,
//       builder:
//           (context) => AlertDialog(
//             title: const Text("Sign Out"),
//             content: const Text("Are you sure you want to sign out?"),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text("Cancel"),
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(builder: (context) => SignInView()),
//                   );
//                 },
//                 child: const Text("OK", style: TextStyle(color: Colors.green)),
//               ),
//             ],
//           ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("User Profile"),
//         centerTitle: true,
//         backgroundColor: Colors.deepPurple,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.shopping_bag),
//             onPressed: () {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text("Order view not implemented yet."),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             const SizedBox(height: 25),
//             Center(
//               child: CircleAvatar(
//                 radius: 60,
//                 backgroundImage: const AssetImage(
//                   'assets/images/aadarshaaaaaaaa.png',
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//             const Text(
//               "Hi there, Aadarsha!",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//             ),
//             TextButton.icon(
//               onPressed: () => _signOut(context),
//               icon: const Icon(Icons.logout, color: Colors.red),
//               label: const Text(
//                 "Sign Out",
//                 style: TextStyle(color: Colors.red),
//               ),
//             ),
//             const Divider(thickness: 1, indent: 20, endIndent: 20),
//             const SizedBox(height: 10),
//             ProfileField(
//               icon: Icons.person,
//               label: "Name",
//               controller: txtName,
//             ),
//             ProfileField(
//               icon: Icons.verified_user_rounded,
//               label: "Username",
//               controller: txtEmail,
//               inputType: TextInputType.text,
//             ),
//             ProfileField(
//               icon: Icons.phone,
//               label: "Mobile No",
//               controller: txtMobile,
//               inputType: TextInputType.phone,
//             ),
//             ProfileField(
//               icon: Icons.home,
//               label: "Address",
//               controller: txtAddress,
//             ),
//             ProfileField(
//               icon: Icons.lock,
//               label: "Password",
//               controller: txtPassword,
//               obscureText: true,
//             ),
//             ProfileField(
//               icon: Icons.lock_outline,
//               label: "Confirm Password",
//               controller: txtConfirmPassword,
//               obscureText: true,
//             ),
//             const SizedBox(height: 25),
//             ElevatedButton.icon(
//               icon: const Icon(Icons.save),
//               label: const Text("Save Profile"),
//               onPressed: () => _saveProfile(context),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color.fromARGB(255, 219, 217, 222),
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 40,
//                   vertical: 14,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 30),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ProfileField extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final TextEditingController controller;
//   final bool obscureText;
//   final TextInputType inputType;

//   const ProfileField({
//     super.key,
//     required this.icon,
//     required this.label,
//     required this.controller,
//     this.obscureText = false,
//     this.inputType = TextInputType.text,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       child: TextField(
//         controller: controller,
//         keyboardType: inputType,
//         obscureText: obscureText,
//         decoration: InputDecoration(
//           prefixIcon: Icon(icon, color: Colors.deepPurple),
//           labelText: label,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//       ),
//     );
//   }
// }
