import 'package:equatable/equatable.dart';
import 'package:fooddelivery_b/features/cart/domain/entity/cart_entity.dart';
import 'package:fooddelivery_b/features/cart/domain/entity/cart_item_entity.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'cart_hive_model.g.dart';

@HiveType(typeId: 4)
class CartItemHiveModel extends Equatable {
  @HiveField(0)
  final String? cartItemId;
  @HiveField(1)
  final String productId;
  @HiveField(2)
  final String productName;
  @HiveField(3)
  final String productType;
  @HiveField(4)
  final double productPrice;
  @HiveField(5)
  final String productDescription;
  @HiveField(6)
  final String? productImage;
  @HiveField(7)
  final String? categoryId;
  @HiveField(8)
  final String? restaurantId;
  @HiveField(9)
  final bool isAvailable;
  @HiveField(10)
  final String? categoryName;
  @HiveField(11)
  final String? categoryImage;
  @HiveField(12)
  final String? restaurantName;
  @HiveField(13)
  final String? restaurantImage;
  @HiveField(14)
  final String? restaurantLocation;
  @HiveField(15)
  final String? restaurantContact;
  @HiveField(16)
  final int quantity;
  @HiveField(17)
  final double price;
  @HiveField(18)
  final DateTime? createdAt;
  @HiveField(19)
  final DateTime? updatedAt;

  CartItemHiveModel({
    String? cartItemId,
    required this.productId,
    required this.productName,
    required this.productType,
    required this.productPrice,
    required this.productDescription,
    this.productImage,
    this.categoryId,
    this.restaurantId,
    required this.isAvailable,
    this.categoryName,
    this.categoryImage,
    this.restaurantName,
    this.restaurantImage,
    this.restaurantLocation,
    this.restaurantContact,
    required this.quantity,
    required this.price,
    this.createdAt,
    this.updatedAt,
  }) : cartItemId = cartItemId ?? const Uuid().v4();

  // Initial constructor
  const CartItemHiveModel.initial()
      : cartItemId = '',
        productId = '',
        productName = '',
        productType = '',
        productPrice = 0.0,
        productDescription = '',
        productImage = '',
        categoryId = '',
        restaurantId = '',
        isAvailable = false,
        categoryName = '',
        categoryImage = '',
        restaurantName = '',
        restaurantImage = '',
        restaurantLocation = '',
        restaurantContact = '',
        quantity = 0,
        price = 0.0,
        createdAt = null,
        updatedAt = null;

  // from entity
  factory CartItemHiveModel.fromEntity(CartItemEntity entity) {
    return CartItemHiveModel(
      cartItemId: entity.cartItemId,
      productId: entity.productId,
      productName: entity.productName,
      productType: entity.productType,
      productPrice: entity.productPrice,
      productDescription: entity.productDescription,
      productImage: entity.productImage,
      categoryId: entity.categoryId,
      restaurantId: entity.restaurantId,
      isAvailable: entity.isAvailable,
      categoryName: entity.categoryName,
      categoryImage: entity.categoryImage,
      restaurantName: entity.restaurantName,
      restaurantImage: entity.restaurantImage,
      restaurantLocation: entity.restaurantLocation,
      restaurantContact: entity.restaurantContact,
      quantity: entity.quantity,
      price: entity.price,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  // to entity
  CartItemEntity toEntity() {
    return CartItemEntity(
      cartItemId: cartItemId,
      productId: productId,
      productName: productName,
      productType: productType,
      productPrice: productPrice,
      productDescription: productDescription,
      productImage: productImage,
      categoryId: categoryId,
      restaurantId: restaurantId,
      isAvailable: isAvailable,
      categoryName: categoryName,
      categoryImage: categoryImage,
      restaurantName: restaurantName,
      restaurantImage: restaurantImage,
      restaurantLocation: restaurantLocation,
      restaurantContact: restaurantContact,
      quantity: quantity,
      price: price,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    cartItemId,
    productId,
    productName,
    productType,
    productPrice,
    productDescription,
    productImage,
    categoryId,
    restaurantId,
    isAvailable,
    categoryName,
    categoryImage,
    restaurantName,
    restaurantImage,
    restaurantLocation,
    restaurantContact,
    quantity,
    price,
    createdAt,
    updatedAt,
  ];
}

@HiveType(typeId: 7)
class CartHiveModel extends Equatable {
  @HiveField(0)
  final String? cartId;
  @HiveField(1)
  final String? userId;
  @HiveField(2)
  final List<String> itemIds;
  @HiveField(3)
  final DateTime? createdAt;
  @HiveField(4)
  final DateTime? updatedAt;

  CartHiveModel({
    String? cartId,
    this.userId,
    required this.itemIds,
    this.createdAt,
    this.updatedAt,
  }) : cartId = cartId ?? const Uuid().v4();

  // Initial constructor - Fixed: Removed const and used empty list
  CartHiveModel.initial()
      : cartId = '',
        userId = '',
        itemIds = <String>[],
        createdAt = null,
        updatedAt = null;

  // from entity
  factory CartHiveModel.fromEntity(CartEntity entity) {
    return CartHiveModel(
      cartId: entity.cartId,
      userId: entity.userId,
      itemIds: entity.items.map((item) => item.cartItemId ?? '').toList(),
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  // to entity
  CartEntity toEntity({List<CartItemEntity> items = const []}) {
    return CartEntity(
      cartId: cartId,
      userId: userId,
      items: items,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    cartId,
    userId,
    itemIds,
    createdAt,
    updatedAt,
  ];
}