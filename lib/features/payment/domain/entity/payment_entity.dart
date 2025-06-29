import 'package:equatable/equatable.dart';

class PaymentMethodEntity extends Equatable {
  final String? id;
  final String food;
  final int quantity;
  final double totalPrice;
  final String paymentMode;

  const PaymentMethodEntity({
    this.id,
    required this.food,
    required this.quantity,
    required this.totalPrice,
    required this.paymentMode,
  });

  @override
  List<Object?> get props => [id, food, quantity, totalPrice, paymentMode];
}
