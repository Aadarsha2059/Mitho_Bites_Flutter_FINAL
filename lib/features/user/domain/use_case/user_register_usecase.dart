import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery_b/app/use_case/usecase.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/user/domain/entity/user_entity.dart';
import 'package:fooddelivery_b/features/user/domain/repository/user_repository.dart';

class RegisterUserParams extends Equatable {
  final String fullname;
  final String username;
  final String password;
  final String phone;
  final String address;

  const RegisterUserParams({
    required this.fullname,
    required this.username,
    required this.password,
    required this.phone,
    required this.address,
  });

  //initial constructor
  const RegisterUserParams.initial({
    required this.fullname,
    required this.username,
    required this.password,
   
    required this.phone,
    required this.address,
  });

  @override
  List<Object?> get props => [
    fullname,
    username,
    password,
    phone,
    address,
  ];
}

class UserRegisterUsecase
    implements UseCaseWithParams<void, RegisterUserParams> {
  final IUserRepository _userRepository;

  UserRegisterUsecase({required IUserRepository userRepository})
    : _userRepository = userRepository;

  @override
  Future<Either<Failure, void>> call(RegisterUserParams params) {
    final userEntity = UserEntity(
      fullname: params.fullname,
      username: params.username,
      password: params.password,
     
      phone: params.phone,
      address: params.address,
    );
    return _userRepository.registerUser(userEntity);
  }
}
