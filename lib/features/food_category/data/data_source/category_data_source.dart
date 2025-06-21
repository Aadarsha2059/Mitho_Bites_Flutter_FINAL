import 'package:fooddelivery_b/features/food_category/domain/entity/food_category_entity.dart';

abstract interface class ICategoryDataSource {

  Future<List<FoodCategoryEntity>> getAllCategories();
  

  Future<void> saveCategories(List<FoodCategoryEntity> categories);
  

  Future<void> clearCategories();
}