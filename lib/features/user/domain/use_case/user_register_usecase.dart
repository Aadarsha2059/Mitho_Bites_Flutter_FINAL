import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/app/use_case/usecase.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/user/domain/entity/user_entity.dart';
import 'package:fooddelivery_b/features/user/domain/repository/user_repository.dart';

class UserRegisterUsecase implements UseCaseWithParams<void, RegisterUserParams> {
  final IUserRepository _userRepository;

  UserRegisterUsecase({required IUserRepository userRepository})
    : _userRepository = userRepository;

  @override
  Future<Either<Failure, void>> call(RegisterUserParams params) {
    final userEntity = UserEntity(
      userId: null,
      fullname: params.fullname,
      username: params.username,
      password: params.password,
      phone: params.phone,
      address: params.address,
      email: params.email,
    );
    return _userRepository.registerUser(userEntity);
  }
}

class RegisterUserParams {
  final String fullname;
  final String username;
  final String password;
  final String phone;
  final String address;
  final String email;

  RegisterUserParams({
    required this.fullname,
    required this.username,
    required this.password,
    required this.phone,
    required this.address,
    required this.email,
  });
}
