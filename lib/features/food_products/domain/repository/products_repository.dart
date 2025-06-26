import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/food_products/domain/entity/products_entity.dart';

abstract interface class IProductRepository {
  Future<Either<Failure, List<ProductsEntity>>> getProducts();
  Future<Either<Failure, void>> saveProducts(List<ProductsEntity> products);
  Future<Either<Failure, void>> clearProducts();
  Future<Either<Failure, List<ProductsEntity>>> getProductsByCategory(String categoryId);
}