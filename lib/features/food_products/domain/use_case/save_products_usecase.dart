import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/app/use_case/usecase.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/food_products/domain/entity/products_entity.dart';
import 'package:fooddelivery_b/features/food_products/domain/repository/products_repository.dart';


class SaveProductsUsecase implements UseCaseWithParams<void, List<ProductsEntity>> {
  final IProductRepository _productRepository;

  SaveProductsUsecase({required IProductRepository productRepository})
      : _productRepository = productRepository;

  @override
  Future<Either<Failure, void>> call(List<ProductsEntity> products) {
    return _productRepository.saveProducts(products);
  }
}