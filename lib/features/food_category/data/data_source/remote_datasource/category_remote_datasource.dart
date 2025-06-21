import 'package:dio/dio.dart';
import 'package:fooddelivery_b/app/constant/api_endpoints.dart';
import 'package:fooddelivery_b/core/network/api_service.dart';
import 'package:fooddelivery_b/features/food_category/data/data_source/category_data_source.dart';
import 'package:fooddelivery_b/features/food_category/data/model/category_api_model.dart';
import 'package:fooddelivery_b/features/food_category/domain/entity/food_category_entity.dart';

class CategoryRemoteDataSource implements ICategoryDataSource {
  final ApiService _apiService;
  
  CategoryRemoteDataSource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<List<FoodCategoryEntity>> getAllCategories() async {
    try {
      final response = await _apiService.dio.get(
        ApiEndpoints.getAllCategory,
      );
      
      if (response.statusCode == 200) {
        // Handle MERN backend response structure
        final responseData = response.data;
        
        // Check if response has success field and data
        if (responseData['success'] == true && responseData['data'] != null) {
          final List<dynamic> categoriesData = responseData['data'];
          return categoriesData
              .map((json) => CategoryApiModel.fromJson(json).toEntity())
              .toList();
        } else if (responseData is List) {
          // Direct array response
          return responseData
              .map((json) => CategoryApiModel.fromJson(json).toEntity())
              .toList();
        } else {
          throw Exception('Invalid response format from server');
        }
      } else {
        throw Exception('Failed to get categories: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      if (e.response != null) {
        print('Response status: ${e.response!.statusCode}');
        print('Response data: ${e.response!.data}');
      }
      throw Exception('Failed to get categories: ${e.message}');
    } catch (e) {
      print('General Exception: $e');
      throw Exception('Failed to get categories: $e');
    }
  }

  @override
  Future<void> saveCategories(List<FoodCategoryEntity> categories) async {
    // Categories are managed by admin panel, not by client
    throw UnimplementedError('Categories are managed by admin panel');
  }

  @override
  Future<void> clearCategories() async {
    // Categories are managed by admin panel, not by client
    throw UnimplementedError('Categories are managed by admin panel');
  }
} 