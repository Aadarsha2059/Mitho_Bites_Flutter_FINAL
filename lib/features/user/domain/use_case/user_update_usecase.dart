import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/app/use_case/usecase.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/user/domain/entity/user_entity.dart';
import 'package:fooddelivery_b/features/user/domain/repository/user_repository.dart';

class UserUpdateUsecase implements UseCaseWithParams<UserEntity, UserEntity> {
  final IUserRepository _userRepository;

  UserUpdateUsecase({required IUserRepository userRepository})
      : _userRepository = userRepository;

  Future<Either<Failure, UserEntity>> call(UserEntity params, {String? currentPassword}) {
    // If the repository supports currentPassword, pass it; otherwise, fallback
    if (_userRepository is dynamic) {
      try {
        return (_userRepository as dynamic).updateUser(params, currentPassword: currentPassword);
      } catch (_) {
        return _userRepository.updateUser(params);
      }
    }
    return _userRepository.updateUser(params);
  }
} 