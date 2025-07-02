import 'package:equatable/equatable.dart';
import 'package:fooddelivery_b/app/constant/hive_table_constant.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

part 'order_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.orderTableId)
class OrderHiveModel extends Equatable {
  @HiveField(0)
  final String? id; // _id from backend
  @HiveField(1)
  final String userId;
  @HiveField(2)
  final List<dynamic> items; // List of order item maps
  @HiveField(3)
  final double totalAmount;
  @HiveField(4)
  final Map<String, dynamic>? deliveryAddress; // Address map
  @HiveField(5)
  final String deliveryInstructions;
  @HiveField(6)
  final String paymentMethod;
  @HiveField(7)
  final String paymentStatus;
  @HiveField(8)
  final String orderStatus;
  @HiveField(9)
  final DateTime? estimatedDeliveryTime;
  @HiveField(10)
  final DateTime? actualDeliveryTime;
  @HiveField(11)
  final DateTime? orderDate;
  @HiveField(12)
  final DateTime? createdAt;
  @HiveField(13)
  final DateTime? updatedAt;

  OrderHiveModel({
    String? id,
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
    this.orderDate,
    this.createdAt,
    this.updatedAt,
  }) : id = id ?? const Uuid().v4();

  // Initial constructor
  const OrderHiveModel.initial()
      : id = '',
        userId = '',
        items = const [],
        totalAmount = 0.0,
        deliveryAddress = null,
        deliveryInstructions = '',
        paymentMethod = '',
        paymentStatus = '',
        orderStatus = '',
        estimatedDeliveryTime = null,
        actualDeliveryTime = null,
        orderDate = null,
        createdAt = null,
        updatedAt = null;

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

  void copyWith({required String orderStatus, required String paymentStatus}) {}
} 