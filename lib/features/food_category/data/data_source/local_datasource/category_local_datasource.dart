import 'package:fooddelivery_b/core/network/hive_service.dart';
import 'package:fooddelivery_b/features/food_category/data/data_source/category_data_source.dart';
import 'package:fooddelivery_b/features/food_category/domain/entity/food_category_entity.dart';

class CategoryLocalDatasource implements ICategoryDataSource {
  final HiveService _hiveService;

  CategoryLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<FoodCategoryEntity> getCurrentCategory() {
    // TODO: implement getCurrentCategory
    throw UnimplementedError();
  }
    
}
