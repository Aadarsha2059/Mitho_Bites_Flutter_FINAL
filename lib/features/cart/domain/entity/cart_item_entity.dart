import 'package:equatable/equatable.dart';
import 'package:fooddelivery_b/features/food_products/domain/entity/products_entity.dart';

class CartItemEntity extends Equatable {
  final String? cartItemId;
  final ProductsEntity product;
  final int quantity;
  final double price;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CartItemEntity({
    this.cartItemId,
    required this.product,
    required this.quantity,
    required this.price,
    this.createdAt,
    this.updatedAt,
  });

  double get totalPrice => price * quantity;

  // Required fields for order creation (matching backend requirements)
  String get productName => product.name;
  String get categoryName => product.categoryName ?? 'Unknown Category';
  String get restaurantName => product.restaurantName ?? 'Unknown Restaurant';
  String get restaurantLocation => 'Location not available'; // Will be populated from backend
  String get foodType => product.type;

  // Convert to backend order item format
  Map<String, dynamic> toOrderItemMap() {
    return {
      'productId': product.productId,
      'quantity': quantity,
      'price': price,
      'productName': productName,
      'categoryName': categoryName,
      'restaurantName': restaurantName,
      'restaurantLocation': restaurantLocation,
      'foodType': foodType,
    };
  }

  @override
  List<Object?> get props => [
    cartItemId,
    product,
    quantity,
    price,
    createdAt,
    updatedAt,
  ];
}