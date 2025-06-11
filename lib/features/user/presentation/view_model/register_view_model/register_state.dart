class RegisterState {
  final String fullName;
  final String username;
  final String password;
  final String confirmPassword;
  final String phone;
  final String address;
  final String? errorMessage;
  final bool isSubmitting;
  final bool isSuccess;

  RegisterState({
    this.fullName = '',
    this.username = '',
    this.password = '',
    this.confirmPassword = '',
    this.phone = '',
    this.address = '',
    this.errorMessage,
    this.isSubmitting = false,
    this.isSuccess = false,
  });

  RegisterState copyWith({
    String? fullName,
    String? username,
    String? password,
    String? confirmPassword,
    String? phone,
    String? address,
    String? errorMessage,
    bool? isSubmitting,
    bool? isSuccess,
  }) {
    return RegisterState(
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      errorMessage: errorMessage,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
