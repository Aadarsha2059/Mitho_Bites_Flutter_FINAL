import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/app/use_case/usecase.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/food_category/domain/entity/food_category_entity.dart';
import 'package:fooddelivery_b/features/food_category/domain/repository/category_repository.dart';

class SaveCategoriesUsecase implements UseCaseWithParams<void, List<FoodCategoryEntity>> {
  final ICategoryRepository _categoryRepository;

  SaveCategoriesUsecase({required ICategoryRepository categoryRepository})
    : _categoryRepository = categoryRepository;

  @override
  Future<Either<Failure, void>> call(List<FoodCategoryEntity> categories) {
    return _categoryRepository.saveCategories(categories);
  }
} 