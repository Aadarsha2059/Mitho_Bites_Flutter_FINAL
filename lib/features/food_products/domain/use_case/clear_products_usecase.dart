import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/app/use_case/usecase.dart';
import 'package:fooddelivery_b/core/error/failure.dart';

import 'package:fooddelivery_b/features/food_products/domain/repository/products_repository.dart';

class ClearProductsUsecase implements UsecaseWithoutParams<void> {
  final IProductRepository _productRepository;

  ClearProductsUsecase({required IProductRepository productRepository})
      : _productRepository = productRepository;

  @override
  Future<Either<Failure, void>> call() {
    return _productRepository.clearProducts();
  }
}