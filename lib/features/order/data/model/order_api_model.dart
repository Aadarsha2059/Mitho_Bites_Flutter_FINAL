import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_api_model.g.dart';

@JsonSerializable()
class OrderApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;
  final String userId;
  final List<Map<String, dynamic>> items;
  final double totalAmount;
  final Map<String, dynamic>? deliveryAddress;
  final String deliveryInstructions;
  final String paymentMethod; // "cash", "card", "online"
  final String paymentStatus; // "pending", "paid", "failed"
  final String orderStatus;   // "pending", "received", "cancelled"
  final DateTime? estimatedDeliveryTime;
  final DateTime? actualDeliveryTime;
  final DateTime orderDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  const OrderApiModel({
    this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    this.deliveryAddress,
    required this.deliveryInstructions,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.orderStatus,
    this.estimatedDeliveryTime,
    this.actualDeliveryTime,
    required this.orderDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderApiModel.fromJson(Map<String, dynamic> json) =>
      _$OrderApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderApiModelToJson(this);

  @override
  List<Object?> get props => [
        id,
        userId,
        items,
        totalAmount,
        deliveryAddress,
        deliveryInstructions,
        paymentMethod,
        paymentStatus,
        orderStatus,
        estimatedDeliveryTime,
        actualDeliveryTime,
        orderDate,
        createdAt,
        updatedAt,
      ];
}