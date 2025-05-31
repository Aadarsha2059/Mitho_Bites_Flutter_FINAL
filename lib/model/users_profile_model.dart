import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserProfileModel {
  final TextEditingController nameController =
      TextEditingController(text: "Aadarsha Dhakal");
  final TextEditingController emailController =
      TextEditingController(text: "aadarsha@example.com");
  final TextEditingController mobileController =
      TextEditingController(text: "9800000000");
  final TextEditingController addressController =
      TextEditingController(text: "Kathmandu, Nepal");
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  void saveProfile(BuildContext context, VoidCallback onSaved) {
    Fluttertoast.showToast(
      msg: "Saved changes",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );

    Future.delayed(const Duration(seconds: 1), onSaved);
  }

  void signOut(BuildContext context, VoidCallback onConfirmed) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Sign Out"),
        content: const Text("Are you sure you want to sign out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirmed();
            },
            child: const Text("OK", style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }
}
