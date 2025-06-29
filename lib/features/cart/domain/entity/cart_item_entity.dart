import 'package:equatable/equatable.dart';

class CartItemEntity extends Equatable {
  final String? cartItemId;
  final String productId;
  final String productName;
  final String productType;
  final double productPrice;
  final String productDescription;
  final String? productImage;
  final String? categoryId;
  final String? restaurantId;
  final bool isAvailable;
  final String? categoryName;
  final String? categoryImage;
  final String? restaurantName;
  final String? restaurantImage;
  final String? restaurantLocation;
  final String? restaurantContact;
  final int quantity;
  final double price;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CartItemEntity({
    this.cartItemId,
    required this.productId,
    required this.productName,
    this.productType = 'food',
    required this.productPrice,
    this.productDescription = '',
    this.productImage,
    this.categoryId,
    this.restaurantId,
    this.isAvailable = true,
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
  });

  double get totalPrice => price * quantity;

  // Convert to backend order item format
  Map<String, dynamic> toOrderItemMap() {
    return {
      'productId': productId,
      'quantity': quantity,
      'price': price,
      'productName': productName,
    };
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

  copyWith({required int quantity}) {}
}