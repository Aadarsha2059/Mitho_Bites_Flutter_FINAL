import 'package:equatable/equatable.dart';
import 'package:fooddelivery_b/app/constant/hive_table_constant.dart';
import 'package:fooddelivery_b/features/payment/domain/entity/payment_entity.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

part 'payment_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.paymentTableId)
class PaymentHiveModel extends Equatable {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String food;
  @HiveField(2)
  final int quantity;
  @HiveField(3)
  final double totalPrice;
  @HiveField(4)
  final String paymentMode;

  PaymentHiveModel({
    String? id,
    required this.food,
    required this.quantity,
    required this.totalPrice,
    required this.paymentMode,
  }) : id = id ?? const Uuid().v4();

  //initial constructor
  const PaymentHiveModel.initial() 
      : id = '', 
        food = '', 
        quantity = 0, 
        totalPrice = 0.0, 
        paymentMode = '';

  //from entity
  factory PaymentHiveModel.fromEntity(PaymentMethodEntity entity) {
    return PaymentHiveModel(
      id: entity.id,
      food: entity.food,
      quantity: entity.quantity,
      totalPrice: entity.totalPrice,
      paymentMode: entity.paymentMode,
    );
  }

  // to entity
  PaymentMethodEntity toEntity() {
    return PaymentMethodEntity(
      id: id,
      food: food,
      quantity: quantity,
      totalPrice: totalPrice,
      paymentMode: paymentMode,
    );
  }
  
  @override
  List<Object?> get props => [
    id,
    food,
    quantity,
    totalPrice,
    paymentMode,
  ];
}