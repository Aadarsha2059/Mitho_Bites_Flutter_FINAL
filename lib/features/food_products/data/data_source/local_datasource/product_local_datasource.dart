import 'package:fooddelivery_b/app/constant/hive_table_constant.dart';
import 'package:fooddelivery_b/core/network/hive_service.dart';
import 'package:fooddelivery_b/features/food_products/data/model/product_hive_model.dart';
import 'package:fooddelivery_b/features/food_products/domain/entity/products_entity.dart';
import 'package:fooddelivery_b/features/food_products/data/data_source/product_datasource.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ProductLocalDatasource implements IProductDataSource {
  final HiveService _hiveService;

  ProductLocalDatasource({required HiveService hiveService})
      : _hiveService = hiveService;

  @override
  Future<void> clearProducts() async {
    try {
      var box = await Hive.openBox<ProductHiveModel>(
        HiveTableConstant.productBox,
      );
      await box.clear();
    } catch (e) {
      throw Exception("Failed to clear products: $e");
    }
  }

  @override
  Future<List<ProductsEntity>> getAllProducts() async {
    try {
      var box = await Hive.openBox<ProductHiveModel>(
        HiveTableConstant.productBox,
      );
      return box.values.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception("Failed to get products: $e");
    }
  }

  @override
  Future<void> saveProducts(List<ProductsEntity> products) async {
    try {
      var box = await Hive.openBox<ProductHiveModel>(
        HiveTableConstant.productBox,
      );
      await box.clear();
      for (var product in products) {
        final hiveModel = ProductHiveModel.fromEntity(product);
        await box.put(hiveModel.productId, hiveModel);
      }
    } catch (e) {
      throw Exception("Failed to save products: $e");
    }
  }

  @override
  Future<List<ProductsEntity>> getProductsByCategory(String categoryId) async {
    try {
      var box = await Hive.openBox<ProductHiveModel>(
        HiveTableConstant.productBox,
      );
      return box.values
          .where((model) => model.categoryId == categoryId)
          .map((model) => model.toEntity())
          .toList();
    } catch (e) {
      throw Exception("Failed to get products by category: $e");
    }
  }
}