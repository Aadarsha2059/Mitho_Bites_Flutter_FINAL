import 'package:equatable/equatable.dart';

class RegisterUserParams extends Equatable {
  final String fullname;
  final String username;
  final String password;
  final String confirmpassword;
  final String phone;
  final String address;

  const RegisterUserParams({
    required this.fullname,
    required this.username,
    required this.password,
    required this.confirmpassword,
    required this.phone,
    required this.address,
  });

  //initial constructor
  const RegisterUserParams.initial({
    required this.fullname,
    required this.username,
    required this.password,
    required this.confirmpassword,
    required this.phone,
    required this.address,
  });
  
  @override

  List<Object?> get props => [
    fullname,
    username,
    password,
    confirmpassword,
    phone,
    address,

  ];

}
