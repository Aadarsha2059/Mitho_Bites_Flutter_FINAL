import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/app/use_case/usecase.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/food_category/domain/entity/food_category_entity.dart';
import 'package:fooddelivery_b/features/food_category/domain/repository/category_repository.dart';

class GetCategoriesUsecase implements UsecaseWithoutParams<List<FoodCategoryEntity>> {
  final ICategoryRepository _categoryRepository;

  GetCategoriesUsecase({required ICategoryRepository categoryRepository})
    : _categoryRepository = categoryRepository;

  @override
  Future<Either<Failure, List<FoodCategoryEntity>>> call() {
    return _categoryRepository.getCategories();
  }
} 