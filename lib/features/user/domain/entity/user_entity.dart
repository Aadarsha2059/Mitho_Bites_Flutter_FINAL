import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? userId;
  final String fullname;
  final String username;
  final String password;
  final String phone;
  final String address;

  const UserEntity({
    this.userId,
    required this.fullname,
    required this.username,
    required this.password,
    required this.phone,
    required this.address,
  });
  
 
  
  @override
  List<Object?> get props => [
    userId,
    fullname,
    username,
    password,
    phone,
    address,
  ];
}
