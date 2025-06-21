import 'package:fooddelivery_b/features/food_category/domain/entity/food_category_entity.dart';

abstract interface class ICategoryDataSource {
  Future<FoodCategoryEntity> getCurrentCategory();
}
