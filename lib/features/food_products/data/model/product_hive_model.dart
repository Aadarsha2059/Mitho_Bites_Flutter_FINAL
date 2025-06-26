import 'package:equatable/equatable.dart';
import 'package:fooddelivery_b/app/constant/hive_table_constant.dart';
import 'package:fooddelivery_b/features/food_products/domain/entity/products_entity.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:uuid/uuid.dart';

part 'product_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.productTableId)
class ProductHiveModel extends Equatable {
  @HiveField(0)
  final String? productId;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String type;
  @HiveField(3)
  final double price;
  @HiveField(4)
  final String description;
  @HiveField(5)
  final String? image;
  @HiveField(6)
  final String? categoryId;
  @HiveField(7)
  final String? restaurantId;
  @HiveField(8)
  final bool isAvailable;

  ProductHiveModel({
    String? productId,
    String? restaurantId,
    String? categoryId,
    required this.name,
    required this.type,
    required this.price,
    required this.description,
    required this.image,
    required this.isAvailable,
  })  : productId = productId ?? const Uuid().v4(),
        restaurantId = restaurantId,
        categoryId = categoryId;

  // Initial constructor
  const ProductHiveModel.initial()
      : productId = '',
        name = '',
        type = '',
        price = 0.0,
        description = '',
        image = '',
        categoryId = '',
        restaurantId = '',
        isAvailable = false;

  // from entity
  factory ProductHiveModel.fromEntity(ProductsEntity entity) {
    return ProductHiveModel(
      productId: entity.productId,
      restaurantId: entity.restaurantId,
      categoryId: entity.categoryId,
      name: entity.name,
      type: entity.type,
      price: entity.price,
      description: entity.description,
      image: entity.image,
      isAvailable: entity.isAvailable,
    );
  }

  // to entity
  ProductsEntity toEntity() {
    return ProductsEntity(
      productId: productId,
      restaurantId: restaurantId,
      categoryId: categoryId,
      name: name,
      type: type,
      price: price,
      description: description,
      image: image,
      isAvailable: isAvailable,
    );
  }

  @override
  List<Object?> get props => [
        productId,
        name,
        type,
        price,
        description,
        image,
        categoryId,
        restaurantId,
        isAvailable,
      ];
}