import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? userId;
  final String fullname;
  final String username;
  final String password;
  final String confirmpassword;
  final String phone;
  final String address;

  const UserEntity({
    this.userId,
    required this.fullname,
    required this.username,
    required this.password,
    required this.confirmpassword,
    required this.phone,
    required this.address,
  });
  
  @override
  // TODO: implement props
  List<Object?> get props => [
    userId,
    fullname,
    username,
    password,
    confirmpassword,
    phone,
    address,
  ];
  
}
