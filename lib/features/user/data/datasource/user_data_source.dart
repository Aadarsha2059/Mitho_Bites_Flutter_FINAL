import 'package:fooddelivery_b/features/user/domain/entity/user_entity.dart';

abstract interface class IUserDataSource {
  Future<void> registerUser(UserEntity userData);

  Future<String> loginUser(String username, String password);

  Future<UserEntity> getCurrentUser();

  Future<UserEntity> updateUser(UserEntity user);
}
