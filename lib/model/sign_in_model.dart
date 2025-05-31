// lib/model/sign_in_model.dart
import 'package:flutter/material.dart';

class SignInModel {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool validateCredentials(BuildContext context) {
    final username = usernameController.text.trim();
    final password = passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      _showAlertDialog(
        context,
        title: "Missing Fields",
        content: "Please enter both the username and password to login.",
      );
      return false;
    }

    if (username != "admin" || password != "adminadmin") {
      _showAlertDialog(
        context,
        title: "Login Failed",
        content: "Incorrect username or password.",
      );
      return false;
    }

    return true;
  }

  void _showAlertDialog(BuildContext context, {required String title, required String content}) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            child: Text("OK"),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }

  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
  }
}
