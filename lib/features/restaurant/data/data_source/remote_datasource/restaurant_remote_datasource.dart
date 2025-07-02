
import 'package:dio/dio.dart';
import 'package:fooddelivery_b/app/constant/api_endpoints.dart';
import 'package:fooddelivery_b/core/network/api_service.dart';
import 'package:fooddelivery_b/features/restaurant/data/data_source/restaurant_datasource.dart';
import 'package:fooddelivery_b/features/restaurant/data/model/restaurant_api_model.dart';
import 'package:fooddelivery_b/features/restaurant/domain/entity/restaurant_entity.dart';

class RestaurantRemoteDatasource implements IRestaurantDataSource {
  final ApiService _apiService;

  RestaurantRemoteDatasource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<void> clearRestaurants() async {
    //admin can delete the restaurants
    throw UnimplementedError('restaurants can be removed by admin only');
  }

  @override
  Future<List<RestaurantEntity>> getAllRestaurants() async {
    try {
      final response = await _apiService.dio.get(ApiEndpoints.getAllRestaurant);

      if (response.statusCode == 200) {
        // handle the mern backend response structure
        final responseData = response.data;

        //check if reponse has success field and data
        if (responseData['success'] == true && responseData['data'] != null) {
          final List<dynamic> restaurantsData = responseData['data'];
          return restaurantsData
              .map((json) => RestaurantApiModel.fromJson(json).toEntity())
              .toList();
        } else if (responseData is List) {
          //direct array response
          return responseData
              .map((json) => RestaurantApiModel.fromJson(json).toEntity())
              .toList();
        } else if (responseData is List) {
          //direct array response
          return responseData
              .map((json) => RestaurantApiModel.fromJson(json).toEntity())
              .toList();
        } else {
          throw Exception('Invalid response format from server');
        }
      } else {
        throw Exception('Failed to get restaurants: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      if (e.response != null) {
        print('Response status: ${e.response!.statusCode}');
        print('Response data: ${e.response!.data}');
      }
      throw Exception('Failed to get restaurants: ${e.message}');
    } catch (e) {
      print('General Exception: $e');
      throw Exception('Failed to get categories: $e');
    }
  }

  @override
  Future<void> saveRestaurants(List<RestaurantEntity> restaurants) async {
    // only admin can add new restaurant item
    throw UnimplementedError('restaurants are added by admin ');
  }
}
