import 'package:fooddelivery_b/app/constant/hive_table_constant.dart';
import 'package:fooddelivery_b/core/network/hive_service.dart';
import 'package:fooddelivery_b/features/restaurant/data/data_source/restaurant_datasource.dart';
import 'package:fooddelivery_b/features/restaurant/data/model/restaurant_hive_model.dart';
import 'package:fooddelivery_b/features/restaurant/domain/entity/restaurant_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';

class RestauranntLocalDatasource implements IRestaurantDataSource {
  final HiveService _hiveService;

  RestauranntLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<void> clearRestaurants() async {
    try {
      var box = await Hive.openBox<RestaurantHiveModel>(
        HiveTableConstant.restaurantBox,
      );
      await box.clear();
    } catch (e) {
      throw Exception("Failed to clear categories: $e");
    }
  }

  @override
  Future<List<RestaurantEntity>> getAllRestaurants() async {
    try {
      var box = await Hive.openBox<RestaurantHiveModel>(
        HiveTableConstant.restaurantBox,
      );
      return box.values.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception("Failed to get restaurants: $e");
    }
  }

  @override
  Future<void> saveRestaurants(List<RestaurantEntity> restaurants) async {
    try {
      var box = await Hive.openBox<RestaurantHiveModel>(
        HiveTableConstant.restaurantBox,
      );
      await box.clear();
      for (var restaurant in restaurants) {
        final hiveModel = RestaurantHiveModel.fromEntity(restaurant);
        await box.put(hiveModel.restaurantId, hiveModel);
      }
    } catch (e) {
      throw Exception("Failed to save categories: $e");
    }
  }
}
