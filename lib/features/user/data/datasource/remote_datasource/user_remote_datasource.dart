import 'package:dio/dio.dart';
import 'package:fooddelivery_b/app/constant/api_endpoints.dart';
import 'package:fooddelivery_b/app/shared_pref/token_shared_prefs.dart';
import 'package:fooddelivery_b/core/network/api_service.dart';
import 'package:fooddelivery_b/features/user/data/datasource/user_data_source.dart';
import 'package:fooddelivery_b/features/user/data/model/user_api_model.dart';
import 'package:fooddelivery_b/features/user/domain/entity/user_entity.dart';

class UserRemoteDatasource implements IUserDataSource {
  final ApiService _apiService;
  final TokenSharedPrefs _tokenSharedPrefs;

  UserRemoteDatasource({
    required ApiService apiService,
    required TokenSharedPrefs tokenSharedPrefs,
  }) : _apiService = apiService,
       _tokenSharedPrefs = tokenSharedPrefs;

  @override
  Future<UserEntity> getCurrentUser() async {
    try {
      print('=== Remote Get Current User Started ===');
      print('Endpoint: ${ApiEndpoints.getCurrentUser}');
      
      final response = await _apiService.dio.get(
        ApiEndpoints.getCurrentUser,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${await _getStoredToken()}',
          },
        ),
      );

      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        final responseData = response.data;
        
        if (responseData['success'] == true && responseData['data'] != null) {
          final userData = responseData['data'];
          final userApiModel = UserApiModel.fromJson(userData);
          final userEntity = userApiModel.toEntity();
          
          print('Get current user successful');
          print('User address: ${userEntity.address}');
          return userEntity;
        } else {
          throw Exception('Get current user failed: Invalid response format');
        }
      } else {
        throw Exception('Get current user failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      print('DioException during get current user: ${e.message}');
      print('DioException type: ${e.type}');
      print('DioException response: ${e.response?.data}');
      
      if (e.response?.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      } else if (e.response?.statusCode == 403) {
        throw Exception('Access denied. Token required.');
      } else if (e.response != null && e.response!.data is Map<String, dynamic>) {
        final errorData = e.response!.data;
        if (errorData['message'] != null) {
          throw Exception('Get current user failed: ${errorData['message']}');
        }
      }
      throw Exception('Get current user failed: ${e.message}');
    } catch (e) {
      print('Unexpected error during get current user: $e');
      throw Exception('Unexpected error during get current user: $e');
    }
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
          await _tokenSharedPrefs.saveToken(responseData['token'] as String);
          return responseData['token'] as String;
        } else if (responseData['token'] != null) {
          // Direct token response
          await _tokenSharedPrefs.saveToken(responseData['token'] as String);
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

  // Helper method to get stored token
  Future<String?> _getStoredToken() async {
    try {
      final result = await _tokenSharedPrefs.getToken();
      return result.fold(
        (failure) {
          print('Failed to get token: ${failure.message}');
          return null;
        },
        (token) => token,
      );
    } catch (e) {
      print('Error getting stored token: $e');
      return null;
    }
  }
}
