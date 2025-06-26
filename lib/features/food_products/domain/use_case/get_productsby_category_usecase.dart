import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/app/use_case/usecase.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/food_products/domain/entity/products_entity.dart';
import 'package:fooddelivery_b/features/food_products/domain/repository/products_repository.dart';


class GetProductsByCategoryUsecase implements UseCaseWithParams<List<ProductsEntity>, String> {
  final IProductRepository _productRepository;

  GetProductsByCategoryUsecase({required IProductRepository productRepository})
      : _productRepository = productRepository;

  @override
  Future<Either<Failure, List<ProductsEntity>>> call(String categoryId) {
    return _productRepository.getProductsByCategory(categoryId);
  }
}