import 'package:dio/dio.dart';
import 'package:fooddelivery_b/app/constant/api_constants.dart';
import 'package:fooddelivery_b/core/network/api_service.dart';
import 'package:fooddelivery_b/features/user/data/datasource/user_data_source.dart';
import 'package:fooddelivery_b/features/user/data/model/user_api_model.dart';
import 'package:fooddelivery_b/features/user/domain/entity/user_entity.dart';

class UserRemoteDatasource implements IUserDataSource {
  final ApiService _apiService;

  UserRemoteDatasource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<UserEntity> getCurrentUser() async {
    try {
      final response = await _apiService.dio.get(ApiEndpoints.getAllUser);

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final userModel = UserApiModel.fromJson(response.data);
        return userModel.toEntity();
      } else {
        throw Exception(
          'Failed to fetch current user: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Failed to fetch current user: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error while fetching user: $e');
    }
  }

  @override
  Future<String> loginUser(String username, String password) async {
    try {
      final response = await _apiService.dio.post(
        ApiEndpoints.login,
        data: {'username': username, 'password': password},
      );
      if (response.statusCode == 200 && response.data['token'] != null) {
        return response.data['token'] as String;
      } else {
        throw Exception('Login failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Login failed: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error during login: $e');
    }
  }

  @override
  Future<void> registerUser(UserEntity userData) async {
    try {
      final userApiModel = UserApiModel.fromEntity(userData);

      final response = await _apiService.dio.post(
        ApiEndpoints.register,
        data: userApiModel.toJson(), // Fixed: Use instance method
      );

      if (response.statusCode != 201) {
        throw Exception('Registration failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Registration failed: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error during registration: $e');
    }
  }
}
