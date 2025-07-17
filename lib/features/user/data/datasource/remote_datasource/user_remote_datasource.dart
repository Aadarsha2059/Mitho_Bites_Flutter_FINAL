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
  })  : _apiService = apiService,
        _tokenSharedPrefs = tokenSharedPrefs;

  /// Retrieves the current user's data from the remote API.
  @override
  Future<UserEntity> getCurrentUser() async {
    try {
      print('=== Remote Get Current User Started ===');
      print('Endpoint: ${ApiEndpoints.getCurrentUser}');

      final token = await _getStoredToken();
      if (token == null || token.isEmpty) {
        throw Exception('Authentication failed: No valid token found');
      }

      final response = await _apiService.dio.get(
        ApiEndpoints.getCurrentUser,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>?;

        if (responseData == null || responseData['success'] != true || responseData['data'] == null) {
          throw Exception('Get current user failed: Invalid response format');
        }

        final userData = responseData['data'] as Map<String, dynamic>;
        final userApiModel = UserApiModel.fromJson(userData);
        final userEntity = userApiModel.toEntity();

        print('Get current user successful');
        print('User address: ${userEntity.address}');
        return userEntity;
      } else {
        throw Exception('Get current user failed: ${response.statusMessage ?? "Unknown error"}');
      }
    } on DioException catch (e) {
      print('DioException during get current user: ${e.message}');
      print('DioException type: ${e.type}');
      print('DioException response: ${e.response?.data}');

      if (e.response?.statusCode == 401) {
        throw Exception('Authentication failed: Please login again');
      } else if (e.response?.statusCode == 403) {
        throw Exception('Access denied: Token required');
      }

      final errorData = e.response?.data as Map<String, dynamic>?;
      throw Exception('Get current user failed: ${errorData?['message'] ?? e.message ?? "Unknown error"}');
    } catch (e) {
      print('Unexpected error during get current user: $e');
      throw Exception('Unexpected error during get current user: $e');
    }
  }

  /// Authenticates a user with the provided credentials and returns a token.
  @override
  Future<String> loginUser(String username, String password) async {
    try {
      print('=== Remote Login Started ===');
      print('Endpoint: ${ApiEndpoints.login}');

      final response = await _apiService.dio.post(
        ApiEndpoints.login,
        data: {'username': username, 'password': password},
      );

      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>?;

        if (responseData == null || responseData['token'] == null) {
          throw Exception('Login failed: No token received');
        }

        final token = responseData['token'] as String;
        await _tokenSharedPrefs.saveToken(token);

        print('Login successful');
        return token;
      } else {
        throw Exception('Login failed: ${response.statusMessage ?? "Unknown error"}');
      }
    } on DioException catch (e) {
      print('DioException during login: ${e.message}');
      print('DioException response: ${e.response?.data}');

      final errorData = e.response?.data as Map<String, dynamic>?;
      throw Exception('Login failed: ${errorData?['message'] ?? e.message ?? "Unknown error"}');
    } catch (e) {
      print('Unexpected error during login: $e');
      throw Exception('Unexpected error during login: $e');
    }
  }

  /// Registers a new user with the provided data.
  @override
  Future<void> registerUser(UserEntity userData) async {
    try {
      print('=== Remote Registration Started ===');
      print('Endpoint: ${ApiEndpoints.register}');

      final userApiModel = UserApiModel.fromEntity(userData);
      final registrationData = userApiModel.toJson();

      // Ensure phone is sent as a number if required by the backend
      if (registrationData['phone'] != null) {
        registrationData['phone'] = int.tryParse(registrationData['phone'].toString()) ?? 0;
      }

      // Ensure confirmpassword matches password for backend validation
      registrationData['confirmpassword'] = userData.password;

      print('Registration data: $registrationData');

      final response = await _apiService.dio.post(
        ApiEndpoints.register,
        data: registrationData,
      );

      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>?;

        if (responseData != null && responseData['success'] == true) {
          print('Registration successful');
          return;
        }

        print('Registration successful (no success flag)');
        return;
      } else {
        throw Exception('Registration failed: ${response.statusMessage ?? "Unknown error"}');
      }
    } on DioException catch (e) {
      print('DioException during registration: ${e.message}');
      print('DioException response: ${e.response?.data}');

      final errorData = e.response?.data as Map<String, dynamic>?;
      throw Exception('Registration failed: ${errorData?['message'] ?? e.message ?? "Unknown error"}');
    } catch (e) {
      print('Unexpected error during registration: $e');
      throw Exception('Unexpected error during registration: $e');
    }
  }

  /// Updates the user data on the remote API.
  @override
  Future<UserEntity> updateUser(UserEntity user, {String? currentPassword}) async {
    try {
      print('=== Remote Update User Started ===');
      final endpoint = '${ApiEndpoints.updateUser}/${user.userId}';
      print('Endpoint: $endpoint');

      final token = await _getStoredToken();
      if (token == null || token.isEmpty) {
        throw Exception('Authentication failed: No valid token found');
      }

      final userApiModel = UserApiModel.fromEntity(user);
      final updateData = userApiModel.toJson();

      // Remove password fields if not changed
      if (user.password.isEmpty) {
        updateData.remove('password');
        updateData.remove('confirmpassword');
      } else {
        updateData['confirmpassword'] = user.password;
      }

      // Add currentPassword if provided (for sensitive changes)
      if (currentPassword != null && currentPassword.isNotEmpty) {
        updateData['currentPassword'] = currentPassword;
      }

      print('Update data to send: $updateData');

      final response = await _apiService.dio.put(
        endpoint,
        data: updateData,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>?;

        if (responseData == null || responseData['success'] != true) {
          throw Exception('Update user failed: Invalid response format');
        }
        // Accept both 'user' and 'data' as the user object
        final userData = responseData['user'] ?? responseData['data'];
        if (userData == null) {
          throw Exception('Update user failed: Invalid response format');
        }
        final userApiModel = UserApiModel.fromJson(userData as Map<String, dynamic>);
        final userEntity = userApiModel.toEntity();

        print('Update user successful');
        return userEntity;
      } else {
        throw Exception('Update user failed: ${response.statusMessage ?? "Unknown error"}');
      }
    } on DioException catch (e) {
      print('DioException during update user: ${e.message}');
      print('DioException response: ${e.response?.data}');

      final errorData = e.response?.data as Map<String, dynamic>?;
      throw Exception('Update user failed: ${errorData?['message'] ?? e.message ?? "Unknown error"}');
    } catch (e) {
      print('Unexpected error during update user: $e');
      throw Exception('Unexpected error during update user: $e');
    }
  }

  /// Helper method to retrieve the stored authentication token.
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