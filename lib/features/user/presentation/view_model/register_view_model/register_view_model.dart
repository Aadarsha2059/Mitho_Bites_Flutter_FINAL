import 'package:flutter/material.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterViewModel extends ChangeNotifier {
  final BuildContext context;

  RegisterState _state = RegisterState();

  RegisterState get state => _state;

  RegisterViewModel({required this.context});

  void onEvent(RegisterEvent event) {
    if (event is FullNameChanged) {
      _state = _state.copyWith(fullName: event.fullName, errorMessage: null);
    } else if (event is UsernameChanged) {
      _state = _state.copyWith(username: event.username, errorMessage: null);
    } else if (event is PasswordChanged) {
      _state = _state.copyWith(password: event.password, errorMessage: null);
    } else if (event is ConfirmPasswordChanged) {
      _state = _state.copyWith(confirmPassword: event.confirmPassword, errorMessage: null);
    } else if (event is PhoneChanged) {
      _state = _state.copyWith(phone: event.phone, errorMessage: null);
    } else if (event is AddressChanged) {
      _state = _state.copyWith(address: event.address, errorMessage: null);
    } else if (event is SubmitRegistration) {
      _submit();
      return;
    }
    notifyListeners();
  }

  void _submit() {
    final s = _state;

    // Validation
    if (s.fullName.isEmpty ||
        s.username.isEmpty ||
        s.password.isEmpty ||
        s.confirmPassword.isEmpty ||
        s.phone.isEmpty ||
        s.address.isEmpty) {
      _setError("Please fill in all the fields to sign up.");
      return;
    }

    if (s.password.length < 6) {
      _setError("Password must be at least 6 characters long.");
      return;
    }

    if (s.password != s.confirmPassword) {
      _setError("Passwords do not match. Please retype them correctly.");
      return;
    }

    // Simulate submission (you can add API calls here)
    _state = _state.copyWith(isSubmitting: true, errorMessage: null);
    notifyListeners();

    Future.delayed(const Duration(seconds: 2), () {
      _state = _state.copyWith(isSubmitting: false, isSuccess: true);
      notifyListeners();

      // Optionally, show success dialog or navigate away
      _showSuccessDialog();
    });
  }

  void _setError(String message) {
    _state = _state.copyWith(errorMessage: message);
    notifyListeners();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Success"),
        content: const Text("Registration successful!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Back to login or previous page
            },
            child: const Text("OK"),
          )
        ],
      ),
    );
  }
}
