// register_view_model.dart
import 'package:flutter/material.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterViewModel extends ChangeNotifier {
  RegisterState _state = RegisterState();

  RegisterState get state => _state;

  final BuildContext context;
  RegisterViewModel({required this.context});

  void onEvent(RegisterEvent event) {
    if (event is FullNameChanged) {
      _state = _state.copyWith(fullName: event.fullName, errorMessage: null);
      notifyListeners();
    } else if (event is UsernameChanged) {
      _state = _state.copyWith(username: event.username, errorMessage: null);
      notifyListeners();
    } else if (event is PasswordChanged) {
      _state = _state.copyWith(password: event.password, errorMessage: null);
      notifyListeners();
    } else if (event is ConfirmPasswordChanged) {
      _state = _state.copyWith(confirmPassword: event.confirmPassword, errorMessage: null);
      notifyListeners();
    } else if (event is PhoneChanged) {
      _state = _state.copyWith(phone: event.phone, errorMessage: null);
      notifyListeners();
    } else if (event is AddressChanged) {
      _state = _state.copyWith(address: event.address, errorMessage: null);
      notifyListeners();
    } else if (event is SubmitRegistration) {
      _submit();
    }
  }

  Future<void> _submit() async {
    // Validate form fields
    if (_state.fullName.trim().isEmpty) {
      _state = _state.copyWith(errorMessage: "Full Name is required");
      notifyListeners();
      return;
    }
    if (_state.username.trim().isEmpty) {
      _state = _state.copyWith(errorMessage: "Username is required");
      notifyListeners();
      return;
    }
    if (_state.password.isEmpty) {
      _state = _state.copyWith(errorMessage: "Password is required");
      notifyListeners();
      return;
    }
    if (_state.confirmPassword.isEmpty) {
      _state = _state.copyWith(errorMessage: "Confirm Password is required");
      notifyListeners();
      return;
    }
    if (_state.password != _state.confirmPassword) {
      _state = _state.copyWith(errorMessage: "Passwords do not match");
      notifyListeners();
      return;
    }
    if (_state.phone.trim().isEmpty) {
      _state = _state.copyWith(errorMessage: "Phone is required");
      notifyListeners();
      return;
    }
    if (_state.address.trim().isEmpty) {
      _state = _state.copyWith(errorMessage: "Address is required");
      notifyListeners();
      return;
    }

    // All validation passed, start submission
    _state = _state.copyWith(isSubmitting: true, errorMessage: null);
    notifyListeners();

    try {
      // Simulate network request / registration call
      await Future.delayed(const Duration(seconds: 2));

      // On success:
      _state = _state.copyWith(isSubmitting: false, isSuccess: true, errorMessage: null);
      notifyListeners();

      // Optionally show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registration successful!")),
      );

      // You can navigate or reset form here if you want

    } catch (e) {
      _state = _state.copyWith(
        isSubmitting: false,
        errorMessage: "Registration failed. Please try again.",
      );
      notifyListeners();
    }
  }
}
