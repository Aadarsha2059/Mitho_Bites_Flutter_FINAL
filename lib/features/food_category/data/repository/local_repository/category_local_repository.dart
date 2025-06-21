import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/food_category/data/data_source/local_datasource/category_local_datasource.dart';
import 'package:fooddelivery_b/features/food_category/domain/entity/food_category_entity.dart';
import 'package:fooddelivery_b/features/food_category/domain/repository/category_repository.dart';

class CategoryLocalRepository implements ICategoryRepository {
  final CategoryLocalDatasource _categoryLocalDatasource;

  CategoryLocalRepository({
    required CategoryLocalDatasource categoryLocalDatasource,
  }) : _categoryLocalDatasource = categoryLocalDatasource;

  @override
  Future<Either<Failure, List<FoodCategoryEntity>>> getCategories() async {
    try {
      final categories = await _categoryLocalDatasource.getAllCategories();
      return Right(categories);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveCategories(List<FoodCategoryEntity> categories) async {
    try {
      await _categoryLocalDatasource.saveCategories(categories);
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearCategories() async {
    try {
      await _categoryLocalDatasource.clearCategories();
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
} 