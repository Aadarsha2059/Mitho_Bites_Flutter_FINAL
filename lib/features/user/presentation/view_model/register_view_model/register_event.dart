import 'package:flutter/material.dart';

@immutable
sealed class RegisterEvent {}


class RegisterUserEvent extends RegisterEvent {
  final BuildContext context;
  final String fullname;
  final String username;
  final String password;
  final String phone;
  final String address;

  RegisterUserEvent({
    required this.context,
    required this.fullname,
    required this.username,
    required this.password,
    required this.phone,
    required this.address,
  });
}


