import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/food_products/data/data_source/remote_datasource/product_remote_datasource.dart';
import 'package:fooddelivery_b/features/food_products/domain/entity/products_entity.dart';

import 'package:fooddelivery_b/features/food_products/domain/repository/products_repository.dart';

class ProductRemoteRepository implements IProductRepository {
  final ProductRemoteDatasource _productRemoteDatasource;

  ProductRemoteRepository({
    required ProductRemoteDatasource productRemoteDatasource,
  }) : _productRemoteDatasource = productRemoteDatasource;

  @override
  Future<Either<Failure, List<ProductsEntity>>> getProducts() async {
    try {
      final products = await _productRemoteDatasource.getAllProducts();
      return Right(products);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveProducts(List<ProductsEntity> products) async {
    try {
      await _productRemoteDatasource.saveProducts(products);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearProducts() async {
    try {
      await _productRemoteDatasource.clearProducts();
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductsEntity>>> getProductsByCategory(String categoryId) async {
    try {
      final products = await _productRemoteDatasource.getProductsByCategory(categoryId);
      return Right(products);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
}