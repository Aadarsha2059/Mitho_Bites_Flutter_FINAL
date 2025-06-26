import 'package:fooddelivery_b/features/food_products/domain/entity/products_entity.dart';

abstract interface class IProductDataSource {
  Future<List<ProductsEntity>> getAllProducts();
  Future<void> saveProducts(List<ProductsEntity> products);
  Future<void> clearProducts();
  Future<List<ProductsEntity>> getProductsByCategory(String categoryId);
}
