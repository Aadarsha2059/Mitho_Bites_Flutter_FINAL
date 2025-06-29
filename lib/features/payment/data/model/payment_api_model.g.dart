// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentApiModel _$PaymentApiModelFromJson(Map<String, dynamic> json) =>
    PaymentApiModel(
      id: json['_id'] as String?,
      food: json['food'] as String,
      quantity: (json['quantity'] as num).toInt(),
      totalPrice: (json['totalprice'] as num).toDouble(),
      paymentMode: json['paymentmode'] as String,
    );

Map<String, dynamic> _$PaymentApiModelToJson(PaymentApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'food': instance.food,
      'quantity': instance.quantity,
      'totalprice': instance.totalPrice,
      'paymentmode': instance.paymentMode,
    };
