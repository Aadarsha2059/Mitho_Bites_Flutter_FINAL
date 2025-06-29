import 'package:equatable/equatable.dart';
import 'package:fooddelivery_b/features/cart/domain/entity/cart_entity.dart';
import 'package:fooddelivery_b/features/cart/domain/entity/cart_item_entity.dart';
import 'package:fooddelivery_b/features/food_products/data/model/product_api_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:fooddelivery_b/app/constant/api_endpoints.dart';

part 'cart_api_model.g.dart';

@JsonSerializable()
class CartItemApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? cartItemId;
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final String? image;
  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;
  @JsonKey(name: 'updatedAt')
  final DateTime? updatedAt;

  const CartItemApiModel({
    this.cartItemId,
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory CartItemApiModel.fromJson(Map<String, dynamic> json) {
    // Handle complex productId object from backend
    String productId;
    String productName;
    String? image;
    
    if (json['productId'] is Map<String, dynamic>) {
      // Backend returns productId as an object
      final productObj = json['productId'] as Map<String, dynamic>;
      productId = productObj['_id'] as String;
      productName = productObj['name'] as String;
      image = productObj['image'] as String?;
    } else {
      // Fallback for simple string productId
      productId = json['productId'] as String;
      productName = json['productName'] as String? ?? '';
      image = json['image'] as String?;
    }
    
    return CartItemApiModel(
      cartItemId: json['_id'] as String?,
      productId: productId,
      productName: productName,
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int,
      image: image,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': cartItemId,
    'productId': productId,
    'productName': productName,
    'price': price,
    'quantity': quantity,
    'image': image,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };

  // to entity
  CartItemEntity toEntity() {
    return CartItemEntity(
      cartItemId: cartItemId,
      productId: productId,
      productName: productName,
      productType: 'food',
      productPrice: price,
      productDescription: '',
      productImage: image,
      categoryId: null,
      restaurantId: null,
      isAvailable: true,
      categoryName: null,
      categoryImage: null,
      restaurantName: null,
      restaurantImage: null,
      restaurantLocation: null,
      restaurantContact: null,
      quantity: quantity,
      price: price,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // from entity
  factory CartItemApiModel.fromEntity(CartItemEntity entity) {
    return CartItemApiModel(
      cartItemId: entity.cartItemId,
      productId: entity.productId,
      productName: entity.productName,
      price: entity.price,
      quantity: entity.quantity,
      image: entity.productImage,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    cartItemId,
    productId,
    productName,
    price,
    quantity,
    image,
    createdAt,
    updatedAt,
  ];
}

@JsonSerializable()
class CartApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? cartId;
  final String? userId;
  final List<CartItemApiModel> items;
  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;
  @JsonKey(name: 'updatedAt')
  final DateTime? updatedAt;

  const CartApiModel({
    this.cartId,
    this.userId,
    required this.items,
    this.createdAt,
    this.updatedAt,
  });

  factory CartApiModel.fromJson(Map<String, dynamic> json) => CartApiModel(
    cartId: json['_id'] as String?,
    userId: json['userId'] as String?,
    items: (json['items'] as List<dynamic>)
        .map((item) => CartItemApiModel.fromJson(item as Map<String, dynamic>))
        .toList(),
    createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
    updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
  );

  Map<String, dynamic> toJson() => {
    '_id': cartId,
    'userId': userId,
    'items': items.map((item) => item.toJson()).toList(),
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };

  // to entity
  CartEntity toEntity() {
    return CartEntity(
      cartId: cartId,
      userId: userId,
      items: items.map((item) => item.toEntity()).toList(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // from entity
  factory CartApiModel.fromEntity(CartEntity entity) {
    return CartApiModel(
      cartId: entity.cartId,
      userId: entity.userId,
      items: entity.items.map((item) => CartItemApiModel.fromEntity(item)).toList(),
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    cartId,
    userId,
    items,
    createdAt,
    updatedAt,
  ];
}

// Response wrapper for cart API - matches your web API response structure
@JsonSerializable()
class CartResponseModel extends Equatable {
  final bool success;
  final String message;
  final CartApiModel? data;

  const CartResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory CartResponseModel.fromJson(Map<String, dynamic> json) => CartResponseModel(
    success: json['success'] as bool,
    message: json['message'] as String,
    data: json['data'] != null ? CartApiModel.fromJson(json['data'] as Map<String, dynamic>) : null,
  );

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'data': data?.toJson(),
  };

  CartEntity? toEntity() {
    return data?.toEntity();
  }

  @override
  List<Object?> get props => [success, message, data];
}

// Request models for cart operations
@JsonSerializable()
class AddToCartRequestModel extends Equatable {
  final String productId;
  final int quantity;
  final double price;

  const AddToCartRequestModel({
    required this.productId,
    required this.quantity,
    required this.price,
  });

  factory AddToCartRequestModel.fromJson(Map<String, dynamic> json) => AddToCartRequestModel(
    productId: json['productId'] as String,
    quantity: json['quantity'] as int,
    price: (json['price'] as num).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'quantity': quantity,
    'price': price,
  };

  @override
  List<Object?> get props => [productId, quantity, price];
}

@JsonSerializable()
class UpdateCartItemRequestModel extends Equatable {
  final String productId;
  final int quantity;

  const UpdateCartItemRequestModel({
    required this.productId,
    required this.quantity,
  });

  factory UpdateCartItemRequestModel.fromJson(Map<String, dynamic> json) => UpdateCartItemRequestModel(
    productId: json['productId'] as String,
    quantity: json['quantity'] as int,
  );

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'quantity': quantity,
  };

  @override
  List<Object?> get props => [productId, quantity];
}