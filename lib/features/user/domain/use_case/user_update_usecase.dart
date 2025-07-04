import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/app/use_case/usecase.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/user/domain/entity/user_entity.dart';
import 'package:fooddelivery_b/features/user/domain/repository/user_repository.dart';

class UserUpdateUsecase implements UseCaseWithParams<UserEntity, UserEntity> {
  final IUserRepository _userRepository;

  UserUpdateUsecase({required IUserRepository userRepository})
      : _userRepository = userRepository;

  @override
  Future<Either<Failure, UserEntity>> call(UserEntity params) {
    return _userRepository.updateUser(params);
  }
} 