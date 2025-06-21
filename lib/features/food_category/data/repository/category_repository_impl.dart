import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/food_category/data/repository/local_repository/category_local_repository.dart';
import 'package:fooddelivery_b/features/food_category/data/repository/remote_repository/category_remote_repository.dart';
import 'package:fooddelivery_b/features/food_category/domain/entity/food_category_entity.dart';
import 'package:fooddelivery_b/features/food_category/domain/repository/category_repository.dart';

class CategoryRepositoryImpl implements ICategoryRepository {
  final CategoryLocalRepository _localRepository;
  final CategoryRemoteRepository _remoteRepository;

  CategoryRepositoryImpl({
    required CategoryLocalRepository localRepository,
    required CategoryRemoteRepository remoteRepository,
  }) : _localRepository = localRepository,
       _remoteRepository = remoteRepository;

  @override
  Future<Either<Failure, List<FoodCategoryEntity>>> getCategories() async {
   
    final localResult = await _localRepository.getCategories();
    
    return localResult.fold(
      (localFailure) async {
     
        final remoteResult = await _remoteRepository.getCategories();
        return remoteResult.fold(
          (remoteFailure) => Left(remoteFailure),
          (categories) async {
           
            await _localRepository.saveCategories(categories);
            return Right(categories);
          },
        );
      },
      (localCategories) {
       
        _refreshCategoriesInBackground();
        return Right(localCategories);
      },
    );
  }

  @override
  Future<Either<Failure, void>> saveCategories(List<FoodCategoryEntity> categories) async {

    return await _localRepository.saveCategories(categories);
  }

  @override
  Future<Either<Failure, void>> clearCategories() async {
   
    return await _localRepository.clearCategories();
  }

  void _refreshCategoriesInBackground() async {
    try {
      final remoteResult = await _remoteRepository.getCategories();
      remoteResult.fold(
        (failure) {
          
        },
        (categories) async {
       
          await _localRepository.saveCategories(categories);
        },
      );
    } catch (e) {
      // Silent fail - user still sees local data
    }
  }
} 