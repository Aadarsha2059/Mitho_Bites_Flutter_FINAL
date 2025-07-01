import 'package:equatable/equatable.dart';

class OrderEntity extends Equatable {
  final String? id; // _id from backend
  final String userId;
  final List<dynamic> items; // List of order item maps
  final double totalAmount;
  final Map<String, dynamic>? deliveryAddress; // Address map
  final String deliveryInstructions;
  final String paymentMethod; // "cash", "card", "online"
  final String paymentStatus; // "pending", "paid", "failed"
  final String orderStatus;   // "pending", "received", "cancelled"
  final DateTime? estimatedDeliveryTime;
  final DateTime? actualDeliveryTime;
  final DateTime orderDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  const OrderEntity({
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

  factory OrderEntity.fromJson(Map<String, dynamic> json) {
    // Defensive: Ensure items is always a List<Map<String, dynamic>>
    final rawItems = json['items'];
    final List<Map<String, dynamic>> safeItems = (rawItems is List)
        ? rawItems.map((e) => e is Map<String, dynamic> ? e : Map<String, dynamic>.from(e as Map)).toList()
        : <Map<String, dynamic>>[];
    return OrderEntity(
      id: json['_id'] as String?,
      userId: json['userId'] as String,
      items: safeItems,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      deliveryAddress: json['deliveryAddress'] as Map<String, dynamic>?,
      deliveryInstructions: json['deliveryInstructions'] ?? '',
      paymentMethod: json['paymentMethod'] as String,
      paymentStatus: json['paymentStatus'] as String,
      orderStatus: json['orderStatus'] as String,
      estimatedDeliveryTime: json['estimatedDeliveryTime'] != null
          ? DateTime.parse(json['estimatedDeliveryTime'])
          : null,
      actualDeliveryTime: json['actualDeliveryTime'] != null
          ? DateTime.parse(json['actualDeliveryTime'])
          : null,
      orderDate: DateTime.parse(json['orderDate']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'userId': userId,
    'items': items,
    'totalAmount': totalAmount,
    'deliveryAddress': deliveryAddress,
    'deliveryInstructions': deliveryInstructions,
    'paymentMethod': paymentMethod,
    'paymentStatus': paymentStatus,
    'orderStatus': orderStatus,
    'estimatedDeliveryTime': estimatedDeliveryTime?.toIso8601String(),
    'actualDeliveryTime': actualDeliveryTime?.toIso8601String(),
    'orderDate': orderDate.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}