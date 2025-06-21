import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/app/use_case/usecase.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/food_category/domain/repository/category_repository.dart';

class ClearCategoriesUsecase implements UsecaseWithoutParams<void> {
  final ICategoryRepository _categoryRepository;

  ClearCategoriesUsecase({required ICategoryRepository categoryRepository})
    : _categoryRepository = categoryRepository;

  @override
  Future<Either<Failure, void>> call() {
    return _categoryRepository.clearCategories();
  }
} 