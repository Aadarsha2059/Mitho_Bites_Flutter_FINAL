import 'package:flutter/material.dart';

class ForgotPasswordModel {
  final emailController = TextEditingController();

  Map<String, String> validateAndSendLink() {
    final email = emailController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      return {
        'title': 'Invalid Email',
        'content': 'Please enter a valid email address to reset your password.',
      };
    }

    // Simulate sending reset email
    return {
      'title': 'Reset Link Sent',
      'content': 'A password reset link has been sent to your email. Please check your inbox.',
    };
  }
}
