import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/food_category/domain/entity/food_category_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class ICategoryRepository {
  Future<Either<Failure, List<FoodCategoryEntity>>> getCategories();
  Future<Either<Failure, void>> saveCategories(List<FoodCategoryEntity> categories);
  Future<Either<Failure, void>> clearCategories();
}