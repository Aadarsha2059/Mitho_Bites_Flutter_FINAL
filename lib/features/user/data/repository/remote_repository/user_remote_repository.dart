import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/user/data/datasource/remote_datasource/user_remote_datasource.dart';
import 'package:fooddelivery_b/features/user/domain/entity/user_entity.dart';
import 'package:fooddelivery_b/features/user/domain/repository/user_repository.dart';

class UserRemoteRepository implements IUserRepository {
  final UserRemoteDatasource _userRemoteDatasource;

  UserRemoteRepository({required UserRemoteDatasource userRemoteDatasource})
    : _userRemoteDatasource = userRemoteDatasource;

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final user = await _userRemoteDatasource.getCurrentUser();
      return Right(user);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> loginUser(
    String username,
    String password,
  ) async {
    try {
      final token = await _userRemoteDatasource.loginUser(username, password);
      return Right(token);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> registerUser(UserEntity user) async {
    try {
      await _userRemoteDatasource.registerUser(user);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUser(UserEntity user, {String? currentPassword}) async {
    try {
      final updatedUser = await _userRemoteDatasource.updateUser(user, currentPassword: currentPassword);
      return Right(updatedUser);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
}
