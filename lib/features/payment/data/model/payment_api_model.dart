import 'package:equatable/equatable.dart';
import 'package:fooddelivery_b/features/payment/domain/entity/payment_entity.dart';

import 'package:json_annotation/json_annotation.dart';

part 'payment_api_model.g.dart';

@JsonSerializable()
class PaymentApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;
  final String food;
  final int quantity;
  @JsonKey(name: 'totalprice')
  final double totalPrice;
  @JsonKey(name: 'paymentmode')
  final String paymentMode;

  const PaymentApiModel({
    this.id,
    required this.food,
    required this.quantity,
    required this.totalPrice,
    required this.paymentMode,
  });
  
  factory PaymentApiModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentApiModelToJson(this);

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

  //from entity
  factory PaymentApiModel.fromEntity(PaymentMethodEntity entity) {
    return PaymentApiModel(
      id: entity.id,
      food: entity.food,
      quantity: entity.quantity,
      totalPrice: entity.totalPrice,
      paymentMode: entity.paymentMode,
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