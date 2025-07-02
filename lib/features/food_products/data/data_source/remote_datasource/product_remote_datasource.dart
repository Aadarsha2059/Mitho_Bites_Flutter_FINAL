
import 'package:dio/dio.dart';
import 'package:fooddelivery_b/app/constant/api_endpoints.dart';
import 'package:fooddelivery_b/core/network/api_service.dart';
import 'package:fooddelivery_b/features/food_products/data/data_source/product_datasource.dart';
import 'package:fooddelivery_b/features/food_products/data/model/product_api_model.dart';
import 'package:fooddelivery_b/features/food_products/domain/entity/products_entity.dart';

class ProductRemoteDatasource implements IProductDataSource {
  final ApiService _apiService;

  ProductRemoteDatasource({required ApiService apiService})
      : _apiService = apiService;

  @override
  Future<void> clearProducts() async {
    // Only admin can delete products
    throw UnimplementedError('Products can be removed by admin only');
  }

  @override
  Future<List<ProductsEntity>> getAllProducts() async {
    try {
      final response = await _apiService.dio.get(ApiEndpoints.getAllProducts);

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData['success'] == true && responseData['data'] != null) {
          final List<dynamic> productsData = responseData['data'];
          return productsData
              .map((json) => ProductApiModel.fromJson(json).toEntity())
              .toList();
        } else if (responseData is List) {
          // direct array response
          return responseData
              .map((json) => ProductApiModel.fromJson(json).toEntity())
              .toList();
        } else {
          throw Exception('Invalid response format from server');
        }
      } else {
        throw Exception('Failed to get products: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      if (e.response != null) {
        print('Response status: ${e.response!.statusCode}');
        print('Response data: ${e.response!.data}');
      }
      throw Exception('Failed to get products: ${e.message}');
    } catch (e) {
      print('General Exception: $e');
      throw Exception('Failed to get products: $e');
    }
  }

  @override
  Future<void> saveProducts(List<ProductsEntity> products) async {
    // Only admin can add new product item
    throw UnimplementedError('Products are added by admin');
  }

  @override
  Future<List<ProductsEntity>> getProductsByCategory(String categoryId) async {
    try {
      final response = await _apiService.dio.get(
        ApiEndpoints.getAllProducts,
        queryParameters: {'category': categoryId},
      );

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData['success'] == true && responseData['data'] != null) {
          final List<dynamic> productsData = responseData['data'];
          return productsData
              .map((json) => ProductApiModel.fromJson(json).toEntity())
              .toList();
        } else if (responseData is List) {
          // direct array response
          return responseData
              .map((json) => ProductApiModel.fromJson(json).toEntity())
              .toList();
        } else {
          throw Exception('Invalid response format from server');
        }
      } else {
        throw Exception('Failed to get products by category: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      if (e.response != null) {
        print('Response status: ${e.response!.statusCode}');
        print('Response data: ${e.response!.data}');
      }
      throw Exception('Failed to get products by category: ${e.message}');
    } catch (e) {
      print('General Exception: $e');
      throw Exception('Failed to get products by category: $e');
    }
  }
}