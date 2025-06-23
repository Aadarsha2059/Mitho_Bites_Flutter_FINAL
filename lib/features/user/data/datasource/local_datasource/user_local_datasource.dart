import 'package:fooddelivery_b/core/network/hive_service.dart';
import 'package:fooddelivery_b/features/user/data/datasource/user_data_source.dart';
import 'package:fooddelivery_b/features/user/data/model/user_hive_model.dart';
import 'package:fooddelivery_b/features/user/domain/entity/user_entity.dart';

class UserLocalDatasource implements IUserDataSource {
  final HiveService _hiveService;

  UserLocalDatasource({required HiveService hiveservice})
    : _hiveService = hiveservice;

  @override
  Future<String> loginUser(String username, String password) async {
    try {
      final userData = await _hiveService.login(username, password);
      if (userData != null && userData.password == password) {
        return "local_login_successful";
      } else {
        throw Exception("Invalid username or password");
      }
    } catch (e) {
      throw Exception("Local login failed: $e");
    }
  }

  @override
  Future<void> registerUser(UserEntity user) async {
    try {
      final userHiveModel = UserHiveModel.fromEntity(user);
      await _hiveService.register(userHiveModel);
    } catch (e) {
      throw Exception("Local registration failed: $e");
    }
  }
  
  @override
  Future<UserEntity> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }
}
