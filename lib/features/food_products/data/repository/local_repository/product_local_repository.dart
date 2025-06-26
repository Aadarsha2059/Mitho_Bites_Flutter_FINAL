import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/food_products/data/data_source/local_datasource/product_local_datasource.dart';
import 'package:fooddelivery_b/features/food_products/domain/entity/products_entity.dart';

import 'package:fooddelivery_b/features/food_products/domain/repository/products_repository.dart';

class ProductLocalRepository implements IProductRepository {
  final ProductLocalDatasource _productLocalDatasource;

  ProductLocalRepository({
    required ProductLocalDatasource productLocalDatasource,
  }) : _productLocalDatasource = productLocalDatasource;

  @override
  Future<Either<Failure, void>> clearProducts() async {
    try {
      await _productLocalDatasource.clearProducts();
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductsEntity>>> getProducts() async {
    try {
      final products = await _productLocalDatasource.getAllProducts();
      return Right(products);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveProducts(
    List<ProductsEntity> products,
  ) async {
    try {
      await _productLocalDatasource.saveProducts(products);
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductsEntity>>> getProductsByCategory(String categoryId) async {
    try {
      final products = await _productLocalDatasource.getProductsByCategory(categoryId);
      return Right(products);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}