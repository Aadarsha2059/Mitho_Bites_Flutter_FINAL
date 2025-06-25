import 'package:dio/dio.dart';
import 'package:fooddelivery_b/app/constant/api_endpoints.dart';
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
    // TODO: This endpoint doesn't exist in MERN backend
    // We need to either:
    // 1. Add a getCurrentUser endpoint to the backend
    // 2. Use JWT token to get user info
    // 3. Store user info locally after login
    throw UnimplementedError('getCurrentUser endpoint not available in MERN backend');
  }

  @override
  Future<String> loginUser(String username, String password) async {
    try {
      final response = await _apiService.dio.post(
        ApiEndpoints.login,
        data: {'username': username, 'password': password},
      );
      
      if (response.statusCode == 200) {
        final responseData = response.data;
        
        // Handle MERN backend response format
        if (responseData['success'] == true && responseData['token'] != null) {
          return responseData['token'] as String;
        } else if (responseData['token'] != null) {
          // Direct token response
          return responseData['token'] as String;
        } else {
          throw Exception('Login failed: No token received');
        }
      } else {
        throw Exception('Login failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null && e.response!.data is Map<String, dynamic>) {
        final errorData = e.response!.data;
        if (errorData['message'] != null) {
          throw Exception('Login failed: ${errorData['message']}');
        }
      }
      throw Exception('Login failed: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error during login: $e');
    }
  }

  @override
  Future<void> registerUser(UserEntity userData) async {
    try {
      print('=== Remote Registration Started ===');
      print('Endpoint: ${ApiEndpoints.register}');
      
      final userApiModel = UserApiModel.fromEntity(userData);
      final registrationData = userApiModel.toJson();
      
      // Ensure phone is sent as number to match backend validation
      if (registrationData['phone'] != null) {
        registrationData['phone'] = int.tryParse(registrationData['phone'].toString()) ?? 0;
      }
      
      // Ensure confirmpassword is set to match password for validation
      registrationData['confirmpassword'] = userData.password;
      
      print('Registration data: $registrationData');

      final response = await _apiService.dio.post(
        ApiEndpoints.register,
        data: registrationData,
      );

      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = response.data;
        
        // Handle MERN backend response format
        if (responseData is Map<String, dynamic>) {
          if (responseData['success'] == true) {
            print('Registration successful');
            return;
          } else if (responseData['message'] != null) {
            print('Registration failed with message: ${responseData['message']}');
            throw Exception('Registration failed: ${responseData['message']}');
          }
        }
        print('Registration successful (no success flag)');
        return;
      } else {
        print('Registration failed with status: ${response.statusMessage}');
        throw Exception('Registration failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      print('DioException during registration: ${e.message}');
      print('DioException type: ${e.type}');
      print('DioException response: ${e.response?.data}');
      
      if (e.response != null && e.response!.data is Map<String, dynamic>) {
        final errorData = e.response!.data;
        if (errorData['message'] != null) {
          throw Exception('Registration failed: ${errorData['message']}');
        }
      }
      throw Exception('Registration failed: ${e.message}');
    } catch (e) {
      print('Unexpected error during registration: $e');
      throw Exception('Unexpected error during registration: $e');
    }
  }
}
