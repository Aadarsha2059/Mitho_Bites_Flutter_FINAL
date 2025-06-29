import 'package:equatable/equatable.dart';
import 'package:fooddelivery_b/features/cart/domain/entity/cart_item_entity.dart';

class CartEntity extends Equatable {
  final String? cartId;
  final String? userId;
  final List<CartItemEntity> items;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CartEntity({
    this.cartId,
    this.userId,
    required this.items,
    this.createdAt,
    this.updatedAt,
  });

  double get totalAmount => items.fold(0, (sum, item) => sum + item.totalPrice);
  
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
  
  int get uniqueItemCount => items.length;

  bool get isEmpty => items.isEmpty;

  CartItemEntity? getItemByProductId(String productId) {
    try {
      return items.firstWhere((item) => item.productId == productId);
    } catch (e) {
      return null;
    }
  }

  // Convert to backend order format (matching Order model requirements)
  Map<String, dynamic> toOrderMap({
    required String userId,
    String deliveryInstructions = '',
    String paymentMethod = 'cash',
    Map<String, String>? deliveryAddress,
  }) {
    return {
      'userId': userId,
      'items': items.map((item) => item.toOrderItemMap()).toList(),
      'totalAmount': totalAmount,
      'deliveryAddress': deliveryAddress ?? {
        'street': 'User address',
        'city': 'User city',
        'state': 'User state',
        'zipCode': 'User zip',
        'country': 'Nepal',
      },
      'deliveryInstructions': deliveryInstructions,
      'paymentMethod': paymentMethod,
    };
  }

  // Convert to backend payment format (matching PaymentMethod model requirements)
  Map<String, dynamic> toPaymentMap({String paymentMode = 'cash'}) {
    return {
      'food': items.map((item) => item.productName).join(', '),
      'quantity': itemCount,
      'totalprice': totalAmount,
      'paymentmode': paymentMode,
    };
  }

  // Get summary for payment display
  Map<String, dynamic> getPaymentSummary() {
    return {
      'totalItems': itemCount,
      'uniqueItems': uniqueItemCount,
      'subtotal': totalAmount,
      'deliveryFee': 50.0, // Fixed delivery fee
      'totalAmount': totalAmount + 50.0,
      'itemNames': items.map((item) => item.productName).toList(),
    };
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