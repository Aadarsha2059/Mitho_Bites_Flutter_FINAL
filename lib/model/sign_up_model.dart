import 'package:flutter/material.dart';

class SignUpModel {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  bool validateFields(BuildContext context) {
    final fullName = fullNameController.text.trim();
    final username = usernameController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;
    final phone = phoneController.text.trim();
    final address = addressController.text.trim();

    if (fullName.isEmpty ||
        username.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        phone.isEmpty ||
        address.isEmpty) {
      _showAlertDialog(context, "Missing Fields", "Please fill in all the fields to sign up.");
      return false;
    }

    if (password.length < 6) {
      _showAlertDialog(context, "Weak Password", "Password must be at least 6 characters long.");
      return false;
    }

    if (password != confirmPassword) {
      _showAlertDialog(context, "Password Mismatch", "Passwords do not match. Please retype them correctly.");
      return false;
    }

    return true;
  }

  void submit(BuildContext context) {
    if (!validateFields(context)) return;

    final fullName = fullNameController.text.trim();
    final username = usernameController.text.trim();
    final phone = phoneController.text.trim();
    final address = addressController.text.trim();

    // Handle actual signup logic or API call here
    print("Signup with: $fullName, $username, $phone, $address");

    _showAlertDialog(context, "Success", "Account created successfully!");
  }

  void _showAlertDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }
}
