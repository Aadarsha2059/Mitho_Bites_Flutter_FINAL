import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/food_products/data/repository/local_repository/product_local_repository.dart';
import 'package:fooddelivery_b/features/food_products/data/repository/remote_repository/product_remote_repository.dart';
import 'package:fooddelivery_b/features/food_products/domain/entity/products_entity.dart';

import 'package:fooddelivery_b/features/food_products/domain/repository/products_repository.dart';

class ProductRepositoryImpl implements IProductRepository {
  final ProductLocalRepository _localRepository;
  final ProductRemoteRepository _remoteRepository;

  ProductRepositoryImpl({
    required ProductLocalRepository localRepository,
    required ProductRemoteRepository remoteRepository,
  })  : _localRepository = localRepository,
        _remoteRepository = remoteRepository;

  @override
  Future<Either<Failure, List<ProductsEntity>>> getProducts() async {
    final localResult = await _localRepository.getProducts();
    return localResult.fold(
      (localFailure) async {
        final remoteResult = await _remoteRepository.getProducts();
        return remoteResult.fold(
          (remoteFailure) => Left(remoteFailure),
          (products) async {
            await _localRepository.saveProducts(products);
            return Right(products);
          },
        );
      },
      (localProducts) {
        _refreshProductsInBackground();
        return Right(localProducts);
      },
    );
  }

  @override
  Future<Either<Failure, void>> saveProducts(List<ProductsEntity> products) async {
    return await _localRepository.saveProducts(products);
  }

  @override
  Future<Either<Failure, void>> clearProducts() async {
    return await _localRepository.clearProducts();
  }

  @override
  Future<Either<Failure, List<ProductsEntity>>> getProductsByCategory(String categoryId) async {
    final localResult = await _localRepository.getProductsByCategory(categoryId);
    return await localResult.fold(
      (localFailure) async {
        final remoteResult = await _remoteRepository.getProductsByCategory(categoryId);
        return remoteResult.fold(
          (remoteFailure) => Left(remoteFailure),
          (products) async {
            await _localRepository.saveProducts(products);
            return Right(products);
          },
        );
      },
      (localProducts) async {
        if (localProducts.isEmpty) {
          final remoteResult = await _remoteRepository.getProductsByCategory(categoryId);
          return remoteResult.fold(
            (remoteFailure) => Left(remoteFailure),
            (products) async {
              await _localRepository.saveProducts(products);
              return Right(products);
            },
          );
        }
        _refreshProductsByCategoryInBackground(categoryId);
        return Right(localProducts);
      },
    );
  }

  void _refreshProductsInBackground() async {
    try {
      final remoteResult = await _remoteRepository.getProducts();
      remoteResult.fold(
        (failure) {},
        (products) async {
          await _localRepository.saveProducts(products);
        },
      );
    } catch (e) {
      // Silent fail - user still sees local data
    }
  }

  void _refreshProductsByCategoryInBackground(String categoryId) async {
    try {
      final remoteResult = await _remoteRepository.getProductsByCategory(categoryId);
      remoteResult.fold(
        (failure) {},
        (products) async {
          await _localRepository.saveProducts(products);
        },
      );
    } catch (e) {
      // Silent fail - user still sees local data
    }
  }
}