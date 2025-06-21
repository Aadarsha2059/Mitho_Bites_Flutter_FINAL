import 'package:fooddelivery_b/app/constant/hive_table_constant.dart';
import 'package:fooddelivery_b/core/network/hive_service.dart';
import 'package:fooddelivery_b/features/food_category/data/data_source/category_data_source.dart';
import 'package:fooddelivery_b/features/food_category/data/model/category_hive_model.dart';
import 'package:fooddelivery_b/features/food_category/domain/entity/food_category_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CategoryLocalDatasource implements ICategoryDataSource {
  final HiveService _hiveService;

  CategoryLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<List<FoodCategoryEntity>> getAllCategories() async {
    try {
      var box = await Hive.openBox<CategoryHiveModel>(HiveTableConstant.categoryBox);
      return box.values.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception("Failed to get categories: $e");
    }
  }

  @override
  Future<void> saveCategories(List<FoodCategoryEntity> categories) async {
    try {
      var box = await Hive.openBox<CategoryHiveModel>(HiveTableConstant.categoryBox);
      await box.clear(); // Clear existing data
      for (var category in categories) {
        final hiveModel = CategoryHiveModel.fromEntity(category);
        await box.put(hiveModel.categoryId, hiveModel);
      }
    } catch (e) {
      throw Exception("Failed to save categories: $e");
    }
  }

  @override
  Future<void> clearCategories() async {
    try {
      var box = await Hive.openBox<CategoryHiveModel>(HiveTableConstant.categoryBox);
      await box.clear();
    } catch (e) {
      throw Exception("Failed to clear categories: $e");
    }
  }
}
