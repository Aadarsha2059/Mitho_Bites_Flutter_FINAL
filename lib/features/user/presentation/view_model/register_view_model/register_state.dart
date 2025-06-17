// register_state.dart
class RegisterState {
  final String fullName;
  final String username;
  final String password;
  final String confirmPassword;
  final String phone;
  final String address;

  final bool isSubmitting;
  final String? errorMessage;
  final bool isSuccess;

  RegisterState({
    this.fullName = '',
    this.username = '',
    this.password = '',
    this.confirmPassword = '',
    this.phone = '',
    this.address = '',
    this.isSubmitting = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  RegisterState copyWith({
    String? fullName,
    String? username,
    String? password,
    String? confirmPassword,
    String? phone,
    String? address,
    bool? isSubmitting,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return RegisterState(
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
