// register_event.dart
abstract class RegisterEvent {}

class FullNameChanged extends RegisterEvent {
  final String fullName;
  FullNameChanged(this.fullName);
}

class UsernameChanged extends RegisterEvent {
  final String username;
  UsernameChanged(this.username);
}

class PasswordChanged extends RegisterEvent {
  final String password;
  PasswordChanged(this.password);
}

class ConfirmPasswordChanged extends RegisterEvent {
  final String confirmPassword;
  ConfirmPasswordChanged(this.confirmPassword);
}

class PhoneChanged extends RegisterEvent {
  final String phone;
  PhoneChanged(this.phone);
}

class AddressChanged extends RegisterEvent {
  final String address;
  AddressChanged(this.address);
}

class SubmitRegistration extends RegisterEvent {}
