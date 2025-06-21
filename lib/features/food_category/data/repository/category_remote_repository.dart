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
        final List<dynamic> categoriesData = response.data['data'] ?? response.data;
        return categoriesData
            .map((json) => CategoryApiModel.fromJson(json).toEntity())
            .toList();
      } else {
        throw Exception('Failed to get categories: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to get categories: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get categories: $e');
    }
  }

  @override
  Future<void> saveCategories(List<FoodCategoryEntity> categories) async {
   
  }

  @override
  Future<void> clearCategories() async {
   
  }
} 