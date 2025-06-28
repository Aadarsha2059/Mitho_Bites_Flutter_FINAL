import 'package:equatable/equatable.dart';

class PaymentDataEntity extends Equatable {
  final String? paymentId;
  final String food; // Comma-separated product names
  final int quantity; // Total quantity
  final double totalPrice;
  final String paymentMode; // cash, card, online
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PaymentDataEntity({
    this.paymentId,
    required this.food,
    required this.quantity,
    required this.totalPrice,
    required this.paymentMode,
    this.createdAt,
    this.updatedAt,
  });

  // Convert to backend PaymentMethod format
  Map<String, dynamic> toMap() {
    return {
      'food': food,
      'quantity': quantity,
      'totalprice': totalPrice,
      'paymentmode': paymentMode,
    };
  }

  // Create from cart data
  factory PaymentDataEntity.fromCart({
    required List<String> itemNames,
    required int totalQuantity,
    required double totalAmount,
    String paymentMode = 'cash',
  }) {
    return PaymentDataEntity(
      food: itemNames.join(', '),
      quantity: totalQuantity,
      totalPrice: totalAmount,
      paymentMode: paymentMode,
    );
  }

  @override
  List<Object?> get props => [
    paymentId,
    food,
    quantity,
    totalPrice,
    paymentMode,
    createdAt,
    updatedAt,
  ];
} 